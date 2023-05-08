//
//  FUMakeupConsumer.m
//  BeautifyExample
//
//  Created by Chen on 2021/4/25.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "FUMakeupViewModel.h"
#import "FUBaseModel.h"
#import <FURenderKit/FURenderKit.h>
#import "FUManager.h"
#import "NSObject+AddBundle.h"
#import "FUMakeupModel.h"

@interface FUMakeupViewModel ()
//现在用来记录旧版本的美妆用。
@property (nonatomic, strong) FUMakeup *makeup;
@property (nonatomic, strong) NSString *oldPackageName;
//道具加载队列
@property (nonatomic, strong) dispatch_queue_t loadQueue;
@end

@implementation FUMakeupViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _loadQueue = dispatch_queue_create("namaLoad.com", DISPATCH_QUEUE_SERIAL);
        self.type = FUDataTypeMakeup;
    }
    return self;
}

- (void)_createOldMakeup {
    NSString *path = [self loadPathWithFileName:@"face_makeup" ofType:@"bundle"];
    self.makeup = [[FUMakeup alloc] initWithPath:path name:@"makeUp"];
    self.makeup.isMakeupOn = YES;
    [FURenderKit shareRenderKit].makeup = self.makeup;
}


- (void)consumerWithData:(id)model viewModelBlock:(ViewModelBlock _Nullable)ViewModelBlock {
    FUMakeupModel *m = nil;
    if ([model isKindOfClass:[FUMakeupModel class]]) {
        m = (FUMakeupModel *)model;
    } else {
        NSLog(@"%@数据源model 不正确",self);
        return;
    }
    
    if ([self.oldPackageName isEqualToString:m.imageName]) {
        self.makeup.intensity = [m.mValue doubleValue];
        
        if (ViewModelBlock) {
            ViewModelBlock(nil);
        }
        return ;
    }
    
    if ([FURenderKit shareRenderKit].makeup) {
        [FURenderKit shareRenderKit].makeup.enable = NO;
    }
    
    dispatch_async(self.loadQueue, ^{
        if (m.newMakeupFlag) {
            NSString *path = [self loadPathWithFileName:m.imageName ofType:@"bundle"];
            FUMakeup *makeup = [[FUMakeup alloc] initWithPath:path name:@"makeUp"];
            makeup.isMakeupOn = YES;
            // 高端机打开全脸分割
            makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
            makeup.intensity = [m.mValue doubleValue];
            NSLog(@"makeup.intensity == %f",makeup.intensity);
            makeup.filterIntensity = 0.0;
            //先卸载其他妆容在加载新版本美妆
            [self _loadMakeupPackageWithPathName:nil];
            self.makeup = nil;
            [FURenderKit shareRenderKit].makeup = nil;
            [FURenderKit shareRenderKit].makeup = makeup;
        } else {
            if ([m.imageName isEqualToString:@"makeup_noitem"]) {
                //判断是卸妆
                return ;
            }
            if (!self.makeup) {
                [self _createOldMakeup];
    
                // 高端机打开全脸分割
                self.makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
            }
            [self _loadMakeupPackageWithPathName:m.imageName];
            NSLog(@"makeup.intensity == %f",[m.mValue doubleValue]);
            [self setMakeupIntensity:[m.mValue doubleValue]];
        }
        [FURenderKit shareRenderKit].makeup.enable = YES;
    });
   
    
    if (ViewModelBlock) {
        ViewModelBlock(nil);
    }
}

- (void)_loadMakeupPackageWithPathName:(NSString *)pathName {
    //替换bundle
    NSString *path = [self loadPathWithBundleName:@"FaceUnity_Plugin" fileName:pathName ofType:@"bundle"];
    if (path) {
        FUItem *item = [[FUItem alloc] initWithPath:path name:pathName];
        [self.makeup updateMakeupPackage:item needCleanSubItem:NO];
    } else {
        [self.makeup updateMakeupPackage:nil needCleanSubItem:NO];
    }
    NSLog(@"loadMakeupPackageWithPathName compeletion");
}

- (void)setMakeupIntensity:(double)value {
    //设置整体妆容值
    dispatch_async(self.loadQueue, ^{
        [FURenderKit shareRenderKit].makeup.intensity = value;
    });
}

- (void)setNewMakeupIntensity:(double)value {
    //设置整体妆容值
    dispatch_async(self.loadQueue, ^{
        [FURenderKit shareRenderKit].makeup.intensity = value;
        [FURenderKit shareRenderKit].makeup.filterIntensity = 0.0;
    });
}

- (BOOL)isNeedSlider {
    return YES;
}

//加到FURenderKit 渲染loop
- (void)addToRenderLoop {
    [FURenderKit shareRenderKit].makeup = self.makeup;
    [self startRender];
}

//移除
- (void)removeFromRenderLoop {
    [self stopRender];
    [FURenderKit shareRenderKit].makeup.enable = NO;
}


- (void)startRender {
    [FURenderKit shareRenderKit].makeup.enable = YES;
}


- (void)stopRender {
    [FURenderKit shareRenderKit].makeup = nil;
}

- (void)resetMaxFacesNumber {
    [FUAIKit shareKit].maxTrackFaces = 4;
}


@end
