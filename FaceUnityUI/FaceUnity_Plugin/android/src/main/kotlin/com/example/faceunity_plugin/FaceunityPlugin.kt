package com.example.faceunity_plugin

import android.util.Log
import androidx.annotation.NonNull
import com.example.faceunity_plugin.impl.FUBeautyPlugin
import com.example.faceunity_plugin.impl.FUMakeupPlugin
import com.example.faceunity_plugin.impl.FUStickerPlugin
import com.faceunity.core.callback.OperateCallback
import com.faceunity.core.faceunity.FURenderManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FaceunityPlugin */
class FaceunityPlugin : FlutterPlugin, MethodCallHandler {
  companion object {
    private const val TAG = "FaceunityPlugin"
    private const val viewModelManagerPlugin = "viewModelManagerPlugin"
  }

  private val fuBeautyPlugin: FUBeautyPlugin by lazy { FUBeautyPlugin() }
  private val fuStickerPlugin: FUStickerPlugin by lazy { FUStickerPlugin() }
  private val fuMakeupPlugin: FUMakeupPlugin by lazy { FUMakeupPlugin() }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    FURenderManager.registerFURender(flutterPluginBinding.applicationContext, authpack.A(), object : OperateCallback {
      override fun onFail(errCode: Int, errMsg: String) {
        Log.e("registerFURender", "errCode: $errCode   errMsg: $errMsg")
      }

      override fun onSuccess(code: Int, msg: String) {
        Log.d("registerFURender", "success:$msg")
      }
    })
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "faceunity_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      FUBeautyPlugin.method -> {
        fuBeautyPlugin.methodCall(this, call, result)
      }
      FUStickerPlugin.method -> {
        fuStickerPlugin.methodCall(this, call, result)
      }
      FUMakeupPlugin.method -> {
        fuMakeupPlugin.methodCall(this, call, result)
      }
      viewModelManagerPlugin -> {
        methodCall(call)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun methodCall(call: MethodCall) {
    val arguments = call.arguments as? Map<*, *>?
    Log.i("faceunity", "methodCall: ${arguments?.get("method") as String?}")
    when (arguments?.get("method") as String?) {
      "compatibleClickBeautyItem" -> {
        val value = arguments?.get("value") as Int
        fuBeautyPlugin.faceBeautyDataFactory?.beautyIndex = value
      }
      "switchOn" -> {
        val bizType = arguments?.get("bizType") as Int
        val isOn = arguments["value"] as Boolean
        fuBeautyPlugin.switchOn(isOn, bizType)
      }
    }
  }
}
