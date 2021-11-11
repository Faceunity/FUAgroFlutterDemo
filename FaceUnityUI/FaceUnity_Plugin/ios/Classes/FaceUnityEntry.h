//
//  FaceUnityEntry.h
//  faceunity_plugin
//
//  Created by Chen on 2021/10/12.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 相芯模块中间件，桥梁形式存在，持有业务模型并且分发方法到具体的业务数据类里面.可以理解成业务插件的容器，否则Plugin 需要引入很多业务插件并且需要持有实例变量耦合度就高了
 */
@interface FaceUnityEntry : NSObject

+ (instancetype)shareInstance;

/**
 * 入口接口，原来应该写到OC 文件FaceunityPlugin。顺应潮流使用SwiftFaceunityPlugin 转一到，也是为了兼容后续第三方使用 类似的swiftPlugin。
 */
+ (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
