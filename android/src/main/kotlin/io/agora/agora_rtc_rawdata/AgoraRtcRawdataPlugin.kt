package io.agora.agora_rtc_rawdata

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.faceunity.core.entity.FURenderInputData
import com.faceunity.core.entity.FURenderOutputData
import com.faceunity.core.enumeration.CameraFacingEnum
import com.faceunity.core.enumeration.FUInputBufferEnum
import com.faceunity.core.enumeration.FUTransformMatrixEnum
import com.faceunity.core.faceunity.FUAIKit
import com.faceunity.core.faceunity.FURenderKit
import com.faceunity.core.faceunity.OffLineRenderHandler
import com.faceunity.core.model.facebeauty.FaceBeautyBlurTypeEnum
import com.faceunity.faceunity_plugin.FaceunityKit
import io.agora.rtc.rawdata.base.AudioFrame
import io.agora.rtc.rawdata.base.IAudioFrameObserver
import io.agora.rtc.rawdata.base.IVideoFrameObserver
import io.agora.rtc.rawdata.base.VideoFrame
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit


/** AgoraRtcRawdataPlugin */
class AgoraRtcRawdataPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var audioObserver: IAudioFrameObserver? = null
    private var videoObserver: IVideoFrameObserver? = null

    @Volatile
    private var renderStop = false

    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "agora_rtc_rawdata")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
        renderStop = false
        Log.d(TAG, "onAttachedToEngine$renderStop")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "registerAudioFrameObserver" -> {
                if (audioObserver == null) {
                    audioObserver =
                        object : IAudioFrameObserver((call.arguments as Number).toLong()) {
                            override fun onRecordAudioFrame(audioFrame: AudioFrame): Boolean {
                                return true
                            }

                            override fun onPlaybackAudioFrame(audioFrame: AudioFrame): Boolean {
                                return true
                            }

                            override fun onMixedAudioFrame(audioFrame: AudioFrame): Boolean {
                                return true
                            }

                            override fun onPlaybackAudioFrameBeforeMixing(
                                uid: Int,
                                audioFrame: AudioFrame,
                            ): Boolean {
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
                    videoObserver =
                        object : IVideoFrameObserver((call.arguments as Number).toLong()) {
                            private var oldRotation = 0
                            private var skipFrame = SKIP_FRAME

                            override fun onCaptureVideoFrame(
                                sourceType: Int,
                                videoFrame: VideoFrame,
                            ): Boolean {
                                if (!FaceunityKit.isKitInit || renderStop) return false
                                Log.d(TAG, "handleMessage: onCaptureVideoFrame: sourceType:$sourceType, rotation:${videoFrame.rotation}, width: ${videoFrame.width}, height: ${videoFrame.height}")
                                val countDownLatch = CountDownLatch(1)
                                var outputData: FURenderOutputData? = null
                                val startTime = System.currentTimeMillis()
                                OffLineRenderHandler.getInstance().queueEvent {
                                    if (!FaceunityKit.isKitInit) {
                                        countDownLatch.countDown()
                                        Log.d(TAG, "RenderHandler: queueEvent fail: FaceunityKit.isKitInit == ${FaceunityKit.isKitInit}")
                                        return@queueEvent
                                    }
                                    val i420 =
                                        videoFrame.getyBuffer() + videoFrame.getuBuffer() + videoFrame.getvBuffer()
                                    outputData = renderData(
                                        i420,
                                        videoFrame.getyStride(),
                                        videoFrame.height,
                                        videoFrame.rotation
                                    )
                                    countDownLatch.countDown()
                                }
                                countDownLatch.await(2000, TimeUnit.MILLISECONDS)
                                Log.d(
                                    TAG,
                                    "onCaptureVideoFrame: cost ${System.currentTimeMillis() - startTime} ms"
                                )
                                if (oldRotation != videoFrame.rotation) {
                                    oldRotation = videoFrame.rotation
                                    skipFrame = SKIP_FRAME
                                }
                                if (skipFrame-- < 0) {
                                    updateVideoFrameBuffer(videoFrame, outputData)
                                }
                                return true
                            }

                            override fun onRenderVideoFrame(
                                uid: Int,
                                videoFrame: VideoFrame,
                            ): Boolean {
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
        //直接关闭Activity的时候，不会走flutter生命周期，所以手动调用
        videoObserver?.let {
            it.unregisterVideoFrameObserver()
            videoObserver = null
        }
        audioObserver?.let {
            it.unregisterAudioFrameObserver()
            audioObserver = null
        }
        Log.d(TAG, "onDetachedFromEngine: $renderStop")
    }

    private fun renderData(
        buffer: ByteArray,
        width: Int,
        height: Int,
        rotation: Int,
    ): FURenderOutputData {
        if (FaceunityKit.highLeveDeice) {
            cheekFaceNum()
        }
        val inputData = FURenderInputData(width, height)
        val imageBuffer =
            FURenderInputData.FUImageBuffer(FUInputBufferEnum.FU_FORMAT_I420_BUFFER, buffer)
        inputData.imageBuffer = imageBuffer
        inputData.renderConfig.apply {
            isNeedBufferReturn = true
            deviceOrientation = FaceunityKit.deviceOrientation
            inputOrientation = rotation
            if (rotation == 270) {
                //前置
                cameraFacing = CameraFacingEnum.CAMERA_FRONT
                inputBufferMatrix = FUTransformMatrixEnum.CCROT90_FLIPHORIZONTAL
                inputTextureMatrix = FUTransformMatrixEnum.CCROT90_FLIPHORIZONTAL
                outputMatrix = FUTransformMatrixEnum.CCROT270
            } else {
                cameraFacing = CameraFacingEnum.CAMERA_BACK
                inputBufferMatrix = FUTransformMatrixEnum.CCROT0
                inputTextureMatrix = FUTransformMatrixEnum.CCROT0
                outputMatrix = FUTransformMatrixEnum.CCROT0_FLIPVERTICAL
            }
        }
        return FURenderKit.getInstance().renderWithInput(inputData)
    }

    private fun updateVideoFrameBuffer(videoFrame: VideoFrame, outputData: FURenderOutputData?) {
        if (outputData == null) {
            Log.e(TAG, "updateVideoFrameBuffer: render cost more than 2000ms a frame, what a amazing device!")
        }
        outputData?.image?.buffer?.let { buffer ->
            videoFrame.apply {
                System.arraycopy(buffer, 0, getyBuffer(), 0, getyBuffer().size)
                System.arraycopy(buffer, getyBuffer().size, getuBuffer(), 0, getuBuffer().size)
                System.arraycopy(buffer, getyBuffer().size + getuBuffer().size, getvBuffer(), 0, getvBuffer().size)
            }
        }
    }

    private fun cheekFaceNum() {
        //根据有无人脸 + 设备性能 判断开启的磨皮类型
        val faceProcessorGetConfidenceScore =
            FUAIKit.getInstance().getFaceProcessorGetConfidenceScore(0)
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
        private const val SKIP_FRAME = 3
    }
}
