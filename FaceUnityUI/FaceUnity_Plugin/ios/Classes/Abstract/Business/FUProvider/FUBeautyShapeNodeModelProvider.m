//
//  FUBeautyShapeProducer.m
//  BeautifyExample
//
//  Created by Chen on 2021/4/25.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "FUBeautyShapeNodeModelProvider.h"
#import "FUBeautyDefine.h"
#import "FUBaseModel.h"
#import "FUManager.h"


@implementation FUBeautyShapeNodeModelProvider
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
    if ([FUManager shareManager].shapeParams && [FUManager shareManager].shapeParams.count > 0) {
        source = [FUManager shareManager].shapeParams;
    } else {
        NSString *path = [self loadPathWithBundleName:@"FaceUnity_Plugin" fileName:@"beauty_shape" ofType:@"json"];
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
//    [FUManager shareManager].shapeParams = [NSMutableArray arrayWithArray:self.dataSource];
}
@end
