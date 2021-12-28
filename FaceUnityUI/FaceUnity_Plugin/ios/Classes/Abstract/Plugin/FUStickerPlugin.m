//
//  FUStickerPlugin.m
//  faceunity_plugin
//
//  Created by Chen on 2021/12/8.
//

#import "FUStickerPlugin.h"
#import "FUStickerViewModel.h"
#import "FUFlutterPluginModelProtocol.h"
#import "FlutterBaseModel.h"
#import "FUStickerNodeModelProvider.h"

@interface FlutterStickerModel : FlutterBaseModel <FUFlutterPluginModelProtocol>
@property (nonatomic, assign) int index;//选中的贴纸索引
@end

@implementation FlutterStickerModel

@synthesize method, value;
@end

@interface FUStickerPlugin ()
@property (nonatomic, strong) FUStickerViewModel *viewModel;
@end

@implementation FUStickerPlugin
- (void)config {
    _viewModel = [FUStickerViewModel instanceViewModel];
    _viewModel.provider = [FUStickerNodeModelProvider instanceProducer];
}

//FULiveModulePlugin 销毁plugin
- (void)dispose {
    if ([self.delegate respondsToSelector:@selector(disposePluginWithKey:)]) {
        [self.delegate disposePluginWithKey:NSStringFromClass([self class])];
    }
}


//点击贴纸
- (NSNumber *)selectedItem:(NSDictionary *)params {
    __block BOOL ret = NO;
    FlutterStickerModel *flutterModel = [FlutterStickerModel analysis:params];

    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.viewModel consumerWithDataIndex:flutterModel.index viewModelBlock:^(id  _Nullable param) {
            ret = YES;
            dispatch_semaphore_signal(sem);
        }];
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return @(ret);
}


- (FUBaseViewModel *)getPluginViewModel {
    return self.viewModel;
}
@end
