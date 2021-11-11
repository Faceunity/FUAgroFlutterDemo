package com.example.faceunity_plugin.impl

import com.example.faceunity_plugin.FaceunityPlugin
import com.example.faceunity_plugin.entity.DemoConfig
import com.example.faceunity_plugin.entity.FaceBeautyDataFactory
import com.faceunity.core.enumeration.FUAITypeEnum
import com.faceunity.core.faceunity.FUAIKit
import com.faceunity.core.faceunity.FURenderKit
import com.faceunity.core.model.facebeauty.FaceBeautyFilterEnum
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @description
 * @author Qinyu on 2021-11-05
 */
enum class FuBeautyImpl {
    compatibleClickBeautyItem {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            try {
                val arguments = call.arguments as Map<*, *>
                FaceBeautyDataFactory.setBeautyIndex(arguments["value"] as Int)
            } catch (e: java.lang.ClassCastException) {
                e.printStackTrace()
            }
            result.success(null)
        }
    },
    selectedItem {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            try {
                val arguments = call.arguments as Map<*, *>
                val index = arguments["subBizType"] as Int
                when (FaceBeautyDataFactory.getBeautyIndex()) {
                    2 -> {
                        if (index == 0) {
                            FaceBeautyDataFactory.getFaceBeauty().filterName = FaceBeautyFilterEnum.ORIGIN
                        }
                    }
                }
            } catch (e: java.lang.ClassCastException) {
                e.printStackTrace()
            }
            result.success(null)
        }
    },
    sliderValueChange {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            try {
                val arguments = call.arguments as Map<*, *>
                val index = arguments["subBizType"] as Int
                when (FaceBeautyDataFactory.getBeautyIndex()) {
                    0 -> {
                        val value = arguments["value"] as Double
                        FaceBeautyDataFactory.setSkinBeauty(index, value)
                    }
                    1 -> {
                        val value = arguments["value"] as Double
                        FaceBeautyDataFactory.setShapeBeauty(index, value)
                    }
                }
            } catch (e: java.lang.ClassCastException) {
                e.printStackTrace()
            }
            result.success(null)
        }
    },
    filterSliderValueChange {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            val faceBeauty = FaceBeautyDataFactory.getFaceBeauty()
            try {
                val arguments = call.arguments as Map<*, *>
                val value = arguments["value"] as Double
                val name = arguments["strValue"] as String?
                faceBeauty.filterName = name!!
                faceBeauty.filterIntensity = value
            } catch (e: java.lang.ClassCastException) {
                e.printStackTrace()
            }
            result.success(null)
        }
    },
    config {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            FUAIKit.getInstance().loadAIProcessor(DemoConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR)
            FURenderKit.getInstance().faceBeauty = FaceBeautyDataFactory.getFaceBeauty()
            result.success(null)
        }
    },
    dispose {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            FUAIKit.getInstance().releaseAllAIProcessor()
            FURenderKit.getInstance().faceBeauty = null
            result.success(null)
        }
    },
    resetDefault {
        override fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result) {
            val faceBeauty = FaceBeautyDataFactory.getFaceBeauty()
            try {
                val arguments = call.arguments as Map<*, *>
                val type = arguments["bizType"] as Int
                when (type) {
                    0 -> FaceBeautyDataFactory.resetSkinBeauty(faceBeauty)
                    1 -> FaceBeautyDataFactory.resetShapeBeauty(faceBeauty)
                    2 -> FaceBeautyDataFactory.resetFilter(faceBeauty)
                }
                result.success(null)
            } catch (e: ClassCastException) {
            }
        }
    };

    abstract fun handle(plugin: FaceunityPlugin, call: MethodCall, result: MethodChannel.Result)
}