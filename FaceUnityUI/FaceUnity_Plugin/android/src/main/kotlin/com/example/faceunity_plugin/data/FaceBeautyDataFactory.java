package com.example.faceunity_plugin.data;

import android.util.Log;

import com.faceunity.core.entity.FUBundleData;
import com.faceunity.core.enumeration.FUAITypeEnum;
import com.faceunity.core.enumeration.FUFaceBeautyMultiModePropertyEnum;
import com.faceunity.core.enumeration.FUFaceBeautyPropertyModeEnum;
import com.faceunity.core.faceunity.FUAIKit;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.core.model.facebeauty.FaceBeauty;
import com.faceunity.core.model.facebeauty.FaceBeautyBlurTypeEnum;
import com.faceunity.core.model.facebeauty.FaceBeautyFilterEnum;
import com.example.faceunity_plugin.utils.FuDeviceUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private Map<String, Double> filterIntensityMap = new HashMap<>();

    private List<FaceBeautySetParamInterface> faceBeautySkin = new ArrayList<FaceBeautySetParamInterface>(){
      {
        add(value->{
          faceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
          faceBeauty.setBlurIntensity(value);
        });
        add(faceBeauty::setColorIntensity);
        add(faceBeauty::setRedIntensity);
        add(faceBeauty::setSharpenIntensity);
        add(faceBeauty::setFaceThreeIntensity);
        add(faceBeauty::setEyeBrightIntensity);
        add(faceBeauty::setToothIntensity);
        add(faceBeauty::setRemovePouchIntensity);
        add(faceBeauty::setRemoveLawPatternIntensity);
      }
    };

    private List<FaceBeautySetParamInterface> faceBeautyShape = new ArrayList<FaceBeautySetParamInterface>(){
    {
      add(faceBeauty::setCheekThinningIntensity);
      add(faceBeauty::setCheekVIntensity);
      add(faceBeauty::setCheekNarrowIntensity);
      add(faceBeauty::setCheekShortIntensity);

      add(faceBeauty::setCheekSmallIntensity);
      add(faceBeauty::setCheekBonesIntensity);
      add(faceBeauty::setLowerJawIntensity);
      add(faceBeauty::setEyeEnlargingIntensity);

      add(faceBeauty::setEyeCircleIntensity);
      add(faceBeauty::setChinIntensity);
      add(faceBeauty::setForHeadIntensity);
      add(faceBeauty::setNoseIntensity);

      add(faceBeauty::setMouthIntensity);
      add(faceBeauty::setLipThickIntensity);
      add(faceBeauty::setEyeHeightIntensity);
      add(faceBeauty::setCanthusIntensity);

      add(faceBeauty::setEyeLidIntensity);
      add(faceBeauty::setEyeSpaceIntensity);
      add(faceBeauty::setEyeRotateIntensity);
      add(faceBeauty::setLongNoseIntensity);

      add(faceBeauty::setPhiltrumIntensity);
      add(faceBeauty::setSmileIntensity);
      add(faceBeauty::setBrowHeightIntensity);
      add(faceBeauty::setBrowSpaceIntensity);

      add(faceBeauty::setBrowThickIntensity);


    }
  };

    public void config() {
        FUAIKit.getInstance().loadAIProcessor(BundlePathConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR);
        mFURenderKit.setFaceBeauty(faceBeauty);
        filterIntensityMap.put(faceBeauty.getFilterName(), faceBeauty.getFilterIntensity());
        FUAIKit.getInstance().setMaxFaces(4);
    }

    public void dispose() {
        FUAIKit.getInstance().releaseAllAIProcessor();
        filterIntensityMap.clear();
        mFURenderKit.setFaceBeauty(null);
    }

    public void setSkinBeauty(int index, double value) {
      if (index < faceBeautySkin.size()) {
        faceBeautySkin.get(index).setValue(value);
      }
    }

    public void setShapeBeauty(int index, double value) {
      if (index < faceBeautyShape.size()) {
        faceBeautyShape.get(index).setValue(value);
      }
    }

    public void resetSkinBeauty(FaceBeauty faceBeauty) {
        faceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
        faceBeauty.setBlurIntensity(4.2);
        faceBeauty.setColorIntensity(0.3);
        faceBeauty.setRedIntensity(0.3);
        faceBeauty.setSharpenIntensity(0.2);
        faceBeauty.setFaceThreeIntensity(0);
        faceBeauty.setEyeBrightIntensity(0);
        faceBeauty.setToothIntensity(0);
        faceBeauty.setRemovePouchIntensity(0);
        faceBeauty.setRemoveLawPatternIntensity(0);
    }

    public void resetShapeBeauty(FaceBeauty faceBeauty) {
        faceBeauty.setSharpenIntensity(1.0);
        faceBeauty.setCheekThinningIntensity(0);
        faceBeauty.setCheekLongIntensity(0);
        faceBeauty.setCheekCircleIntensity(0);
        faceBeauty.setCheekVIntensity(0.5);
        faceBeauty.setCheekNarrowIntensity(0);
        faceBeauty.setCheekShortIntensity(0);
        faceBeauty.setCheekSmallIntensity(0);
        faceBeauty.setCheekBonesIntensity(0);
        faceBeauty.setLowerJawIntensity(0);
        faceBeauty.setEyeEnlargingIntensity(0.4);
        faceBeauty.setEyeCircleIntensity(0);
        faceBeauty.setChinIntensity(0.3);
        faceBeauty.setForHeadIntensity(0.3);
        faceBeauty.setNoseIntensity(0.5);
        faceBeauty.setMouthIntensity(0.4);
        faceBeauty.setCanthusIntensity(0);
        faceBeauty.setEyeSpaceIntensity(0.5);
        faceBeauty.setEyeRotateIntensity(0.5);
        faceBeauty.setLongNoseIntensity(0.5);
        faceBeauty.setPhiltrumIntensity(0.5);
        faceBeauty.setSmileIntensity(0);
        faceBeauty.setBrowHeightIntensity(0.5);
        faceBeauty.setBrowSpaceIntensity(0.5);
        faceBeauty.setEyeLidIntensity(0);
        faceBeauty.setEyeHeightIntensity(0.5);
        faceBeauty.setBrowThickIntensity(0.5);
        faceBeauty.setLipThickIntensity(0.5);
    }

    public void resetFilter(FaceBeauty faceBeauty) {
        faceBeauty.setFilterName(FaceBeautyFilterEnum.ZIRAN_2);
        faceBeauty.setFilterIntensity(0.4);
        filterIntensityMap.put(FaceBeautyFilterEnum.ZIRAN_2, 0.4);
    }

    public void setFilterIntensity(String filterName, double intensity) {
        filterIntensityMap.put(filterName, intensity);
        faceBeauty.setFilterName(filterName);
        faceBeauty.setFilterIntensity(intensity);
    }

    public void setFilter(int index) {
        String filterName = filters[index];
        Double i = filterIntensityMap.get(filterName);
        if (i == null) {
            i = 0.4;
            filterIntensityMap.put(filterName, i);
        }
        faceBeauty.setFilterName(filterName);
        faceBeauty.setFilterIntensity(i);
    }

    private static FaceBeauty getDefaultFaceBeauty() {
        FaceBeauty recommendFaceBeauty = new FaceBeauty(new FUBundleData(BundlePathConfig.BUNDLE_FACE_BEAUTIFICATION));
        recommendFaceBeauty.setFilterName(FaceBeautyFilterEnum.ZIRAN_1);
        recommendFaceBeauty.setFilterIntensity(0.4);
        /*美肤*/
        recommendFaceBeauty.setBlurType(FaceBeautyBlurTypeEnum.FineSkin);
        recommendFaceBeauty.setSharpenIntensity(0.2);
        recommendFaceBeauty.setColorIntensity(0.3);
        recommendFaceBeauty.setRedIntensity(0.3);
        recommendFaceBeauty.setBlurIntensity(4.2);
        /*美型*/
        recommendFaceBeauty.setFaceShapeIntensity(1.0);
        recommendFaceBeauty.setEyeEnlargingIntensity(0.4);
        recommendFaceBeauty.setCheekVIntensity(0.5);
        recommendFaceBeauty.setNoseIntensity(0.5);
        recommendFaceBeauty.setForHeadIntensity(0.3);
        recommendFaceBeauty.setMouthIntensity(0.4);
        recommendFaceBeauty.setChinIntensity(0.3);
        //性能最优策略
        if (BundlePathConfig.DEVICE_LEVEL > FuDeviceUtils.DEVICE_LEVEL_MID) {
            setFaceBeautyPropertyMode(recommendFaceBeauty);
        }
        return recommendFaceBeauty;
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

  /**
   * 高端机的时候，开启4个相对吃性能的模式
   * 1.祛黑眼圈 MODE2
   * 2.祛法令纹 MODE2
   * 3.大眼 MODE3
   * 4.嘴型 MODE3
   */
  private static void setFaceBeautyPropertyMode(FaceBeauty faceBeauty) {
    /*
     * 多模式属性
     * 属性名称|支持模式|默认模式|最早支持版本
     * 美白 colorIntensity|MODE1 MODE2|MODE2|MODE2 8.2.0;
     * 祛黑眼圈 removePouchIntensity|MODE1 MODE2|MODE2|MODE2 8.2.0;
     * 祛法令纹 removeLawPatternIntensity|MODE1 MODE1|MODE2|MODE2 8.2.0;
     * 窄脸程度 cheekNarrowIntensity|MODE1 MODE2|MODE2|MODE2 8.0.0;
     * 小脸程度 cheekSmallIntensity|MODE1 MODE2|MODE2|MODE2 8.0.0;
     * 大眼程度 eyeEnlargingIntensity|MODE1 MODE2 MODE3|MODE3|MODE2 8.0.0;MODE3 8.2.0;
     * 额头调整程度 forHeadIntensity|MODE1 MODE2|MODE2|MODE2 8.0.0;
     * 瘦鼻程度 noseIntensity|MODE1 MODE2|MODE2|MODE2 8.0.0;
     * 嘴巴调整程度 mouthIntensity|MODE1 MODE2 MODE3|MODE3|MODE2 8.0.0;MODE3 8.2.0;
     */
    faceBeauty.addPropertyMode(FUFaceBeautyMultiModePropertyEnum.REMOVE_POUCH_INTENSITY, FUFaceBeautyPropertyModeEnum.MODE2);
    faceBeauty.addPropertyMode(FUFaceBeautyMultiModePropertyEnum.REMOVE_NASOLABIAL_FOLDS_INTENSITY, FUFaceBeautyPropertyModeEnum.MODE2);
    faceBeauty.addPropertyMode(FUFaceBeautyMultiModePropertyEnum.EYE_ENLARGING_INTENSITY, FUFaceBeautyPropertyModeEnum.MODE3);
    faceBeauty.addPropertyMode(FUFaceBeautyMultiModePropertyEnum.MOUTH_INTENSITY, FUFaceBeautyPropertyModeEnum.MODE3);
  }

  interface FaceBeautySetParamInterface {
    /**
     * 设置属性值
     *
     * @param value
     */
    void setValue(double value);
  }
}

