package com.example.faceunity_plugin.impl

import android.util.Log
import com.example.faceunity_plugin.FaceunityPlugin
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
class FUStickerPlugin {
    companion object {
        const val method = "sticker"
    }

    var propDataFactory: PropDataFactory? = null
        private set

    fun methodCall(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result){
        val arguments = call.arguments as? Map<*, *>?
        val method = arguments?.get("method") as String?
        Log.i("sticker", "methodCall: $arguments")
        when(method) {
            "config" -> config()
            "dispose" -> dispose()
            "selectedItem" -> {
                val index = arguments?.get("index") as Int
                selectedItem(index)
            }
        }
    }

    private fun config() {
        propDataFactory = PropDataFactory(0)
        propDataFactory?.config()
    }

    private fun dispose() {
        propDataFactory?.dispose()
    }

    private fun selectedItem(index: Int) {
        propDataFactory?.onItemSelected(index)
    }
}