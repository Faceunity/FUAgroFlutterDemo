//
//  ZGCaptureDeviceCamera.h
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/12.
//  Copyright © 2020 Zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGCaptureDeviceProtocol.h"
#import <ZegoExpressEngine/ZegoExpressEventHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGCaptureDeviceCamera : NSObject <ZGCaptureDevice, ZegoCustomVideoRenderHandler>

@property (nonatomic, weak) id<ZGCaptureDeviceDataOutputPixelBufferDelegate> delegate;

- (instancetype)initWithPixelFormatType:(OSType)pixelFormatType;


@end

NS_ASSUME_NONNULL_END
