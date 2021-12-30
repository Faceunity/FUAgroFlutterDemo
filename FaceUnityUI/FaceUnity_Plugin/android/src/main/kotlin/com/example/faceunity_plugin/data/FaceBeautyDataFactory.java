package com.example.faceunity_plugin.data;

import android.util.Log;

import com.faceunity.core.entity.FUBundleData;
import com.faceunity.core.enumeration.FUAITypeEnum;
import com.faceunity.core.faceunity.FUAIKit;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.core.model.facebeauty.FaceBeauty;
import com.faceunity.core.model.facebeauty.FaceBeautyBlurTypeEnum;
import com.faceunity.core.model.facebeauty.FaceBeautyFilterEnum;

/**
 * author Qinyu on 2021-10-11
 * description 直接复制IOS的配置表 @see FUBaseViewControllerManager.m
 * 写法不优雅是因为 FaceBeauty 没有开放通用接口也不能继承, 本着不应该修改 module代码的原则暂时这样
 */
public class FaceBeautyDataFactory {
    public static final String[] filters = {"origin", "ziran1", "zhiganhui1", "bailiang1", "fennen1", "lengsediao1"};

    private FURenderKit mFURenderKit = FURenderKit.getInstance();
    /*当前生效美颜数据模型*/
    private FaceBeauty faceBeauty = getDefaultFaceBeauty();
    /*对应美颜栏目序号 0:美服 1:美型 2:滤镜*/
    private int beautyIndex = -1;

    public void config() {
        FUAIKit.getInstance().loadAIProcessor(BundlePathConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR);
        mFURenderKit.setFaceBeauty(faceBeauty);
        FUAIKit.getInstance().setMaxFaces(4);
    }

    public void dispose() {
        FUAIKit.getInstance().releaseAllAIProcessor();
        mFURenderKit.setFaceBeauty(null);
    }

    public void setSkinBeauty(int index, double value) {
        switch (index) {
            case 0:
                faceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                faceBeauty.setBlurIntensity(value);
                break;
            case 1:
                faceBeauty.setColorIntensity(value);
                break;
            case 2:
                faceBeauty.setRedIntensity(value);
                break;
            case 3:
                faceBeauty.setSharpenIntensity(value);
                break;
            case 4:
                faceBeauty.setEyeBrightIntensity(value);
                break;
            case 5:
                faceBeauty.setToothIntensity(value);
                break;
            case 6:
                faceBeauty.setRemovePouchIntensity(value);
                break;
            case 7:
                faceBeauty.setRemoveLawPatternIntensity(value);
                break;
            default:
        }
    }

    public void setShapeBeauty(int index, double value) {
        switch (index) {
            case 0:
                faceBeauty.setCheekThinningIntensity(value);
                break;
            case 1:
                faceBeauty.setCheekVIntensity(value);
                break;
            case 2:
                faceBeauty.setCheekNarrowIntensityV2(value);
                break;
            case 3:
                faceBeauty.setCheekSmallIntensityV2(value);
                break;
            case 4:
                faceBeauty.setCheekBonesIntensity(value);
                break;
            case 5:
                faceBeauty.setLowerJawIntensity(value);
                break;
            case 6:
                faceBeauty.setEyeEnlargingIntensityV2(value);
                break;
            case 7:
                faceBeauty.setEyeCircleIntensity(value);
                break;
            case 8:
                faceBeauty.setChinIntensity(value);
                break;
            case 9:
                faceBeauty.setForHeadIntensityV2(value);
                break;
            case 10:
                faceBeauty.setNoseIntensityV2(value);
                break;
            case 11:
                faceBeauty.setMouthIntensityV2(value);
                break;
            case 12:
                faceBeauty.setCanthusIntensity(value);
                break;
            case 13:
                faceBeauty.setEyeSpaceIntensity(value);
                break;
            case 14:
                faceBeauty.setEyeRotateIntensity(value);
                break;
            case 15:
                faceBeauty.setLongNoseIntensity(value);
                break;
            case 16:
                faceBeauty.setPhiltrumIntensity(value);
                break;
            case 17:
                faceBeauty.setSmileIntensity(value);
                break;
            default:
        }
    }

    public void resetSkinBeauty(FaceBeauty faceBeauty) {
        faceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
        faceBeauty.setBlurIntensity(4.2);
        faceBeauty.setColorIntensity(0.3);
        faceBeauty.setRedIntensity(0.3);
        faceBeauty.setSharpenIntensity(0.2);
        faceBeauty.setEyeBrightIntensity(0);
        faceBeauty.setToothIntensity(0);
        faceBeauty.setRemovePouchIntensity(0);
        faceBeauty.setRemoveLawPatternIntensity(0);
    }

    public void resetShapeBeauty(FaceBeauty faceBeauty) {
        faceBeauty.setCheekThinningIntensity(0);
        faceBeauty.setCheekVIntensity(0.5);
        faceBeauty.setCheekNarrowIntensityV2(0);
        faceBeauty.setCheekSmallIntensityV2(0);
        faceBeauty.setCheekBonesIntensity(0);
        faceBeauty.setLowerJawIntensity(0);
        faceBeauty.setEyeEnlargingIntensityV2(0.4);
        faceBeauty.setEyeCircleIntensity(0);
        faceBeauty.setChinIntensity(0.3);
        faceBeauty.setForHeadIntensityV2(0.3);
        faceBeauty.setNoseIntensityV2(0.5);
        faceBeauty.setMouthIntensityV2(0.4);
        faceBeauty.setCanthusIntensity(0);
        faceBeauty.setEyeSpaceIntensity(0.5);
        faceBeauty.setEyeRotateIntensity(0.5);
        faceBeauty.setLongNoseIntensity(0.5);
        faceBeauty.setPhiltrumIntensity(0.5);
        faceBeauty.setSmileIntensity(0);
    }

    public void resetFilter(FaceBeauty faceBeauty) {
        faceBeauty.setFilterName(FaceBeautyFilterEnum.ZIRAN_2);
        faceBeauty.setFilterIntensity(0.4);
    }

    private static FaceBeauty getDefaultFaceBeauty() {
        FaceBeauty faceBeauty = new FaceBeauty(new FUBundleData(BundlePathConfig.BUNDLE_FACE_BEAUTIFICATION));
        /*美肤*/
        faceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
        faceBeauty.setBlurIntensity(4.2);
        faceBeauty.setColorIntensity(0.3);
        faceBeauty.setRedIntensity(0.3);
        faceBeauty.setSharpenIntensity(0.2);
        faceBeauty.setEyeBrightIntensity(0);
        faceBeauty.setToothIntensity(0);
        faceBeauty.setRemovePouchIntensity(0);
        faceBeauty.setRemoveLawPatternIntensity(0);
        /*美型*/
        faceBeauty.setCheekThinningIntensity(0);
        faceBeauty.setCheekVIntensity(0.5);
        faceBeauty.setCheekNarrowIntensityV2(0);
        faceBeauty.setCheekSmallIntensityV2(0);
        faceBeauty.setCheekBonesIntensity(0);
        faceBeauty.setLowerJawIntensity(0);
        faceBeauty.setEyeEnlargingIntensityV2(0.4);
        faceBeauty.setEyeCircleIntensity(0);
        faceBeauty.setChinIntensity(0.3);
        faceBeauty.setForHeadIntensityV2(0.3);
        faceBeauty.setNoseIntensityV2(0.5);
        faceBeauty.setMouthIntensityV2(0.4);
        faceBeauty.setCanthusIntensity(0);
        faceBeauty.setEyeSpaceIntensity(0.5);
        faceBeauty.setEyeRotateIntensity(0.5);
        faceBeauty.setLongNoseIntensity(0.5);
        faceBeauty.setPhiltrumIntensity(0.5);
        faceBeauty.setSmileIntensity(0);
        /*滤镜*/
        faceBeauty.setFilterName(FaceBeautyFilterEnum.ZIRAN_2);
        faceBeauty.setFilterIntensity(0.4);

        return faceBeauty;
    }

    public FaceBeauty getFaceBeauty() {
        return faceBeauty;
    }

    public int getBeautyIndex() {
        return beautyIndex;
    }

    public void setBeautyIndex(int beautyIndex) {
        Log.i("beautyDataFactory", "methodCall: beautyIndex " + beautyIndex);
        this.beautyIndex = beautyIndex;
    }
}

