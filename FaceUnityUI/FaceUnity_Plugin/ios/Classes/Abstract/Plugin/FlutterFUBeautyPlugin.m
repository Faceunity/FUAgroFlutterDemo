//
//  FlutterFUBeautyPlugin.m
//  fulive_plugin
//
//  Created by Chen on 2021/7/30.
//

#import "FlutterFUBeautyPlugin.h"
#import <FURenderKit/FURenderKit.h>
#import "FUBeautyDefine.h"
#import "FUFlutterPluginModelProtocol.h"
#import "FlutterBaseModel.h"
#import "FUBeautyViewModel.h"
#import "FUBaseModel.h"

@interface FlutterBeautyModel : FlutterBaseModel <FUFlutterPluginModelProtocol>
//美型、美肤、滤镜
@property (nonatomic, copy) NSNumber *bizType;

@property (nonatomic, copy) NSNumber *subBizType;
@property (nonatomic, copy) NSString *strValue;
@end

@implementation FlutterBeautyModel

@synthesize method, value;
@end

@interface FlutterFUBeautyPlugin ()
@property (nonatomic, strong) FUBeautyViewModel *viewModel;

@end

@implementation FlutterFUBeautyPlugin

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)config {
    _viewModel = [FUBeautyViewModel instanceViewModel];
}

//FULiveModulePlugin 销毁plugin
- (void)dispose {
    if ([self.delegate respondsToSelector:@selector(disposePluginWithKey:)]) {
        [self.delegate disposePluginWithKey:NSStringFromClass([self class])];
    }
}


- (void)selectedItem:(NSDictionary *)params {
    FlutterBeautyModel *model = [FlutterBeautyModel analysis: params];
    if ([model.subBizType isKindOfClass:[NSNumber class]]) {
        int index = [model.subBizType intValue];
        [self.viewModel consumerWithDataIndex:index viewModelBlock:nil];
    } else {
        NSLog(@"selectedItem:参数类型错误");
    }

}


- (void)sliderValueChange:(NSDictionary *)params {
    FlutterBeautyModel *flutterModel = [FlutterBeautyModel analysis: params];
    if ([flutterModel.subBizType isKindOfClass:[NSNumber class]]) {
        int index = [flutterModel.subBizType intValue];
        NSArray *dataSource = (NSArray *)self.viewModel.provider.dataSource;
        if (index < dataSource.count) {
            FUBaseModel *model = dataSource[index];
            model.mValue = flutterModel.value;
            [self.viewModel consumerWithData:model viewModelBlock:nil];
        } else {
            NSLog(@"%@,%s: 数组越界",self,__func__);
        }
        [self.viewModel consumerWithDataIndex:index viewModelBlock:nil];
    } else {
        NSLog(@"selectedItem:参数类型错误");
    }
}


- (void)filterSliderValueChange:(NSDictionary *)params {
    FlutterBeautyModel *flutterModel = [FlutterBeautyModel analysis: params];
    if ([flutterModel.subBizType isKindOfClass:[NSNumber class]]) {
        int index = [flutterModel.subBizType intValue];
        NSArray *dataSource = (NSArray *)self.viewModel.provider.dataSource;
        if (index < dataSource.count) {
            FUBaseModel *model = dataSource[index];
            model.mValue = flutterModel.value;
            model.strValue = flutterModel.strValue;
            [self.viewModel consumerWithData:model viewModelBlock:nil];
        } else {
            NSLog(@"%@,%s: 数组越界",self,__func__);
        }
        
    } else {
        NSLog(@"selectedItem:参数类型错误");
    }
}

//美肤、美型重置参数
- (void)resetDefault:(NSDictionary *)params {
    FlutterBeautyModel *model = [FlutterBeautyModel analysis: params];
    if ([self.viewModel respondsToSelector:@selector(resetDefaultValue)]) {
        //协议方法，目前只有美颜容器类，美肤，美型 viewModel实现了。
        [self.viewModel resetDefaultValue];
    } else {
        NSLog(@"%@未实现协议方法",self.viewModel);
    }
}


- (FUBaseViewModel *)getPluginViewModel {
    return self.viewModel;
}
@end
