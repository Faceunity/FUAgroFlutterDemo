//
//  FUStickerPlugin.h
//  faceunity_plugin
//
//  Created by 项林平 on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerPlugin : NSObject

- (void)selectSticker:(NSString *)name;

- (void)removeSticker;

@end

NS_ASSUME_NONNULL_END
