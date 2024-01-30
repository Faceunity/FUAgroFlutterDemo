package com.faceunity.faceunity_plugin.modules

import com.faceunity.core.entity.FUBundleData
import com.faceunity.core.model.makeup.Makeup
import com.faceunity.core.model.makeup.SimpleMakeup
import com.faceunity.faceunity_plugin.FaceunityConfig
import com.faceunity.faceunity_plugin.FaceunityKit
import com.faceunity.faceunity_plugin.FuDeviceUtils
import io.flutter.plugin.common.MethodChannel

/**
 *
 * @author benyq
 * @date 11/13/2023
 *
 */
class FUMakeupPlugin : BaseModulePlugin() {

    private val methods = mapOf(
        "selectMakeup" to ::selectMakeup,
        "setMakeupIntensity" to ::setMakeupIntensity,
        "removeMakeup" to ::removeMakeup
    )

    fun enableMakeup(enable: Boolean) {
        renderKit.makeup?.enable = enable
    }


    private fun selectMakeup(params: Map<String, Any>, result: MethodChannel.Result) {
        val bundleName = params.getString("bundleName") ?: return
        val isCombined = params.getBoolean("isCombined") ?: return
        val intensity = params.getDouble("intensity") ?: return
        renderKit.makeup = null
        renderKit.addMakeupLoadListener {}//不加这个切换美妆会闪烁
        val makeup = if (isCombined) {
            // 新组合妆，每次加载必须重新初始化
            Makeup(FUBundleData("makeup/${bundleName}.bundle")).apply {
                filterIntensity = intensity
            }
        }else {
            SimpleMakeup(FUBundleData(FaceunityConfig.BUNDLE_FACE_MAKEUP)).apply {
                setCombinedConfig(FUBundleData("makeup/${bundleName}.bundle"))
            }
        }
        makeup.makeupIntensity = intensity
        makeup.machineLevel = FaceunityKit.devicePerformanceLevel == FuDeviceUtils.DEVICE_LEVEL_HIGH
        makeup.enable = FaceunityKit.isEffectsOn
        renderKit.makeup = makeup
    }

    private fun setMakeupIntensity(params: Map<String, Any>, result: MethodChannel.Result) {
        val intensity = params.getDouble("intensity") ?: return
        renderKit.makeup?.makeupIntensity = intensity
        if (renderKit.makeup?.controlBundle?.path != FaceunityConfig.BUNDLE_FACE_MAKEUP) {
            renderKit.makeup?.filterIntensity = intensity
        }
    }

    private fun removeMakeup(params: Map<String, Any>, result: MethodChannel.Result) {
        renderKit.makeup = null
    }

    override fun methods(): Map<String, (Map<String, Any>, MethodChannel.Result) -> Unit> = methods
    override fun tag(): String = "FUMakeupPlugin"
}