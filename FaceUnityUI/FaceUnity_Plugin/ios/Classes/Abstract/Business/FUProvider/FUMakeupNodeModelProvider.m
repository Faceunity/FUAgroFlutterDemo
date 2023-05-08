//
//  FUMakeUpProducer.m
//  BeautifyExample
//
//  Created by Chen on 2021/4/25.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "FUMakeupNodeModelProvider.h"
#import "FUMakeupModel.h"

@implementation FUMakeupNodeModelProvider
@synthesize dataSource = _dataSource;
- (id)dataSource {
    if (!_dataSource) {
        _dataSource = [self producerDataSource];
    }
    return _dataSource;
}

- (NSArray *)producerDataSource {
    NSArray *prams = @[@"makeup_noitem",@"diadiatu",@"dongling",@"guofeng",@"hunxue",@"jianling",@"nuandong"];
    NSArray *newVersion = @[@(NO),@(YES),@(YES),@(YES),@(YES),@(NO),@(NO)];
    NSMutableArray *source = [NSMutableArray arrayWithCapacity:prams.count];
    for (NSUInteger i = 0; i < prams.count; i ++) {
        NSString *str = [prams objectAtIndex:i];
        FUMakeupModel *model = [[FUMakeupModel alloc] init];
        model.imageName = str;
        model.newMakeupFlag = [newVersion[i] boolValue];
        model.indexPath = [NSIndexPath indexPathForRow:i inSection:FUDataTypeMakeup];
        if (i == 0) {
            model.mValue = @0.0;
        } else {
            model.mValue = @0.7;
        }
        [source addObject:model];
    }
    return [NSArray arrayWithArray:source];
}
@end
