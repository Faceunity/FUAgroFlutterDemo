//
//  FUBeautySkinProducer.m
//  BeautifyExample
//
//  Created by Chen on 2021/4/25.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "FUBeautySkinNodeModelProvider.h"
#import "FUBeautyDefine.h"
#import "FUBaseModel.h"

#import "FUManager.h"


@implementation FUBeautySkinNodeModelProvider
@synthesize dataSource = _dataSource;
- (id)dataSource {
    if (!_dataSource) {
        _dataSource = [self producerDataSource];
    }
    return _dataSource;
}

//同步状态，本地数据组装
- (NSArray *)producerDataSource {
    NSMutableArray *source = [NSMutableArray array];
    if ([FUManager shareManager].skinParams && [FUManager shareManager].skinParams.count > 0) {
        source = [FUManager shareManager].skinParams;
    } else {
        NSString *path = [self loadPathWithBundleName:@"FaceUnity_Plugin" fileName:@"beauty_skin" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *dataList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in dataList) {
            FUBaseModel *model = [[FUBaseModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.indexPath = [NSIndexPath indexPathForRow:model.subType inSection:model.type];
            [source addObject:model];
        }
    }
    return [NSArray arrayWithArray: source];
}


- (void)cacheData {
//    [FUManager shareManager].skinParams = [NSMutableArray arrayWithArray:self.dataSource];
}

@end
