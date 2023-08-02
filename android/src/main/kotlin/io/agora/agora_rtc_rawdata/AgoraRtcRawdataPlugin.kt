package io.agora.agora_rtc_rawdata

import android.content.Context
import android.opengl.EGL14
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.os.Message
import android.os.SystemClock
import android.util.Log
import androidx.annotation.NonNull
import com.faceunity.core.entity.FURenderInputData
import com.faceunity.core.entity.FURenderOutputData
import com.faceunity.core.enumeration.CameraFacingEnum
import com.faceunity.core.enumeration.FUInputBufferEnum
import com.faceunity.core.enumeration.FUTransformMatrixEnum
import com.faceunity.core.faceunity.FUAIKit
import com.faceunity.core.faceunity.FURenderKit
import com.faceunity.core.model.facebeauty.FaceBeautyBlurTypeEnum
import com.faceunity.wrapper.faceunity
import io.agora.rtc.rawdata.base.AudioFrame
import io.agora.rtc.rawdata.base.IAudioFrameObserver
import io.agora.rtc.rawdata.base.IVideoFrameObserver
import io.agora.rtc.rawdata.base.VideoFrame
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference
import java.util.*


/** AgoraRtcRawdataPlugin */
class AgoraRtcRawdataPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  private var audioObserver: IAudioFrameObserver? = null
  private var videoObserver: IVideoFrameObserver? = null

  private var fuRenderInputData: FURenderInputData? = null
  private var fuRenderOutputData: FURenderOutputData? = null
  private val renderLock = Object()
  private lateinit var renderThread: HandlerThread

  private var fuHandler: Handler? = null
  private var deviceLevel = 0
  @Volatile
  private var renderStop = false

  private class FuHandler(looper: Looper, plugin: AgoraRtcRawdataPlugin) : Handler(looper) {
    private val mPluginWeakReference: WeakReference<AgoraRtcRawdataPlugin> = WeakReference(plugin)

    override fun handleMessage(msg: Message) {
      val plugin = mPluginWeakReference.get() ?: return
      when(msg.what) {
        MSG_FACEUNITY -> synchronized(plugin.renderLock) {

          try {
            val handle = EGL14.eglGetCurrentContext().handle
            Log.d(TAG, "handleMessage: MSG_FACEUNITY： $handle")

            if (handle <= 0) {
              // 不存在egl环境，重新创建
              FURenderKit.getInstance().createEGLContext()
            }
          }catch (_: UnsupportedOperationException) {
            // 存在egl环境
          }

          if (plugin.deviceLevel > FuDeviceUtils.DEVICE_LEVEL_MID) {
            //高性能设备
            plugin.cheekFaceNum()
          }

          plugin.fuRenderOutputData = FURenderKit.getInstance().renderWithInput(plugin.fuRenderInputData!!)
          plugin.renderLock.notifyAll()
          Log.d(TAG, "handleMessage: MSG_FACEUNITY")
        }
        MSG_EGL_CREATE -> synchronized(plugin.renderLock) {
          // 因为 gles 的创建是在 raw_data 这个插件 onAttachedToEngine方法中调用，
          // 但是 faceunity的鉴权也在 faceunity_plugin 插件的这个方法中调用，而且由于鉴权方法时异步的，很有可能导致 createEGLContext 调用时，
          // 鉴权还未完成，sdk还未初始化
          while (faceunity.fuIsLibraryInit() != 1 && !plugin.renderStop) {
            SystemClock.sleep(100)
          }
          FURenderKit.getInstance().createEGLContext()
          Log.d(TAG, "handleMessage: MSG_EGL_CREATE")
        }
        MSG_EGL_RELEASE -> {
          FURenderKit.getInstance().releaseEGLContext()
          FURenderKit.getInstance().releaseSafe()
          Log.d(TAG, "handleMessage: MSG_EGL_RELEASE")
        }
        else -> {}
      }
    }
  }

  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "agora_rtc_rawdata")
    channel.setMethodCallHandler(this)

    deviceLevel = FuDeviceUtils.judgeDeviceLevelGPU()

    renderThread = HandlerThread("fuRenderer")
    renderThread.start()
    fuHandler = FuHandler(renderThread.looper, this)
    fuHandler!!.sendEmptyMessage(MSG_EGL_CREATE)

    context = flutterPluginBinding.applicationContext
    renderStop = false

    Log.d(TAG, "onAttachedToEngine")
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "registerAudioFrameObserver" -> {
        if (audioObserver == null) {
          audioObserver = object : IAudioFrameObserver((call.arguments as Number).toLong()) {
            override fun onRecordAudioFrame(audioFrame: AudioFrame): Boolean {
              return true
            }

            override fun onPlaybackAudioFrame(audioFrame: AudioFrame): Boolean {
              return true
            }

            override fun onMixedAudioFrame(audioFrame: AudioFrame): Boolean {
              return true
            }

            override fun onPlaybackAudioFrameBeforeMixing(uid: Int, audioFrame: AudioFrame): Boolean {
              return true
            }
          }
        }
        audioObserver?.registerAudioFrameObserver()
        result.success(null)
      }
      "unregisterAudioFrameObserver" -> {
        audioObserver?.let {
          it.unregisterAudioFrameObserver()
          audioObserver = null
        }
        result.success(null)
      }
      "registerVideoFrameObserver" -> {
        if (videoObserver == null) {
          videoObserver = object : IVideoFrameObserver((call.arguments as Number).toLong()) {
            private var oldRotation = 0
            private var skipFrame = SKIP_FRAME

            override fun onCaptureVideoFrame(sourceType: Int, videoFrame: VideoFrame): Boolean {
              Log.d(TAG, "handleMessage: onCaptureVideoFrame: sourceType:$sourceType, rotation:${videoFrame.rotation}, width: ${videoFrame.width}, height: ${videoFrame.height}")
              /** 这个回调不一定在同一线程执行 */
              synchronized(renderLock) {
                if (fuRenderInputData == null) {
                  fuRenderInputData = FURenderInputData(videoFrame.getyStride(), videoFrame.height)
                }
                if (fuRenderInputData!!.width != videoFrame.getyStride() || fuRenderInputData!!.height != videoFrame.height) {
                  /** 部分机型前几帧的宽高和后面不同 **/
                  fuRenderInputData = FURenderInputData(videoFrame.getyStride(), videoFrame.height)
                }
                if (oldRotation != videoFrame.rotation) {
                  oldRotation = videoFrame.rotation
                  skipFrame = SKIP_FRAME
                }
                fuRenderInputData!!.apply {

                  val i420 = videoFrame.getyBuffer() + videoFrame.getuBuffer() + videoFrame.getvBuffer()
                  imageBuffer = FURenderInputData.FUImageBuffer(FUInputBufferEnum.FU_FORMAT_I420_BUFFER, i420)
                  renderConfig.apply {
                    isNeedBufferReturn = true
                    inputOrientation = 360 - videoFrame.rotation
                    if (videoFrame.rotation == 270) {
                      //前置
                      cameraFacing = CameraFacingEnum.CAMERA_FRONT
                      inputBufferMatrix = FUTransformMatrixEnum.CCROT0_FLIPVERTICAL
                      inputTextureMatrix = FUTransformMatrixEnum.CCROT0_FLIPVERTICAL
                      outputMatrix = FUTransformMatrixEnum.CCROT0
                    }else {
                      cameraFacing = CameraFacingEnum.CAMERA_BACK
                      inputBufferMatrix = FUTransformMatrixEnum.CCROT0
                      inputTextureMatrix = FUTransformMatrixEnum.CCROT0
                      outputMatrix = FUTransformMatrixEnum.CCROT0_FLIPVERTICAL
                    }
                  }
                }
                if (renderStop) {
                  return true
                }
                fuHandler?.sendEmptyMessage(MSG_FACEUNITY)
                renderLock.wait()
                if (skipFrame-- < 0) {
                  videoFrame.apply {
                    System.arraycopy(fuRenderOutputData!!.image!!.buffer!!, 0, getyBuffer(), 0, getyBuffer().size)
                    System.arraycopy(fuRenderOutputData!!.image!!.buffer!!, getyBuffer().size, getuBuffer(), 0, getuBuffer().size)
                    System.arraycopy(fuRenderOutputData!!.image!!.buffer!!, getyBuffer().size + getuBuffer().size, getvBuffer(), 0, getvBuffer().size)
                  }
                }
              }
              return true
            }

            override fun onRenderVideoFrame(uid: Int, videoFrame: VideoFrame): Boolean {
              // unsigned char value 255
              return true
            }
          }
        }
        videoObserver?.registerVideoFrameObserver()
        result.success(null)
      }
      "unregisterVideoFrameObserver" -> {
        videoObserver?.let {
          it.unregisterVideoFrameObserver()
          videoObserver = null
        }
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)

    renderStop = true
    fuHandler?.sendEmptyMessage(MSG_EGL_RELEASE)
    renderThread.quitSafely()
    Log.d(TAG, "onDetachedFromEngine")
  }

  private fun cheekFaceNum() {
    //根据有无人脸 + 设备性能 判断开启的磨皮类型
    val faceProcessorGetConfidenceScore = FUAIKit.getInstance().getFaceProcessorGetConfidenceScore(0)
    if (faceProcessorGetConfidenceScore >= 0.95) {
      //高端手机并且检测到人脸开启均匀磨皮，人脸点位质

      FURenderKit.getInstance().faceBeauty?.let {
        if (it.blurType != FaceBeautyBlurTypeEnum.EquallySkin) {
          it.blurType = FaceBeautyBlurTypeEnum.EquallySkin
          it.enableBlurUseMask = true
        }
      }
    } else {
      FURenderKit.getInstance().faceBeauty?.let {
        if (it.blurType != FaceBeautyBlurTypeEnum.FineSkin) {
          it.blurType = FaceBeautyBlurTypeEnum.FineSkin
          it.enableBlurUseMask = false
        }
      }
    }
  }

  companion object {
    // Used to load the 'native-lib' library on application startup.
    init {
      System.loadLibrary("cpp")
    }
    private const val TAG = "AgoraRtcRawdataPlugin"
    private const val MSG_FACEUNITY = 0x01
    private const val MSG_EGL_CREATE = 0x02
    private const val MSG_EGL_RELEASE = 0x03
    private const val SKIP_FRAME = 2
  }
}
