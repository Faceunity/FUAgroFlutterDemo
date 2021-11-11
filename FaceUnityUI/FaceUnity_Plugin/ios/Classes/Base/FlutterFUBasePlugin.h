//
//  FLutterFUBasePlugin.h
//  FlutterPluginRegistrant
//
//  Created by Chen on 2021/8/19.
//

#import <Foundation/Foundation.h>
#import "FUModulePluginProtocol.h"

@class FUBaseViewModel;
NS_ASSUME_NONNULL_BEGIN

//plugin 抽象基类
@interface FlutterFUBasePlugin : NSObject <FUModulePluginProtocol>
@property (nonatomic, weak) id<FUModulePluginProtocol>delegate;

//暴露viewModel,容器类插件需要添加和移除非容器类插件
- (FUBaseViewModel *)getPluginViewModel;
@end

NS_ASSUME_NONNULL_END
