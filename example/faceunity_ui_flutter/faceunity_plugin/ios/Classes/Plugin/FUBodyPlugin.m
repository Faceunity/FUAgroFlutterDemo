//
//  FUBodyPlugin.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/8.
//

#import "FUBodyPlugin.h"
#import <FURenderKit/FURenderKit.h>

/// 美体模块子功能
typedef NS_ENUM(NSUInteger, FUBeautyBody) {
    FUBeautyBodySlim,                   // 瘦身
    FUBeautyBodyLongLeg,                // 长腿
    FUBeautyBodyThinWaist,              // 细腰
    FUBeautyBodyBeautyShoulder,         // 美肩
    FUBeautyBodyBeautyButtock,          // 美臀
    FUBeautyBodySmallHead,              // 小头
    FUBeautyBodyThinLeg,                // 瘦腿
};


@implementation FUBodyPlugin

- (void)setBodyIntensity:(NSNumber *)intensity type:(NSNumber *)type {
    double value = intensity.doubleValue;
    switch (type.integerValue) {
        case FUBeautyBodySlim:
            [FURenderKit shareRenderKit].bodyBeauty.bodySlimStrength = value;
            break;
        case FUBeautyBodyLongLeg:
            [FURenderKit shareRenderKit].bodyBeauty.legSlimStrength = value;
            break;
        case FUBeautyBodyThinWaist:
            [FURenderKit shareRenderKit].bodyBeauty.waistSlimStrength = value;
            break;
        case FUBeautyBodyBeautyShoulder:
            [FURenderKit shareRenderKit].bodyBeauty.shoulderSlimStrength = value;
            break;
        case FUBeautyBodyBeautyButtock:
            [FURenderKit shareRenderKit].bodyBeauty.hipSlimStrength = value;
            break;
        case FUBeautyBodySmallHead:
            [FURenderKit shareRenderKit].bodyBeauty.headSlim = value;
            break;
        case FUBeautyBodyThinLeg:
            [FURenderKit shareRenderKit].bodyBeauty.legSlim = value;
            break;
    }
}

@end
