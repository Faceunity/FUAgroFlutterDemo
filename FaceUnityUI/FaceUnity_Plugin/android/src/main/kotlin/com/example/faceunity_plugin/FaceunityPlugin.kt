package com.example.faceunity_plugin

import android.util.Log
import androidx.annotation.NonNull
import com.example.faceunity_plugin.impl.FuBeautyImpl

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FaceunityPlugin */
class FaceunityPlugin: FlutterPlugin, MethodCallHandler {
  companion object {
    private const val TAG = "FaceunityPlugin"
  }
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "faceunity_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.arguments is Map<*, *>) {
      val method = (call.arguments as Map<*, *>)["method"] as String?
      Log.i(TAG, "onMethodCall: $method")
      for (key in FuBeautyImpl.values()) {
        if (method == key.name) {
          key.handle(this, call, result)
          return
        }
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
