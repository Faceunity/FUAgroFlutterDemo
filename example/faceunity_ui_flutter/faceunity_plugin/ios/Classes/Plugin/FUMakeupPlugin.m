//
//  FUMakeupPlugin.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/2.
//

#import "FUMakeupPlugin.h"
#import "FUUtil.h"
#import "FURenderKitManager.h"
#import <FURenderKit/FURenderKit.h>

@implementation FUMakeupPlugin

- (void)selectMakeup:(NSString *)bundleName isCombined:(NSNumber *)isCombined intensity:(NSNumber *)intensity {
    [FURenderQueue async:^{
        [FURenderKit shareRenderKit].makeup = nil;
        if (isCombined.boolValue) {
            // 新组合妆，每次加载必须重新初始化
            NSString *path = [FUUtil pluginBundlePathWithName:bundleName];
            FUMakeup *makeup = [FUMakeup itemWithPath:path name:bundleName];
            // 高端机打开全脸分割
            makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
            [FURenderKit shareRenderKit].makeup = makeup;
        } else {
            FUMakeup *makeup = [FUMakeup itemWithPath:[[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"] name:@"face_makeup"];
            makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
            [FURenderKit shareRenderKit].makeup = makeup;
            [self bindCombinationMakeupWithBundleName:bundleName];
        }
        [self setMakeupIntensity:intensity];
        [FURenderKit shareRenderKit].makeup.enable = [FURenderKitManager sharedManager].isEffectsOn;
    }];
}

- (void)setMakeupIntensity:(NSNumber *)intensity {
    if (![FURenderKit shareRenderKit].makeup) {
        return;
    }
    [FURenderKit shareRenderKit].makeup.intensity = intensity.doubleValue;
    // 设置美妆滤镜值
    [FURenderKit shareRenderKit].makeup.filterIntensity = intensity.doubleValue;
}

/// 绑定组合妆到face_makeup.bundle（老组合妆方法）
- (void)bindCombinationMakeupWithBundleName:(NSString *)bundleName {
    NSString *path = [FUUtil pluginBundlePathWithName:bundleName];
    FUItem *item = [[FUItem alloc] initWithPath:path name:bundleName];
    [[FURenderKit shareRenderKit].makeup updateMakeupPackage:item needCleanSubItem:YES];
}

- (void)removeMakeup {
    if ([FURenderKit shareRenderKit].makeup) {
        [FURenderKit shareRenderKit].makeup = nil;
    }
}

@end
