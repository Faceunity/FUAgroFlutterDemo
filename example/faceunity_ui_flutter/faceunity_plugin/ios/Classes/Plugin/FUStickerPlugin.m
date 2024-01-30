//
//  FUStickerPlugin.m
//  faceunity_plugin
//
//  Created by 项林平 on 2023/10/27.
//

#import "FUStickerPlugin.h"
#import "FUUtil.h"
#import "FURenderKitManager.h"
#import <FURenderKit/FURenderKit.h>

@interface FUStickerPlugin ()

@property (nonatomic, strong) FUSticker *currentSticker;

@end

@implementation FUStickerPlugin

- (void)selectSticker:(NSString *)name {
    NSString *path = [FUUtil pluginBundlePathWithName:name];
    FUSticker *sticker = [FUSticker itemWithPath:path name:name];
    sticker.enable = [FURenderKitManager sharedManager].isEffectsOn;
    if (self.currentSticker) {
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentSticker withSticker:sticker completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer addSticker:sticker completion:nil];
    }
    self.currentSticker = sticker;
}

- (void)removeSticker {
    if (self.currentSticker) {
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
        self.currentSticker = nil;
    }
}

@end
