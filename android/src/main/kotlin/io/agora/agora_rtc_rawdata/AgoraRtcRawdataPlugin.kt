package io.agora.agora_rtc_rawdata

import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.os.Message
import androidx.annotation.NonNull
import com.faceunity.core.entity.FURenderInputData
import com.faceunity.core.entity.FURenderOutputData
import com.faceunity.core.enumeration.CameraFacingEnum
import com.faceunity.core.enumeration.FUInputBufferEnum
import com.faceunity.core.enumeration.FUTransformMatrixEnum
import com.faceunity.core.faceunity.FURenderKit
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
  private val renderThread = HandlerThread("fuRenderer")

  private var fuHandler: Handler? = null
  private class FuHandler(looper: Looper, plugin: AgoraRtcRawdataPlugin) : Handler(looper) {
    private val mPluginWeakReference: WeakReference<AgoraRtcRawdataPlugin> = WeakReference(plugin)

    override fun handleMessage(msg: Message) {
      val plugin = mPluginWeakReference.get() ?: return
      when(msg.what) {
        MSG_FACEUNITY -> synchronized(plugin.renderLock) {
          plugin.fuRenderOutputData = FURenderKit.getInstance().renderWithInput(plugin.fuRenderInputData!!)
          plugin.renderLock.notifyAll()
        }
        MSG_EGL_CREATE -> synchronized(plugin.renderLock) { FURenderKit.getInstance().createEGLContext() }
        MSG_EGL_RELEASE -> FURenderKit.getInstance().releaseEGLContext()
      }
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "agora_rtc_rawdata")
    channel.setMethodCallHandler(this)

    renderThread.start()
    fuHandler = FuHandler(renderThread.looper, this)
    fuHandler!!.sendEmptyMessage(MSG_EGL_CREATE)
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
            override fun onCaptureVideoFrame(videoFrame: VideoFrame): Boolean {
              /** 这个回调不一定在同一线程执行 */
              synchronized(renderLock) {
                if (fuRenderInputData == null) {
                  fuRenderInputData = FURenderInputData(videoFrame.width, videoFrame.height)
                }
                if (fuRenderInputData!!.width != videoFrame.width || fuRenderInputData!!.height != videoFrame.height) {
                  /** 部分机型前几帧的宽高和后面不同 **/
                  fuRenderInputData = FURenderInputData(videoFrame.width, videoFrame.height)
                }
                fuRenderInputData!!.apply {
                  imageBuffer = FURenderInputData.FUImageBuffer(FUInputBufferEnum.FU_FORMAT_YUV_BUFFER, videoFrame.getyBuffer(), videoFrame.getuBuffer(), videoFrame.getvBuffer())
                  renderConfig.apply {
                    isNeedBufferReturn = true
                    cameraFacing = if (videoFrame.rotation == 270) CameraFacingEnum.CAMERA_FRONT else CameraFacingEnum.CAMERA_BACK
                    if (videoFrame.rotation == 270) {
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
                fuHandler?.sendEmptyMessage(MSG_FACEUNITY)
                renderLock.wait()
                videoFrame.apply {
                  System.arraycopy(fuRenderOutputData!!.image!!.buffer!!, 0, getyBuffer(), 0, getyBuffer().size)
                  System.arraycopy(fuRenderOutputData!!.image!!.buffer1!!, 0, getuBuffer(), 0, getuBuffer().size)
                  System.arraycopy(fuRenderOutputData!!.image!!.buffer2!!, 0, getvBuffer(), 0, getvBuffer().size)
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
          fuHandler?.sendEmptyMessage(MSG_EGL_RELEASE)
          FURenderKit.getInstance().release()
        }
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    renderThread.quitSafely()
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
  }
}
