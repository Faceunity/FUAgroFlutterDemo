package com.faceunity.faceunity_plugin

import android.content.Context
import android.util.Log
import com.faceunity.core.callback.OperateCallback
import com.faceunity.core.entity.FUBundleData
import com.faceunity.core.enumeration.FUAITypeEnum
import com.faceunity.core.enumeration.FUFaceBeautyMultiModePropertyEnum
import com.faceunity.core.enumeration.FUFaceBeautyPropertyModeEnum
import com.faceunity.core.faceunity.AICommonData
import com.faceunity.core.faceunity.FUAIKit
import com.faceunity.core.faceunity.FURenderConfig
import com.faceunity.core.faceunity.FURenderKit
import com.faceunity.core.faceunity.FURenderManager
import com.faceunity.core.model.bodyBeauty.BodyBeauty
import com.faceunity.core.model.facebeauty.FaceBeauty
import com.faceunity.core.utils.FULogger
import com.faceunity.faceunity_plugin.utils.FuDeviceUtils

/**
 *
 * @author benyq
 * @date 11/10/2023
 *
 */
object FaceunityKit {

    private const val TAG = "FaceunityKit"
    private val aiKit = FUAIKit.getInstance()
    private val renderKit = FURenderKit.getInstance()

    var devicePerformanceLevel = FuDeviceUtils.DEVICE_LEVEL_TWO
    var deviceOrientation = 0
    val highLeveDeice: Boolean get() = devicePerformanceLevel > FuDeviceUtils.DEVICE_LEVEL_ONE

    var isEffectsOn = true
    @Volatile
    var isKitInit = false
        private set

    fun setupKit(context: Context, successAction: () -> Unit) {
        FURenderManager.setKitDebug(FULogger.LogLevel.DEBUG)
        devicePerformanceLevel = FuDeviceUtils.judgeDeviceLevel(false)
        FURenderManager.registerFURender(context, authpack.A(), object :
            OperateCallback {
            override fun onFail(errCode: Int, errMsg: String) {
                Log.e(TAG, "onFail: errCode: $errCode, errMsg: $errMsg")
            }

            override fun onSuccess(code: Int, msg: String) {
                if (code == FURenderConfig.OPERATE_SUCCESS_AUTH) {
                    successAction()
                    isKitInit = true

                    setFaceAlgorithmConfig()
                    aiKit.loadAIProcessor(FaceunityConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR)
                    aiKit.loadAIProcessor(FaceunityConfig.BUNDLE_AI_HUMAN, FUAITypeEnum.FUAITYPE_HUMAN_PROCESSOR)
                    //高端机开启小脸检测
                    FUAIKit.getInstance().faceProcessorSetFaceLandmarkQuality(devicePerformanceLevel)
                    if (devicePerformanceLevel > FuDeviceUtils.DEVICE_LEVEL_TWO) {
                        FUAIKit.getInstance().fuFaceProcessorSetDetectSmallFace(true)
                    }
                    loadFaceBeauty()
                    loadBodyBeauty()
                }
            }
        })
    }

    fun releaseKit() {
        isKitInit = false
        renderKit.release()
    }

    private fun setFaceAlgorithmConfig() {
        /**
         * 设置算法人脸模块的加载策略，是否关闭一些模块的加载。可提高加载速度。
         * FUAIFACE_ENABLE_ALL = 0,
         *   FUAIFACE_DISABLE_FACE_OCCU = 1 << 0, //关闭全脸遮挡分割
         *   FUAIFACE_DISABLE_SKIN_SEG = 1 << 1,  //关闭美白皮肤分割
         *   FUAIFACE_DISABLE_DEL_SPOT = 1 << 2,  //关闭去斑痘
         *   FUAIFACE_DISABLE_ARMESHV2 = 1 << 3,  //关闭ARMESHV2
         *   FUAIFACE_DISABLE_RACE = 1 << 4,  //关闭人种分类
         *   AFUAIFACE_DISABLE_LANDMARK_HP_OCCU = 1 << 5,  //关闭人脸点位
         */
        when (devicePerformanceLevel) {
          FuDeviceUtils.DEVICE_LEVEL_MINUS_ONE, FuDeviceUtils.DEVICE_LEVEL_ONE -> aiKit.fuSetFaceAlgorithmConfig(
            AICommonData.FUAIFACE_DISABLE_FACE_OCCU or AICommonData.FUAIFACE_DISABLE_SKIN_SEG
              or AICommonData.FUAIFACE_DISABLE_DEL_SPOT or AICommonData.FUAIFACE_DISABLE_ARMESHV2
              or AICommonData.FUAIFACE_DISABLE_RACE or AICommonData.FUAIFACE_DISABLE_LANDMARK_HP_OCCU
          )

          FuDeviceUtils.DEVICE_LEVEL_TWO -> aiKit.fuSetFaceAlgorithmConfig(
            AICommonData.FUAIFACE_DISABLE_SKIN_SEG or AICommonData.FUAIFACE_DISABLE_DEL_SPOT
              or AICommonData.FUAIFACE_DISABLE_ARMESHV2 or AICommonData.FUAIFACE_DISABLE_RACE
          )

          FuDeviceUtils.DEVICE_LEVEL_THREE -> aiKit.fuSetFaceAlgorithmConfig(
            AICommonData.FUAIFACE_DISABLE_SKIN_SEG
          )

          FuDeviceUtils.DEVICE_LEVEL_FOUR -> aiKit.fuSetFaceAlgorithmConfig(AICommonData.FUAIFACE_ENABLE_ALL)
        }
    }

    fun loadFaceBeauty() {
        val faceBeauty = FaceBeauty(FUBundleData(FaceunityConfig.BUNDLE_FACE_BEAUTIFICATION))
        if (devicePerformanceLevel > FuDeviceUtils.DEVICE_LEVEL_ONE) {
         faceBeauty.addPropertyMode(
                FUFaceBeautyMultiModePropertyEnum.REMOVE_POUCH_INTENSITY,
                FUFaceBeautyPropertyModeEnum.MODE2
            )
            faceBeauty.addPropertyMode(
                FUFaceBeautyMultiModePropertyEnum.REMOVE_NASOLABIAL_FOLDS_INTENSITY,
                FUFaceBeautyPropertyModeEnum.MODE2
            )
            faceBeauty.addPropertyMode(
                FUFaceBeautyMultiModePropertyEnum.EYE_ENLARGING_INTENSITY,
                FUFaceBeautyPropertyModeEnum.MODE3
            )
            faceBeauty.addPropertyMode(
                FUFaceBeautyMultiModePropertyEnum.MOUTH_INTENSITY,
                FUFaceBeautyPropertyModeEnum.MODE3
            )
        }
        faceBeauty.enable = isEffectsOn
        renderKit.faceBeauty = faceBeauty
    }

    fun loadBodyBeauty() {
        renderKit.bodyBeauty = BodyBeauty(FUBundleData(FaceunityConfig.BUNDLE_BODY_BEAUTY)).apply {
            enable = isEffectsOn
        }
    }
}
