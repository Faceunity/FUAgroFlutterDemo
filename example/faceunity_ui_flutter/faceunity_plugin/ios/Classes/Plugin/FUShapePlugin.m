//
//  FUShapePlugin.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/7.
//

#import "FUShapePlugin.h"
#import <FURenderKit/FURenderKit.h>

typedef NS_ENUM(NSUInteger, FUBeautyShape) {
    FUBeautyShapeCheekThinning = 0,
    FUBeautyShapeCheekV,
    FUBeautyShapeCheekNarrow,
    FUBeautyShapeCheekShort,
    FUBeautyShapeCheekSmall,
    FUBeautyShapeCheekbones,
    FUBeautyShapeLowerJaw,
    FUBeautyShapeEyeEnlarging,
    FUBeautyShapeEyeCircle,
    FUBeautyShapeChin,
    FUBeautyShapeForehead,
    FUBeautyShapeNose,
    FUBeautyShapeMouth,
    FUBeautyShapeLipThick,
    FUBeautyShapeEyeHeight,
    FUBeautyShapeCanthus,
    FUBeautyShapeEyeLid,
    FUBeautyShapeEyeSpace,
    FUBeautyShapeEyeRotate,
    FUBeautyShapeLongNose,
    FUBeautyShapePhiltrum,
    FUBeautyShapeSmile,
    FUBeautyShapeBrowHeight,
    FUBeautyShapeBrowSpace,
    FUBeautyShapeBrowThick
};

@implementation FUShapePlugin

- (void)setShapeIntensity:(NSNumber *)intensity type:(NSNumber *)type {
    double value = intensity.doubleValue;
    switch (type.integerValue) {
        case FUBeautyShapeCheekThinning:
            [FURenderKit shareRenderKit].beauty.cheekThinning = value;
            break;
        case FUBeautyShapeCheekV:
            [FURenderKit shareRenderKit].beauty.cheekV = value;
            break;
        case FUBeautyShapeCheekNarrow:
            [FURenderKit shareRenderKit].beauty.cheekNarrow = value;
            break;
        case FUBeautyShapeCheekShort:
            [FURenderKit shareRenderKit].beauty.cheekShort = value;
            break;
        case FUBeautyShapeCheekSmall:
            [FURenderKit shareRenderKit].beauty.cheekSmall = value;
            break;
        case FUBeautyShapeCheekbones:
            [FURenderKit shareRenderKit].beauty.intensityCheekbones = value;
            break;
        case FUBeautyShapeLowerJaw:
            [FURenderKit shareRenderKit].beauty.intensityLowerJaw = value;
            break;
        case FUBeautyShapeEyeEnlarging:
            [FURenderKit shareRenderKit].beauty.eyeEnlarging = value;
            break;
        case FUBeautyShapeEyeCircle:
            [FURenderKit shareRenderKit].beauty.intensityEyeCircle = value;
            break;
        case FUBeautyShapeChin:
            [FURenderKit shareRenderKit].beauty.intensityChin = value;
            break;
        case FUBeautyShapeForehead:
            [FURenderKit shareRenderKit].beauty.intensityForehead = value;
            break;
        case FUBeautyShapeNose:
            [FURenderKit shareRenderKit].beauty.intensityNose = value;
            break;
        case FUBeautyShapeMouth:
            [FURenderKit shareRenderKit].beauty.intensityMouth = value;
            break;
        case FUBeautyShapeLipThick:
            [FURenderKit shareRenderKit].beauty.intensityLipThick = value;
            break;
        case FUBeautyShapeEyeHeight:
            [FURenderKit shareRenderKit].beauty.intensityEyeHeight = value;
            break;
        case FUBeautyShapeCanthus:
            [FURenderKit shareRenderKit].beauty.intensityCanthus = value;
            break;
        case FUBeautyShapeEyeLid:
            [FURenderKit shareRenderKit].beauty.intensityEyeLid = value;
            break;
        case FUBeautyShapeEyeSpace:
            [FURenderKit shareRenderKit].beauty.intensityEyeSpace = value;
            break;
        case FUBeautyShapeEyeRotate:
            [FURenderKit shareRenderKit].beauty.intensityEyeRotate = value;
            break;
        case FUBeautyShapeLongNose:
            [FURenderKit shareRenderKit].beauty.intensityLongNose = value;
            break;
        case FUBeautyShapePhiltrum:
            [FURenderKit shareRenderKit].beauty.intensityPhiltrum = value;
            break;
        case FUBeautyShapeSmile:
            [FURenderKit shareRenderKit].beauty.intensitySmile = value;
            break;
        case FUBeautyShapeBrowHeight:
            [FURenderKit shareRenderKit].beauty.intensityBrowHeight = value;
            break;
        case FUBeautyShapeBrowSpace:
            [FURenderKit shareRenderKit].beauty.intensityBrowSpace = value;
            break;
        case FUBeautyShapeBrowThick:
            [FURenderKit shareRenderKit].beauty.intensityBrowThick = value;
            break;
    }
}

@end
