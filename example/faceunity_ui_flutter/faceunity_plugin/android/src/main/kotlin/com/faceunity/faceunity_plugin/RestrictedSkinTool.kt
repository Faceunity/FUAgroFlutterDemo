package com.faceunity.faceunity_plugin

import com.faceunity.core.controller.facebeauty.FaceBeautyParam
import com.faceunity.faceunity_plugin.modules.FUFaceBeautyPlugin
import com.faceunity.faceunity_plugin.utils.FuDeviceUtils

/**
 *
 * @author benyq
 * @date 11/21/2024
 *
 */
object RestrictedSkinTool {

    private lateinit var _restrictedSkinParams: List<Int>
    val restrictedSkinParams: List<Int>
        get() {
            if (!::_restrictedSkinParams.isInitialized) {
                initRestrictedSkinParams()
            }
            return _restrictedSkinParams
        }

    private fun initRestrictedSkinParams() {
        val params = mutableSetOf<Int>()
        val restrictedMap = FuDeviceUtils.getBlackListMap()
        restrictedMap.forEach {
            when(it.key) {
                FaceBeautyParam.DELSPOT-> {
                    if (it.value.contains(FuDeviceUtils.getDeviceName())) {
                        params.add(FUFaceBeautyPlugin.SkinEnum.FUBeautySkinAntiAcneSpot.ordinal)
                        return@forEach
                    }
                }
            }
        }
        _restrictedSkinParams = params.toList()
    }
}