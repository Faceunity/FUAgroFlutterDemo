//
//  FUMakeupPlugin.m
//  faceunity_plugin
//
//  Created by Chen on 2021/12/13.
//

#import "FUMakeupPlugin.h"
#import "FUMakeupViewModel.h"
#import "FUMakeupNodeModelProvider.h"
#import "FUFlutterPluginModelProtocol.h"
#import "FlutterBaseModel.h"
#import "FUMakeupModel.h"

@interface FlutterMakeupModel : FlutterBaseModel <FUFlutterPluginModelProtocol>
@property (nonatomic, assign) int index;//选中美妆的索引
@end

@implementation FlutterMakeupModel

@synthesize method, value;
@end

@interface FUMakeupPlugin ()
@property (nonatomic, strong) FUMakeupViewModel *viewModel;
@end

@implementation FUMakeupPlugin
- (void)config {
    _viewModel = [FUMakeupViewModel instanceViewModel];
    _viewModel.provider = [FUMakeupNodeModelProvider instanceProducer];
}

//FULiveModulePlugin 销毁plugin
- (void)dispose {    
    if ([self.delegate respondsToSelector:@selector(disposePluginWithKey:)]) {
        [self.delegate disposePluginWithKey:NSStringFromClass([self class])];
    }
}

//点击美妆
- (void)selectedItem:(NSDictionary *)params {
    FlutterMakeupModel *flutterModel = [FlutterMakeupModel analysis:params];
    [self.viewModel consumerWithDataIndex:flutterModel.index viewModelBlock:nil];
}


- (void)sliderValueChange:(NSDictionary *)params {
    FlutterMakeupModel *flutterModel = [FlutterMakeupModel analysis: params];
    int index = flutterModel.index;
    NSArray *dataSource = (NSArray *)self.viewModel.provider.dataSource;
    if (index < dataSource.count && index >=0 ) {
        FUMakeupModel *model = (FUMakeupModel *)dataSource[index];
        model.mValue = flutterModel.value;
        if (model.newMakeupFlag) {
            [self.viewModel setNewMakeupIntensity:[model.mValue doubleValue]];
        } else {
            [self.viewModel setMakeupIntensity:[model.mValue doubleValue]];
        }
    } else {
        NSLog(@"%@,%s: 数组越界",self,__func__);
    }
}


- (FUBaseViewModel *)getPluginViewModel {
    return self.viewModel;
}

@end
