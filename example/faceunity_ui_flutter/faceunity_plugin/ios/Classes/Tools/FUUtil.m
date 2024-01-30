//
//  FUUtil.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/10/27.
//

#import "FUUtil.h"

@implementation FUUtil

+ (NSString *)pluginBundlePathWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    NSURL *resourceURL = [bundle URLForResource:@"faceunity_plugin" withExtension:@"bundle"];
    return [NSBundle pathForResource:name ofType:@"bundle" inDirectory:resourceURL.path];
}

@end
