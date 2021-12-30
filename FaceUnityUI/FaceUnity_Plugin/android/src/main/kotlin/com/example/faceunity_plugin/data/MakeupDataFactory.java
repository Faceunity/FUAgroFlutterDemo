package com.example.faceunity_plugin.data;


import com.faceunity.core.entity.FUBundleData;
import com.faceunity.core.enumeration.FUAITypeEnum;
import com.faceunity.core.faceunity.FUAIKit;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.core.model.makeup.SimpleMakeup;

import java.util.HashMap;

/**
 * DESC：美妆业务工厂
 * Created on 2021/3/1
 */
public class MakeupDataFactory {


    /*渲染控制器*/
    private FURenderKit mFURenderKit = FURenderKit.getInstance();

    /*美妆数据模型*/
    private SimpleMakeup currentMakeup;
    /*美妆数据模型缓存*/
    private HashMap<String, SimpleMakeup> makeupMap = new HashMap<>();


    public MakeupDataFactory(int index) {
        currentMakeup = getMakeupModel(index); // 当前生效模型
    }

    public void config() {
        FUAIKit.getInstance().loadAIProcessor(BundlePathConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR);
        if (currentMakeup != null) {
            mFURenderKit.setMakeup(currentMakeup);
        }
    }

    public void dispose() {
        FUAIKit.getInstance().releaseAllAIProcessor();
        mFURenderKit.setMakeup(null);
        currentMakeup = null;
    }


    /**
     * 切换组合妆容
     *
     * @param index
     */
    public void selectedItem(int index) {
        currentMakeup = getMakeupModel(index);
        mFURenderKit.setMakeup(currentMakeup);
    }

    /**
     * 切换美妆模型整体强度
     * @param intensity
     */
    public void sliderValueChange(int index, double intensity) {
        selectedItem(index);
        currentMakeup.setMakeupIntensity(intensity);
    }

    /**
     * 构造美妆模型
     *
     * @param index
     * @return
     */
    private SimpleMakeup getMakeupModel(int index) {
        String bundlePath = getBundlePath(index);
        if (bundlePath == null) {
            return null;
        } else {
            if (makeupMap.containsKey(bundlePath)) {
                return makeupMap.get(bundlePath);
            }
            SimpleMakeup makeup = new SimpleMakeup(new FUBundleData(BundlePathConfig.BUNDLE_FACE_MAKEUP));
            makeup.setCombinedConfig(new FUBundleData(bundlePath));
            makeup.setMakeupIntensity(1f);
            makeupMap.put(bundlePath, makeup);
            return makeup;
        }
    }

    private String getBundlePath(int index) {
        if (index == 1) {
            return "makeup/chaoa.bundle";
        }else if (index == 2) {
            return "makeup/dousha.bundle";
        }else if (index == 3) {
            return "makeup/naicha.bundle";
        }else {
            return null;
        }
    }
}
