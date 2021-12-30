package com.example.faceunity_plugin.impl

import android.util.Log
import com.example.faceunity_plugin.FaceunityPlugin
import com.example.faceunity_plugin.data.FaceBeautyDataFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 *
 * @author benyq
 * @date 2021/12/13
 * @email 1520063035@qq.com
 *
 */
class FUBeautyPlugin {

    companion object {
        const val method = "beauty"
    }
    var faceBeautyDataFactory: FaceBeautyDataFactory? = null
        private set

    fun methodCall(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? Map<*, *>?
        val method = arguments?.get("method") as String?
        Log.i("beauty", "methodCall: $arguments")
        method?.let {
            when (it) {
                "selectedItem" -> {
                    val subBizType = arguments?.get("subBizType") as Int
                    selectedItem(subBizType)
                }
                "sliderValueChange" -> {
                    val subBizType = arguments?.get("subBizType") as Int
                    val value = arguments["value"] as Double
                    val strValue = arguments["strValue"] as String
                    sliderValueChange(subBizType, value, strValue)
                }
                "filterSliderValueChange" -> {
                    val subBizType = arguments?.get("subBizType") as Int
                    val value = arguments["value"] as Double
                    val strValue = arguments["strValue"] as String
                    filterSliderValueChange(subBizType, value, strValue)
                }
                "resetDefault" -> {
                    val bizType = arguments?.get("bizType") as Int
                    resetDefault(bizType)
                }
                "config" -> config()
                "dispose" -> dispose()
            }
        }
    }

    fun switchOn(isOn: Boolean, bizType: Int) {
        faceBeautyDataFactory?.faceBeauty?.enable = isOn
    }

    private fun selectedItem(subBizType: Int) {
        faceBeautyDataFactory?.run {
            if (beautyIndex == 2) {
                faceBeauty.filterName = FaceBeautyDataFactory.filters[subBizType]
            }
        }
    }

    private fun sliderValueChange(subBizType: Int, value: Double, strValue: String) {
        faceBeautyDataFactory?.run {
            if (beautyIndex == 0) {
                setSkinBeauty(subBizType, value)
            }else if (beautyIndex == 1) {
                setShapeBeauty(subBizType, value)
            }
        }
    }

    private fun filterSliderValueChange(subBizType: Int, value: Double, strValue: String) {
        faceBeautyDataFactory?.run {
            faceBeauty.filterName = strValue
            faceBeauty.filterIntensity = value
        }
    }

    private fun resetDefault(bizType: Int) {
        faceBeautyDataFactory?.let {
            it.faceBeauty?.run {
                when (bizType) {
                    0 -> faceBeautyDataFactory?.resetSkinBeauty(this)
                    1 -> faceBeautyDataFactory?.resetShapeBeauty(this)
                    2 -> faceBeautyDataFactory?.resetFilter(this)
                    else -> {}
                }
            }
        }
    }

    private fun config() {
        faceBeautyDataFactory = FaceBeautyDataFactory()
        faceBeautyDataFactory?.config()
    }

    private fun dispose() {
        faceBeautyDataFactory?.dispose()
    }

}