//
//  FlutterViewModelManagerPlugin.m
//  zego_express_engine
//
//  Created by Chen on 2021/9/14.
//

#import "FlutterViewModelManagerPlugin.h"
#import "FUViewModelManager.h"
#import "FlutterBaseModel.h"
#import "FUFlutterPluginModelProtocol.h"
#import "FUModuleDefine.h"
#import "FUBeautyViewModel.h"
#import "FUManager.h"
@interface FlutterViewModelManagerPluginModel : FlutterBaseModel <FUFlutterPluginModelProtocol>
@property (nonatomic, assign) int bizType;
@end

@implementation FlutterViewModelManagerPluginModel
@synthesize method, value;
@end

@interface FlutterViewModelManagerPlugin ()
@property (nonatomic, strong) FUViewModelManager *manager;

//key 对应的是UI页面的业务索引 0,1,2 对应的是美颜，3,贴纸。4、美妆、5、美体
@property (nonatomic, strong) NSDictionary *moduleMap;
@end

@implementation FlutterViewModelManagerPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        _moduleMap = @{@0:@"FlutterFUBeautyPlugin"};
    }
    return self;
}

- (void)config {
    _manager = [[FUViewModelManager alloc] init];
}

//Plugin销毁协议, 存储时候用的是类名字符串
- (void)dispose {
    if ([self.delegate respondsToSelector:@selector(disposePluginWithKey:)]) {
        [self.delegate disposePluginWithKey:NSStringFromClass([self class])];
    }
}


//switch 按钮
- (void)switchOn:(NSDictionary *)params {
    FlutterViewModelManagerPluginModel *model = [FlutterViewModelManagerPluginModel analysis: params];
    if ([model.value isKindOfClass:[NSNumber class]]) {
        BOOL isOn = [model.value boolValue];
        if (isOn) {
            [self.manager startRender:model.bizType];
        } else {
            [self.manager stopRender:model.bizType];
        }
    } else {
        NSLog(@"switchOn 开关参数类型错误");
    }
}

//兼容处理美颜子项
- (void)compatibleClickBeautyItem:(NSDictionary *)params {
    FlutterViewModelManagerPluginModel *model = [FlutterViewModelManagerPluginModel analysis: params];
    if ([model.value isKindOfClass:[NSNumber class]]) {
        if ([self.manager.selectedViewModel isKindOfClass:[FUBeautyViewModel class]]) {
            FUBeautyViewModel *viewModel = (FUBeautyViewModel *)self.manager.selectedViewModel;
            //美型、美肤、滤镜属于美颜子项，必须要做个特殊处理
            viewModel.beautySubType = [model.value intValue];
        }
    }
}

//当前业务添加到渲染循环
- (void)addViewModelToRunLoop:(NSDictionary *)params {
    FlutterFUBasePlugin *plugin = [self getPluginWithParams:params];
    [self.manager addToRenderLoop: [plugin getPluginViewModel]];
}

//当前从渲染循环移除
- (void)removeViewModelFromRunLoop:(NSDictionary *)params {
    FlutterFUBasePlugin *plugin = [self getPluginWithParams:params];
    [self.manager removeFromRenderLoop: [plugin getPluginViewModel].type];
}


- (FlutterFUBasePlugin *)getPluginWithParams:(NSDictionary *)params {
    FlutterViewModelManagerPluginModel *model = [FlutterViewModelManagerPluginModel analysis: params];
    if ([self.delegate respondsToSelector:@selector(faceunityWithPluginContainer)]) {
        NSDictionary *pluginMap = [self.delegate faceunityWithPluginContainer];
        NSString *key = self.moduleMap[@(model.bizType)];
        if ([pluginMap.allKeys containsObject:key]) {
            FlutterFUBasePlugin *plugin = [pluginMap objectForKey:key];
            return plugin;
        } else {
            NSLog(@"%lu:插件未创建",(unsigned long)model.bizType);
        }
    }
    return nil;
}


@end
