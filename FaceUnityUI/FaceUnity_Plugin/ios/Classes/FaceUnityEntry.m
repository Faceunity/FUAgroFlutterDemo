//
//  FaceUnityEntry.m
//  faceunity_plugin
//
//  Created by Chen on 2021/10/12.
//

#import "FaceUnityEntry.h"
#import <objc/runtime.h>
#import "FUManager.h"
#import "FUModulePluginProtocol.h"
#import "FlutterPluginHeaders.h"

static const NSString *moduleMapKey;


@interface FaceUnityEntry ()<FUModulePluginProtocol>
//缓存各个模块的实例, key为类名称
@property (nonatomic, strong) NSMutableDictionary *moduleMap;
@end


@implementation FaceUnityEntry
+ (instancetype)shareInstance {
    static FaceUnityEntry *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FaceUnityEntry alloc] init];
        //初始化sdk
        [[FUManager shareManager] configSDK];
    });
    return _instance;
}

/**
 * 入口接口
 */
+ (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    FlutterMethodCall *customCall = call;
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:result:",customCall.method]);
    
    if (![[FaceUnityEntry shareInstance] respondsToSelector:selector]) {
        NSLog(@"FULiveModulePlugin can not respondsToSelector:%@",customCall.method);
        result(FlutterMethodNotImplemented);
        return ;
    }
    
    NSMethodSignature *signature = [[FaceUnityEntry shareInstance] methodSignatureForSelector:selector];
    
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = [FaceUnityEntry shareInstance];
    invocation.selector = selector;
    
    [invocation setArgument:&customCall atIndex:2];
    [invocation setArgument:&result atIndex:3];
    
    [invocation invoke];
    
}


#pragma set/get
- (void)setModuleMap:(NSMutableDictionary *)moduleMap {
    objc_setAssociatedObject(self, &moduleMapKey, moduleMap, OBJC_ASSOCIATION_RETAIN);
}


- (NSMutableDictionary *)moduleMap {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &moduleMapKey);
    if (!dic) {
        self.moduleMap = [NSMutableDictionary dictionary];
        dic = objc_getAssociatedObject(self, &moduleMapKey);
    }
    return dic;
}

//正向代理,销毁插件
- (void)disposePluginWithKey:(NSString *)key {
    if ([self.moduleMap.allKeys containsObject:key]) {
        [self.moduleMap removeObjectForKey: key];
    } else {
        NSLog(@"%@不存在",key);
    }
}

//反向代理提供给需要的插件类当前的插件容器数组
- (NSDictionary *)faceunityWithPluginContainer {
    return [self.moduleMap copy];
}

//viewModel容器类接口
- (void)viewModelManagerPlugin:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self targetWithClass:[FlutterViewModelManagerPlugin class] actionWithCall:call result:result];
}

//美颜相关接口
- (void)beauty:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self targetWithClass:[FlutterFUBeautyPlugin class] actionWithCall:call result:result];
}

//贴纸相关接口
- (void)sticker:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self targetWithClass:[FUStickerPlugin class] actionWithCall:call result:result];
}


- (void)makeup:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self targetWithClass:[FUMakeupPlugin class] actionWithCall:call result:result];
}


- (void)targetWithClass:(Class)cls actionWithCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!cls) {
        NSLog(@"cls can not be nil");
        return ;
    }
    NSObject *obj;
    NSString *key = NSStringFromClass(cls);
    if ([self.moduleMap.allKeys containsObject:key]) {
        obj = self.moduleMap[key];
    } else {
        obj = [[cls alloc] init];
        [self.moduleMap setObject:obj forKey:key];
        if ([obj isKindOfClass:[FlutterFUBasePlugin class]]) {
            FlutterFUBasePlugin *plugin = (FlutterFUBasePlugin *)obj;
            plugin.delegate = self;
        } else {
            NSLog(@"plugin:%@ 未继承基类:FlutterFUMakeupPlugin",obj);
        }
    }
   
    if ([call.arguments isKindOfClass:[NSDictionary class]]) {
        //提取参数作为判断
        NSDictionary *param = (NSDictionary *)call.arguments;
        SEL selector;
        if ([param.allKeys containsObject:@"method"]) {
            if (param.allKeys.count > 1) {//表明还有其他参数需要在方法名称后面加 :
                
                selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",call.arguments[@"method"]]);
            } else {
                selector = NSSelectorFromString([NSString stringWithFormat:@"%@",call.arguments[@"method"]]);
            }
            
        } else {
            //没有定义方法默认以call.method 作为方法名称
            selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",call.method]);
        }
       
        if (![obj respondsToSelector:selector]) {
            NSLog(@"beauty can not respondsToSelector:%s",selector);
            result(FlutterMethodNotImplemented);
            return ;
        }
        NSMethodSignature *signature = [obj methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = obj;
        invocation.selector = selector;

        if (param.count > 1) {
            [invocation setArgument:&param atIndex:2];
        }
        [invocation invoke];
        
        //返回值一定要是对象类型，基本类型 int, float ,double 等需要封装成NSNumber，id是对象，在堆里面，基本数据类型在字符常量区，需要用一个指针指向。
        id __unsafe_unretained returnValue = nil;
        if (signature.methodReturnLength != 0) {
            [invocation getReturnValue:&returnValue];
            result(returnValue);
        }

    } else {
        NSLog(@"参数类型未定义");
    }

    result(0);
}
@end
