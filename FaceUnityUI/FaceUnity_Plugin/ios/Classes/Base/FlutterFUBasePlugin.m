//
//  FLutterFUBasePlugin.m
//  FlutterPluginRegistrant
//
//  Created by Chen on 2021/8/19.
//

#import "FlutterFUBasePlugin.h"

@interface FlutterFUBasePlugin ()

@end


@implementation FlutterFUBasePlugin
//暴露viewModel,容器类插件需要添加和移除非容器类插件
- (FUBaseViewModel *)getPluginViewModel {
    NSAssert(YES, @"子类必须重写");
    return nil;
}
@end
