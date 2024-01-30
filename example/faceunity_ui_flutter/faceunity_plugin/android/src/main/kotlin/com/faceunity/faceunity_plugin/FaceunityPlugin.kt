package com.faceunity.faceunity_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.faceunity.core.faceunity.OffLineRenderHandler
import com.faceunity.faceunity_plugin.modules.FUBodyBeautyPlugin
import com.faceunity.faceunity_plugin.modules.FUMakeupPlugin
import com.faceunity.faceunity_plugin.modules.FUStickerPlugin
import com.faceunity.faceunity_plugin.modules.FUFaceBeautyPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FaceunityPlugin */
class FaceunityPlugin : FlutterPlugin, MethodCallHandler{
    companion object {
        private const val TAG = "FaceunityPlugin"
    }

    private lateinit var channel: MethodChannel
    private val faceBeautyPlugin by lazy { FUFaceBeautyPlugin() }
    private val stickerPlugin by lazy { FUStickerPlugin() }
    private val makeupPlugin by lazy { FUMakeupPlugin() }
    private val bodyPlugin by lazy { FUBodyBeautyPlugin() }
    private val sensorHandler by lazy { SensorHandler() }
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "faceunity_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.i(TAG, "onMethodCall: ${call.method}, arguments: ${call.arguments}")
        when {
            faceBeautyPlugin.containsMethod(call.method) -> faceBeautyPlugin.handleMethod(call, result)
            makeupPlugin.containsMethod(call.method) -> makeupPlugin.handleMethod(call, result)
            stickerPlugin.containsMethod(call.method) -> stickerPlugin.handleMethod(call, result)
            bodyPlugin.containsMethod(call.method) -> bodyPlugin.handleMethod(call, result)
            else -> methodCall(call, result)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        //单页面不会走flutter widget dispose 逻辑，所以在这做一次兜底
        destroyRenderKit()
    }

    private fun methodCall(call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "isHighPerformanceDevice" -> {
                result.success(FaceunityKit.devicePerformanceLevel == FuDeviceUtils.DEVICE_LEVEL_HIGH)
            }

            "isNPUSupported" -> {
                result.success(false)
            }

            "turnOffEffects" -> {
                turnOnOffEffects(false)
            }

            "turnOnEffects" -> {
                turnOnOffEffects(true)
            }
            "setupRenderKit" -> setupRenderKit()
            "destoryRenderKit" -> destroyRenderKit()
        }
    }

    private fun turnOnOffEffects(enable: Boolean) {
        FaceunityKit.isEffectsOn = enable
        faceBeautyPlugin.enableBeauty(enable)
        makeupPlugin.enableMakeup(enable)
        bodyPlugin.enableBody(enable)
        stickerPlugin.enableSticker(enable)
    }

    private fun setupRenderKit() {
        FaceunityKit.setupKit(context) {
            OffLineRenderHandler.getInstance().onResume()
        }
        sensorHandler.register(context) {
            FaceunityKit.deviceOrientation = it
        }
    }

    private fun destroyRenderKit() {
        sensorHandler.unregister()
        OffLineRenderHandler.getInstance().queueEvent {
            FaceunityKit.releaseKit()
        }
        OffLineRenderHandler.getInstance().onPause()
    }
}
