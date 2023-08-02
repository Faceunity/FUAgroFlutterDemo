//
//  FUTestRecorder.h
//  FUTester
//
//  Created by 刘洋 on 2017/10/26.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FUTestRecorder : NSObject


+ (FUTestRecorder *)shareRecorder;

/**
 * 测试整体一帧的数据，
 */
-(void)processFrameWithLog;

/**
 * 统计接口耗时开始
 */
- (void)processFrameStart;

/**
 * 统计接口耗时结束
 */
- (void)processFrameEnd;

/**
 * 创建接口耗时文件
 */
- (void)setupRecordInterVal;

- (void)setupRecord;

@end
