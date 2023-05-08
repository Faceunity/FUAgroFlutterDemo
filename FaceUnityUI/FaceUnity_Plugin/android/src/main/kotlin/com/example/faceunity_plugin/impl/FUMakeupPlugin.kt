package com.example.faceunity_plugin.impl

import android.util.Log
import com.example.faceunity_plugin.FaceunityPlugin
import com.example.faceunity_plugin.data.MakeupDataFactory
import com.example.faceunity_plugin.data.PropDataFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 *
 * @author benyq
 * @date 2021/12/13
 * @email 1520063035@qq.com
 *
 */
class FUMakeupPlugin {
    companion object {
        const val method = "makeup"
    }

    private var makeupDataFactory: MakeupDataFactory? = null

    fun methodCall(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result){
        val arguments = call.arguments as? Map<*, *>?
        val method = arguments?.get("method") as String?
        Log.i("makeup", "methodCall: $arguments")
        when(method) {
            "config" -> config()
            "dispose" -> dispose()
            "sliderValueChange" -> {
                val index = arguments?.get("index") as Int
                val value = arguments["value"] as Double
                sliderValueChange(index, value)
            }
            "selectedItem" -> {
                val index = arguments?.get("index") as Int
                selectedItem(index)
            }
        }
    }

    private fun sliderValueChange(index: Int, value: Double) {
        makeupDataFactory?.sliderValueChange(index, value)
    }

    private fun config() {
        makeupDataFactory = MakeupDataFactory(0)
        makeupDataFactory?.config()
    }

    private fun dispose() {
        makeupDataFactory?.dispose()
    }

    private fun selectedItem(index: Int) {
        makeupDataFactory?.selectedItem(index)
    }
}
