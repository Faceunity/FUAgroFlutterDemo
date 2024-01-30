//
//  FURenderKitManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/22.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FURenderKitManager : NSObject

/// 当前设备性能等级
@property (nonatomic, assign, readonly) FUDevicePerformanceLevel devicePerformanceLevel;

@property (nonatomic, assign, readonly) BOOL isEffectsOn;

+ (instancetype)sharedManager;

/// 初始化FURenderKit
- (void)setupRenderKit;

/// 销毁FURenderKit
- (void)destoryRenderKit;

/// 设备是否高端机型
- (NSNumber *)isHighPerformanceDevice;

/// 设备是否支持 NPU
- (NSNumber *)isNPUSupported;

/// 检查美体是否加载
- (void)checkIsBodyLoaded;

/// 检查美颜是否加载
- (void)checkIsBeautyLoaded;

- (void)turnOffEffects;

- (void)turnOnEffects;

- (void)loadBeauty;

- (void)unloadBeauty;

- (void)loadBody;

- (void)unloadBody;

/// 检测是否有人脸
+ (BOOL)faceTracked;

/// 检测是否有人体
+ (BOOL)humanTracked;

/// 检测是否有手势
+ (BOOL)handTracked;

/// 设置最大人脸数量
- (void)setMaximumFacesNumber:(NSNumber *)number;

/// 设置最大人体数量
+ (void)setMaxHumanNumber:(NSInteger)number;

/// 更新美颜磨皮效果（根据人脸检测置信度设置不同磨皮效果）
+ (void)updateBeautyBlurEffect;

/// 重置面部跟踪结果
+ (void)resetTrackedResult;

/// 设置人脸检测模式
+ (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode;

/// 设置人体检测模式
+ (void)setHumanProcessorDetectMode:(FUHumanProcessorDetectMode)mode;

/// 清除所有资源
+ (void)clearItems;

@end

NS_ASSUME_NONNULL_END
