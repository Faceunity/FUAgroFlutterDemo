//
//  FUFilterPlugin.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/1.
//

#import "FUFilterPlugin.h"

#import <FURenderKit/FURenderKit.h>

@interface FUFilterPlugin ()

@end

@implementation FUFilterPlugin

- (void)selectFilter:(NSString *)key {
    if (![FURenderKit shareRenderKit].beauty) {
        FUBeauty *beauty = [FUBeauty itemWithPath:[[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"] name:@"face_beautification"];
        [FURenderKit shareRenderKit].beauty = beauty;
    }
    [FURenderKit shareRenderKit].beauty.filterName = key;
}

- (void)setFilterLevel:(NSNumber *)level {
    if (![FURenderKit shareRenderKit].beauty) {
        return;
    }
    [FURenderKit shareRenderKit].beauty.filterLevel = level.doubleValue;
}

@end
