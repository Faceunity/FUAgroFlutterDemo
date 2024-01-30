//
//  FUMakeupPlugin.h
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupPlugin : NSObject

- (void)selectMakeup:(NSString *)bundleName isCombined:(NSNumber *)isCombined intensity:(NSNumber *)intensity;

- (void)setMakeupIntensity:(NSNumber *)intensity;

- (void)removeMakeup;

@end

NS_ASSUME_NONNULL_END
