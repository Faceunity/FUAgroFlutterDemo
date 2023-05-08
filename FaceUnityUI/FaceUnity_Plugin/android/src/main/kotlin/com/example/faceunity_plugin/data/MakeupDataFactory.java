package com.example.faceunity_plugin.data;


import com.faceunity.core.entity.FUBundleData;
import com.faceunity.core.enumeration.FUAITypeEnum;
import com.faceunity.core.faceunity.FUAIKit;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.core.model.makeup.SimpleMakeup;
import com.example.faceunity_plugin.utils.FuDeviceUtils;
import com.example.faceunity_plugin.data.BundlePathConfig;

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

            SimpleMakeup makeup;
            if (index >= 1 && index <= 4) {
                makeup = new SimpleMakeup(new FUBundleData(bundlePath));
            }else {
                makeup = new SimpleMakeup(new FUBundleData(BundlePathConfig.BUNDLE_FACE_MAKEUP));
                makeup.setCombinedConfig(new FUBundleData(bundlePath));
            }

            makeup.setMachineLevel(BundlePathConfig.DEVICE_LEVEL > FuDeviceUtils.DEVICE_LEVEL_MID);//更新设备等级去设置是否开启人脸遮挡
            makeup.setMakeupIntensity(0.7f);
            makeupMap.put(bundlePath, makeup);
            return makeup;
        }
    }

    private String getBundlePath(int index) {
        switch (index) {
          case 1: return "makeup/diadiatu.bundle";
          case 2: return "makeup/dongling.bundle";
          case 3: return "makeup/guofeng.bundle";
          case 4: return "makeup/hunxie.bundle";
          case 5: return "makeup/jianling.bundle";
          case 6: return "makeup/nuandong.bundle";
          default: return null;
        }
    }
}
