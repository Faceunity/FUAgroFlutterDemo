package com.example.faceunity_plugin.entity;

import com.faceunity.core.entity.FUBundleData;
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
    
    /*美颜缓存数据模型 用于风格切换*/
    private static final FaceBeauty defaultFaceBeauty = getDefaultFaceBeauty();
    /*当前生效美颜数据模型*/
    private static FaceBeauty faceBeauty = defaultFaceBeauty;

    private static int beautyIndex = -1; //对应美颜栏目序号 0:美服 1:美型 2:滤镜

    public static void setSkinBeauty(int index, double value) {
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

    public static void setShapeBeauty(int index, double value) {
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

    public static void setStyle(int index) {
        switch (index) {
            case 0:
                faceBeauty = defaultFaceBeauty;
                FURenderKit.getInstance().setFaceBeauty(faceBeauty);
                return;
            case 1: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setColorIntensity(0.5);
                model.setBlurIntensity(3.6);
                model.setEyeBrightIntensity(0.35);
                model.setToothIntensity(0.25);
                model.setCheekThinningIntensity(0.45);
                model.setCheekVIntensity(0.08);
                model.setCheekSmallIntensityV2(0.05);
                model.setEyeEnlargingIntensityV2(0.3);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 2: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setFilterName(FaceBeautyFilterEnum.ZIRAN_3);
                model.setFilterIntensity(0.3);
                model.setColorIntensity(0.4);
                model.setRedIntensity(0.2);
                model.setBlurIntensity(3.6);
                model.setEyeBrightIntensity(0.5);
                model.setToothIntensity(0.4);
                model.setCheekThinningIntensity(0.3);
                model.setNoseIntensityV2(0.5);
                model.setEyeEnlargingIntensityV2(0.25);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 3: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setColorIntensity(0.4);
                model.setRedIntensity(0.3);
                model.setBlurIntensity(2.4);
                model.setCheekThinningIntensity(0.3);
                model.setCheekSmallIntensityV2(0.15);
                model.setEyeEnlargingIntensityV2(0.65);
                model.setNoseIntensityV2(0.3);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 4: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setColorIntensity(0.7);
                model.setBlurIntensity(3.9);
                model.setCheekThinningIntensity(0.3);
                model.setCheekSmallIntensityV2(0.05);
                model.setEyeEnlargingIntensityV2(0.65);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 5: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setFilterName(FaceBeautyFilterEnum.FENNEN_2);
                model.setFilterIntensity(0.5);
                model.setColorIntensity(0.6);
                model.setBlurIntensity(3.0);
                model.setCheekThinningIntensity(0.5);
                model.setEyeEnlargingIntensityV2(0.65);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 6: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setFilterName(FaceBeautyFilterEnum.FENNEN_2);
                model.setFilterIntensity(0.8);
                model.setColorIntensity(0.7);
                model.setBlurIntensity(4.2);
                model.setEyeEnlargingIntensityV2(0.6);
                model.setCheekThinningIntensity(0.3);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
            case 7: {
                FaceBeauty model = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
                model.setFaceShapeIntensity(1.0);
                model.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
                model.setFilterName(FaceBeautyFilterEnum.ZIRAN_5);
                model.setFilterIntensity(0.55);
                model.setColorIntensity(0.2);
                model.setRedIntensity(0.65);
                model.setBlurIntensity(3.3);
                model.setCheekSmallIntensityV2(0.05);
                model.setCheekThinningIntensity(0.1);
                FURenderKit.getInstance().setFaceBeauty(model);
                break;
            }
        }
        faceBeauty = FURenderKit.getInstance().getFaceBeauty();
    }

    public static void resetSkinBeauty(FaceBeauty faceBeauty) {
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

    public static void resetShapeBeauty(FaceBeauty faceBeauty) {
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

    public static void resetFilter(FaceBeauty faceBeauty) {
        faceBeauty.setFilterName(FaceBeautyFilterEnum.ZIRAN_2);
        faceBeauty.setFilterIntensity(0.4);
    }

    public static void resetAll() {
        resetFilter(defaultFaceBeauty);
        resetShapeBeauty(defaultFaceBeauty);
        resetSkinBeauty(defaultFaceBeauty);
        faceBeauty = defaultFaceBeauty;
    }
    
    private static FaceBeauty getDefaultFaceBeauty() {
        FaceBeauty faceBeauty = new FaceBeauty(new FUBundleData(DemoConfig.BUNDLE_FACE_BEAUTIFICATION));
        resetFilter(faceBeauty);
        resetShapeBeauty(faceBeauty);
        resetSkinBeauty(faceBeauty);
        return faceBeauty;
    }

    public static FaceBeauty getFaceBeauty() {
        return faceBeauty;
    }

    public static int getBeautyIndex() {
        return beautyIndex;
    }

    public static void setBeautyIndex(int beautyIndex) {
        FaceBeautyDataFactory.beautyIndex = beautyIndex;
    }
}

