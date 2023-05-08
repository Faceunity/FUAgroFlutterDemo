//
//  FUBeautyShapeConsumer.m
//  BeautifyExample
//
//  Created by Chen on 2021/4/25.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "FUBeautyShapeViewModel.h"
#import "FUBaseModel.h"
#import "FUBeautyDefine.h"
#import <FURenderKit/FURenderKit.h>

@interface FUBeautyShapeViewModel ()
@property (nonatomic, strong) FUBeauty *beauty;
@end

@implementation FUBeautyShapeViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        if ([FURenderKit shareRenderKit].beauty) {
            self.beauty = [FURenderKit shareRenderKit].beauty;
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
            self.beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
            /* 默认精细磨皮 */
            self.beauty.heavyBlur = 0;
            self.beauty.blurType = 2;
            /* 默认自定义脸型 */
            self.beauty.faceShape = 4;
            self.beauty.enable = NO;
//            [FURenderKit shareRenderKit].beauty = self.beauty;
        }
        if ([FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh) {
            self.beauty.blurType = 3;
        } else {
            self.beauty.blurType = 2;
        }
        self.type = FUDataTypeBeauty;
    }
    return self;
}


- (void)consumerWithData:(id)model viewModelBlock:(ViewModelBlock _Nullable)ViewModelBlock {
    FUBaseModel *m = nil;
    if ([model isKindOfClass:[FUBaseModel class]]) {
        m = (FUBaseModel *)model;
    } else {
        NSLog(@"%@数据源model 不正确",self);
        return;
    }
    float value = [m.mValue floatValue];
    switch (m.indexPath.row) {
        case FUBeautifyShapeCheekThinning: {
            self.beauty.cheekThinning = value;
        }
            break;
        case FUBeautifyShapeCheekV: {
            self.beauty.cheekV = value;
        }
            break;
        case FUBeautifyShapeCheekNarrow: {
            self.beauty.cheekNarrow = value;
        }
            break;
        case FUBeautifyShapeCheekShort: {
            self.beauty.cheekShort = value;
        }
            break;
        case FUBeautifyShapeCheekSmall: {
            self.beauty.cheekSmall = value;
        }
            break;
        case FUBeautifyShapeCheekbones: {
            self.beauty.intensityCheekbones = value;
        }
            break;
        case FUBeautifyShapeLowerJaw: {
            self.beauty.intensityLowerJaw = value;
        }
            break;
        case FUBeautifyShapeEyeEnlarging: {
            self.beauty.eyeEnlarging = [m.mValue floatValue];
        }
            break;
        case FUBeautifyShapeEyeCircle: {
            self.beauty.intensityEyeCircle = [m.mValue floatValue];
        }
            break;
        case FUBeautifyShapeChin: {
            self.beauty.intensityChin = value;
        }
            break;
        case FUBeautifyShapeForehead: {
            self.beauty.intensityForehead = value;
        }
            break;
        case FUBeautifyShapeNose: {
            self.beauty.intensityNose = value;
        }
            break;
        case FUBeautifyShapeMouth: {
            self.beauty.intensityMouth = value;
        }
            break;
        case FUBeautifyShapeLipThick: {
            self.beauty.intensityLipThick = value;
        }
            break;
        case FUBeautifyShapeEyeHeight: {
            self.beauty.intensityEyeHeight = value;
        }
            break;
        case FUBeautifyShapeCanthus: {
            self.beauty.intensityCanthus = value;
        }
            break;
        case FUBeautifyShapeEyeLid: {
            self.beauty.intensityEyeLid = value;
        }
            break;
        case FUBeautifyShapeEyeSpace: {
            self.beauty.intensityEyeSpace = value;
        }
            break;
        case FUBeautifyShapeEyeRotate: {
            self.beauty.intensityEyeRotate = value;
        }
            break;
        case FUBeautifyShapeLongNose: {
            self.beauty.intensityLongNose = value;
        }
            break;
        case FUBeautifyShapePhiltrum: {
            self.beauty.intensityPhiltrum = value;
        }
            break;
        case FUBeautifyShapeSmile: {
            self.beauty.intensitySmile = value;
        }
            break;
        case FUBeautifyShapeBrowHeight: {
            self.beauty.intensityBrowHeight = value;
        }
            break;
        case FUBeautifyShapeBrowSpace: {
            self.beauty.intensityBrowSpace = value;
        }
            break;
        case FUBeautifyShapeBrowThick: {
            self.beauty.intensityBrowThick = value;
        }
            break;
        default:
            break;
    }
    
    if (ViewModelBlock) {
        ViewModelBlock(nil);
    }
}


#pragma mark - 协议方法
- (BOOL)isDefaultValue {
    NSArray *arr = self.provider.dataSource;
    for (FUBaseModel *model in arr){
        if (fabs([model.mValue floatValue] - [model.defaultValue floatValue]) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}

- (void)resetDefaultValue {
    NSArray *arr = self.provider.dataSource;
    for (FUBaseModel *model in arr) {
        model.mValue = model.defaultValue;
        [self consumerWithData:model viewModelBlock:nil];
    }
}

- (BOOL)isNeedSlider {
    return YES;
}

//加到FURenderKit 渲染loop
- (void)addToRenderLoop {
    [FURenderKit shareRenderKit].beauty = self.beauty;
    [self startRender];
}

//移除
- (void)removeFromRenderLoop {
    [self stopRender];
    [FURenderKit shareRenderKit].beauty = nil;
}

- (void)startRender {
    [FURenderKit shareRenderKit].beauty.enable = YES;
}

- (void)stopRender {
    [FURenderKit shareRenderKit].beauty.enable = NO;
}

- (void)resetMaxFacesNumber {
    [FUAIKit shareKit].maxTrackFaces = 4;
}


- (void)cacheData {
    [self.provider cacheData];
}
@end
