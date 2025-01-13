//
//  FURenderKitManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/22.
//

#import "FURenderKitManager.h"
#import "authpack.h"

@interface FURenderKitManager ()

@property (nonatomic, assign) FUDevicePerformanceLevel deviceLevel;

@property (nonatomic, assign) BOOL isEffectsOn;

@end

@implementation FURenderKitManager

+ (instancetype)sharedManager {
    static FURenderKitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FURenderKitManager alloc] init];
    });
    return instance;
}

- (void)setupRenderKit {

    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    
    // 设置日志等级
    [FURenderKit setLogLevel:FU_LOG_LEVEL_INFO];
    
    [FUAIKit shareKit].maxTrackFaces = 4;
    
   
    self.deviceLevel = [FURenderKit devicePerformanceLevel];
    if (self.deviceLevel <= FUDevicePerformanceLevelLow) {
        // 打开动态质量
        [FURenderKit setDynamicQualityControlEnabled:YES];
    }
    
    // 加载AI相关资源
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [FURenderKitManager loadFaceAIModel];
        [FURenderKitManager loadHumanAIModel];
        [self setDevicePerformanceDetails];
    });
    
    // 默认加载美颜
    [self loadBeauty];
    self.isEffectsOn = YES;
    
}


- (void)setDevicePerformanceDetails {
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = self.deviceLevel >= FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = self.deviceLevel >= FUDevicePerformanceLevelHigh;
}

+ (void)loadFaceAIModel {
    FUDevicePerformanceLevel level = [FURenderKitManager sharedManager].deviceLevel;
    FUFaceAlgorithmConfig config = FUFaceAlgorithmConfigEnableAll;
    if (level < FUDevicePerformanceLevelHigh) {
        // 关闭所有效果
        config = FUFaceAlgorithmConfigDisableAll;
    } else if (level < FUDevicePerformanceLevelVeryHigh) {
        // 关闭皮肤分割、祛斑痘和 ARMeshV2
        config = FUFaceAlgorithmConfigDisableSkinSegAndDelSpot | FUFaceAlgorithmConfigDisableARMeshV2;
    } else if (level < FUDevicePerformanceLevelExcellent) {
        config = FUFaceAlgorithmConfigDisableSkinSeg;
    }
    [FUAIKit setFaceAlgorithmConfig:config];
    NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
}

+ (void)loadHumanAIModel{
    NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
    [FUAIKit loadAIHumanModelWithDataPath:bodyAIPath segmentationMode:(FUHumanSegmentationModeCPUCommon)];
}

- (void)destoryRenderKit {
    [FURenderKit destroy];
}

+ (BOOL)faceTracked {
    return [FUAIKit aiFaceProcessorNums] > 0;
}

+ (BOOL)humanTracked {
    return [FUAIKit aiHumanProcessorNums] > 0;
}

+ (BOOL)handTracked {
    return [FUAIKit aiHandDistinguishNums] > 0;
}

- (void)setMaximumFacesNumber:(NSNumber *)number {
    int facesNumber = number.intValue < 1 ? 1 : (number.intValue > 4 ? 4 : number.intValue);
    [FUAIKit shareKit].maxTrackFaces = facesNumber;
}

+ (void)setMaxHumanNumber:(NSInteger)number {
    [FUAIKit shareKit].maxTrackBodies = (int)number;
}

+ (void)updateBeautyBlurEffect {
    if (![FURenderKit shareRenderKit].beauty || ![FURenderKit shareRenderKit].beauty.enable) {
        return;
    }
    if ([FURenderKitManager sharedManager].deviceLevel >= FUDevicePerformanceLevelHigh) {
        // 根据人脸置信度设置不同磨皮效果
        CGFloat score = [FUAIKit fuFaceProcessorGetConfidenceScore:0];
        if (score > 0.95) {
            [FURenderKit shareRenderKit].beauty.blurType = 3;
            [FURenderKit shareRenderKit].beauty.blurUseMask = YES;
        } else {
            [FURenderKit shareRenderKit].beauty.blurType = 2;
            [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
        }
    } else {
        // 设置精细磨皮效果
        [FURenderKit shareRenderKit].beauty.blurType = 2;
        [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
    }
}

+ (void)resetTrackedResult {
    [FUAIKit resetTrackedResult];
}

+ (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode {
    [FUAIKit shareKit].faceProcessorDetectMode = mode;
}

+ (void)setHumanProcessorDetectMode:(FUHumanProcessorDetectMode)mode {
    [FUAIKit shareKit].humanProcessorDetectMode = mode;
}

+ (void)clearItems {
    [FUAIKit unloadAllAIMode];
    [FURenderKit clear];
}

- (NSNumber *)devicePerformanceLevel {
    return [NSNumber numberWithInt:(int)[FURenderKitManager sharedManager].deviceLevel];
}

- (NSNumber *)isNPUSupported {
    return [NSNumber numberWithBool:[UIDevice currentDevice].fu_deviceModelType >= FUDeviceModelTypeiPhoneXR];
}

- (void)turnOffEffects {
    if ([FURenderKit shareRenderKit].beauty) {
        [FURenderKit shareRenderKit].beauty.enable = NO;
    }
    if ([FURenderKit shareRenderKit].makeup) {
        [FURenderKit shareRenderKit].makeup.enable = NO;
    }
    if ([FURenderKit shareRenderKit].stickerContainer.allStickers.count > 0) {
        FUSticker *sticker = [FURenderKit shareRenderKit].stickerContainer.allStickers[0];
        sticker.enable = NO;
    }
    if ([FURenderKit shareRenderKit].bodyBeauty) {
        [FURenderKit shareRenderKit].bodyBeauty.enable = NO;
    }
    _isEffectsOn = NO;
}

- (void)turnOnEffects {
    if ([FURenderKit shareRenderKit].beauty) {
        [FURenderKit shareRenderKit].beauty.enable = YES;
    }
    if ([FURenderKit shareRenderKit].makeup) {
        [FURenderKit shareRenderKit].makeup.enable = YES;
    }
    if ([FURenderKit shareRenderKit].stickerContainer.allStickers.count > 0) {
        FUSticker *sticker = [FURenderKit shareRenderKit].stickerContainer.allStickers[0];
        sticker.enable = YES;
    }
    if ([FURenderKit shareRenderKit].bodyBeauty) {
        [FURenderKit shareRenderKit].bodyBeauty.enable = YES;
    }
    _isEffectsOn = YES;
}

- (void)loadBody {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"body_slim" ofType:@"bundle"];
    FUBodyBeauty *bodyBeauty = [[FUBodyBeauty alloc] initWithPath:filePath name:@"FUBodyBeauty"];
    [FURenderKit shareRenderKit].bodyBeauty = bodyBeauty;
}

- (void)loadBeauty {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    beauty.heavyBlur = 0;
    // 默认均匀磨皮
    beauty.blurType = 3;
    // 默认精细变形
    beauty.faceShape = 4;
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh) {
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    [FURenderKit shareRenderKit].beauty = beauty;
}

- (void)unloadBody {
    [FURenderKit shareRenderKit].bodyBeauty = nil;
}

- (void)unloadBeauty {
    [FURenderKit shareRenderKit].beauty = nil;
}

- (void)checkIsBeautyLoaded {
    if (![FURenderKit shareRenderKit].beauty) {
        [self loadBeauty];
    }
}

- (void)checkIsBodyLoaded {
    if (![FURenderKit shareRenderKit].bodyBeauty) {
        [self loadBody];
    }
}

@end

