package com.faceunity.faceunity_plugin.modules

import com.faceunity.faceunity_plugin.FaceunityKit
import io.flutter.plugin.common.MethodChannel

/**
 *
 * @author benyq
 * @date 11/10/2023
 *
 */
class FUBodyBeautyPlugin : BaseModulePlugin() {

    private val methods =
        mapOf(
            "setBodyIntensity" to ::setBodyIntensity,
            "checkIsBodyLoaded" to ::checkIsBodyLoaded,
            "loadBody" to ::loadBody,
            "unloadBody" to ::unloadBody
        )

    override fun methods(): Map<String, (Map<String, Any>, MethodChannel.Result) -> Any> = methods

    fun enableBody(enable: Boolean) {
        renderKit.bodyBeauty?.enable = enable
    }

    private fun setBodyIntensity(params: Map<String, Any>, result: MethodChannel.Result) {
        val intensity = params.getDouble("intensity") ?: return
        val type = params.getInt("type") ?: return
        when (BodyEnum.values().getOrNull(type)) {
            BodyEnum.FUBeautyBodySlim -> renderKit.bodyBeauty?.bodySlimIntensity = intensity
            BodyEnum.FUBeautyBodyLongLeg -> renderKit.bodyBeauty?.legStretchIntensity = intensity
            BodyEnum.FUBeautyBodyThinWaist -> renderKit.bodyBeauty?.waistSlimIntensity = intensity
            BodyEnum.FUBeautyBodyBeautyShoulder -> renderKit.bodyBeauty?.shoulderSlimIntensity =
                intensity

            BodyEnum.FUBeautyBodyBeautyButtock -> renderKit.bodyBeauty?.hipSlimIntensity = intensity
            BodyEnum.FUBeautyBodySmallHead -> renderKit.bodyBeauty?.headSlimIntensity = intensity
            BodyEnum.FUBeautyBodyThinLeg -> renderKit.bodyBeauty?.legSlimIntensity = intensity
            else -> {}
        }

    }

    private fun checkIsBodyLoaded(params: Map<String, Any>, result: MethodChannel.Result) {
        if (renderKit.bodyBeauty == null) {
            FaceunityKit.loadBodyBeauty()
        }
    }

    private fun loadBody(params: Map<String, Any>, result: MethodChannel.Result) {
        FaceunityKit.loadBodyBeauty()
    }

    private fun unloadBody(params: Map<String, Any>, result: MethodChannel.Result) {
        renderKit.bodyBeauty = null
    }

    override fun tag(): String = "BodyBeautyPlugin"

    enum class BodyEnum {
        FUBeautyBodySlim,                   // 瘦身
        FUBeautyBodyLongLeg,                // 长腿
        FUBeautyBodyThinWaist,              // 细腰
        FUBeautyBodyBeautyShoulder,         // 美肩
        FUBeautyBodyBeautyButtock,          // 美臀
        FUBeautyBodySmallHead,              // 小头
        FUBeautyBodyThinLeg,                // 瘦腿
    }

}