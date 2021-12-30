package com.example.faceunity_plugin.data;

import com.faceunity.core.entity.FUBundleData;
import com.faceunity.core.enumeration.FUAITypeEnum;
import com.faceunity.core.faceunity.FUAIKit;
import com.faceunity.core.faceunity.FURenderKit;
import com.faceunity.core.model.prop.Prop;
import com.faceunity.core.model.prop.sticker.Sticker;

/**
 * DESC：道具业务工厂
 * Created on 2021/3/2
 */
public class PropDataFactory{

    /*渲染控制器*/
    private final FURenderKit mFURenderKit = FURenderKit.getInstance();
    /*当前道具*/
    private Prop currentProp;

    public PropDataFactory(int index) {
        onItemSelected(index);
    }

    public void config() {
        FUAIKit.getInstance().loadAIProcessor(BundlePathConfig.BUNDLE_AI_FACE, FUAITypeEnum.FUAITYPE_FACEPROCESSOR);
        if (currentProp != null) {
            mFURenderKit.getPropContainer().addProp(currentProp);
        }
    }

    public void dispose() {
        FUAIKit.getInstance().releaseAllAIProcessor();
        mFURenderKit.getPropContainer().removeAllProp();
        currentProp = null;
    }
    
    /**
     * 道具选中
     *
     * @param index
     */
    public void onItemSelected(int index) {
        String path = getStickerPath(index);
        if (path == null || path.trim().length() == 0) {
            mFURenderKit.getPropContainer().removeAllProp();
            currentProp = null;
            return;
        }
        Prop prop = new Sticker(new FUBundleData(path));
        mFURenderKit.getPropContainer().replaceProp(currentProp, prop);
        currentProp = prop;
    }

    private String getStickerPath(int index) {
        if (index == 1) {
            return "sticker/sdlu.bundle";
        }else if (index == 2) {
            return "sticker/fashi.bundle";
        }else {
            return null;
        }
    }

}
