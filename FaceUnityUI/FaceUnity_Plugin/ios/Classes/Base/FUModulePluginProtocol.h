//
//  FUModulePluginProtocol.h
//  FlutterPluginRegistrant
//
//  Created by Chen on 2021/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUModulePluginProtocol <NSObject>
@optional
//Plugin销毁协议, 存储时候用的是类名字符串
- (void)disposePluginWithKey:(NSString *)key;
/**
 * 反向代理
 * 由于插件类之间设计之初就是一个个独立个体，但是插件之间会出现关联性，
 * 所以通过代理形式把 已经存在的插件导出给需要的类使用，而不是在其他插件内部直接 引用ZegoExpressEngineMethodHandler 单例，解耦
 */
- (NSDictionary * _Nullable)faceunityWithPluginContainer;
@end

NS_ASSUME_NONNULL_END
