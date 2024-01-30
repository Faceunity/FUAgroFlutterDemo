#import "FaceunityPlugin.h"
#import "FUSkinPlugin.h"
#import "FUShapePlugin.h"
#import "FUFilterPlugin.h"
#import "FUStickerPlugin.h"
#import "FUMakeupPlugin.h"
#import "FUBodyPlugin.h"
#import "FUDefines.h"
#import "FURenderKitManager.h"
#import <FURenderKit/FURenderKit.h>

@interface FaceunityPlugin ()

@property (nonatomic, strong) FUSkinPlugin *skinPlugin;
@property (nonatomic, strong) FUShapePlugin *shapePlugin;
@property (nonatomic, strong) FUFilterPlugin *filterPlugin;
@property (nonatomic, strong) FUStickerPlugin *stickerPlugin;
@property (nonatomic, strong) FUMakeupPlugin *makeupPlugin;
@property (nonatomic, strong) FUBodyPlugin *bodyPlugin;

@end

@implementation FaceunityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"faceunity_plugin"
            binaryMessenger:[registrar messenger]];
  FaceunityPlugin* instance = [[FaceunityPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   if ([call.arguments isKindOfClass:[NSDictionary class]]) {
       NSObject *target;
      if (!call.arguments[@"module"]) {
          // 未指定特效模块，分发到 FURenderKitManager 单例
          target = [FURenderKitManager sharedManager];
      } else {
          // 分发到特效模块
          FUModuleType moduleType = [call.arguments[@"module"] integerValue];
          switch (moduleType) {
              case FUModuleTypeBeautySkin:{
                  target = self.skinPlugin;
              }
                  break;
              case FUModuleTypeBeautyShape:{
                  target = self.shapePlugin;
              }
                  break;
              case FUModuleTypeBeautyFilter:{
                  target = self.filterPlugin;
              }
                  break;
              case FUModuleTypeSticker:{
                  target = self.stickerPlugin;
              }
                  break;
              case FUModuleTypeMakeup:{
                  target = self.makeupPlugin;
              }
                  break;
              case FUModuleTypeBody:{
                  target = self.bodyPlugin;
              }
              default:
                  break;
           }
      }
      SEL selector;
      if (call.arguments[@"arguments"]) {
          // 需要设置传参
          NSArray *argumentArray = call.arguments[@"arguments"];
          NSString *selectorString = [NSString stringWithFormat:@"%@:", call.method];
          if (argumentArray.count > 1) {
              // 超过一个参数
              for (NSInteger i = 1; i < argumentArray.count; i++) {
                  NSDictionary *argument = argumentArray[i];
                  selectorString = [selectorString stringByAppendingString:[NSString stringWithFormat:@"%@:", argument.allKeys.firstObject]];
              }
          }
          selector = NSSelectorFromString(selectorString);
      } else {
          selector = NSSelectorFromString(call.method);
      }
       NSArray *arguments = call.arguments[@"arguments"] ? call.arguments[@"arguments"] : nil;
       [self invokeWithSelector:selector target:target arguments:arguments result:result];
  } else {
      // 其他方法直接分发到 FURenderKitManager 单例
      [self invokeWithSelector:NSSelectorFromString(call.method) target:[FURenderKitManager sharedManager] arguments:nil result:result];
  }
}

- (void)invokeWithSelector:(SEL)selector target:(NSObject *)target arguments:(nullable NSArray *)arguments result:(FlutterResult)result  {
    if (![target respondsToSelector:selector]) {
        NSLog(@"%@ can not respondsToSelector:%@", target, NSStringFromSelector(selector));
        result(FlutterMethodNotImplemented);
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    // 设置 argument
    if (arguments.count > 0) {
        for (NSInteger i = 0; i < arguments.count; i++) {
            NSDictionary *argument = arguments[i];
            id key = argument.allValues.firstObject;
            [invocation setArgument:&key atIndex:2+i];
        }
    }
    [invocation invoke];
    
    //返回值一定要是对象类型，基本类型 int, float ,double 等需要封装成NSNumber，id是对象，在堆里面，基本数据类型在字符常量区，需要用一个指针指向。
    id __unsafe_unretained returnValue = nil;
    if (signature.methodReturnLength != 0) {
        [invocation getReturnValue:&returnValue];
        result(returnValue);
    }
}

- (FUSkinPlugin *)skinPlugin {
    if (!_skinPlugin) {
        _skinPlugin = [[FUSkinPlugin alloc] init];
    }
    return _skinPlugin;
}

- (FUShapePlugin *)shapePlugin {
    if (!_shapePlugin) {
        _shapePlugin = [[FUShapePlugin alloc] init];
    }
    return _shapePlugin;
}

- (FUFilterPlugin *)filterPlugin {
    if (!_filterPlugin) {
        _filterPlugin = [[FUFilterPlugin alloc] init];
    }
    return _filterPlugin;
}

- (FUStickerPlugin *)stickerPlugin {
    if (!_stickerPlugin) {
        _stickerPlugin = [[FUStickerPlugin alloc] init];
    }
    return _stickerPlugin;
}

- (FUMakeupPlugin *)makeupPlugin {
    if (!_makeupPlugin) {
        _makeupPlugin = [[FUMakeupPlugin alloc] init];
    }
    return _makeupPlugin;
}

- (FUBodyPlugin *)bodyPlugin {
    if (!_bodyPlugin) {
        _bodyPlugin = [[FUBodyPlugin alloc] init];
    }
    return _bodyPlugin;
}

@end
 
