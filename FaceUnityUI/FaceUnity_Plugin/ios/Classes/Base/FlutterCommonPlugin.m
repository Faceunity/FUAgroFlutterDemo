//
//  FlutterCommonPlugin.m
//  FlutterPluginRegistrant
//
//  Created by Chen on 2021/8/19.
//

#import "FlutterCommonPlugin.h"
#import "FUFlutterEventChannel.h"
#import "FUFlutterPluginModelProtocol.h"
#import <FURenderKit/FURenderKit.h>
#import <FURenderKit/FUAIKit.h>
#import "NSObject+economizer.h"
#import "FlutterBaseModel.h"
@interface FlutterCommonModel : FlutterBaseModel <FUFlutterPluginModelProtocol>

@end

@implementation FlutterCommonModel
@synthesize value, method, channel;
@end

@interface FlutterCommonPlugin () <FURenderKitDelegate> {
    size_t _imageW;
    size_t _imageH;
}
//是否检测到人脸
@property (nonatomic, assign) BOOL hasFace;

@property (nonatomic, copy) NSString *debugStr;
@property (nonatomic, assign) BOOL compare;


@end

@implementation FlutterCommonPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


//目的获取channel
- (void)startBeautyStreamListen:(NSDictionary *)params {
    FlutterCommonModel *model = [FlutterCommonModel analysis: params];
    if (!self.eventChannel) {
        self.eventChannel = model.channel;
    }
}


//FULiveModulePlugin 销毁plugin
- (void)disposeCommon {
    if ([self.delegate respondsToSelector:@selector(disposePluginWithKey:)]) {
        [self.delegate disposePluginWithKey:NSStringFromClass([self class])];
    }
}


@end
