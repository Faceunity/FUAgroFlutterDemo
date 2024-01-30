//
//  FUFilterPlugin.h
//  faceunity_plugin
//
//  Created by 项林平 on 2023/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUFilterPlugin : NSObject

- (void)selectFilter:(NSString *)key;

- (void)setFilterLevel:(NSNumber *)level;

@end

NS_ASSUME_NONNULL_END
