//
//  AgoraVideoFrameObserver.mm
//  react-native-agora-rawdata
//
//  Created by LXH on 2020/11/10.
//

#import "AgoraVideoFrameObserver.h"

#import <AgoraRtcKit/IAgoraMediaEngine.h>
#import <AgoraRtcKit/IAgoraRtcEngine.h>


namespace agora {
class VideoFrameObserver : public media::IVideoFrameObserver {
public:
  VideoFrameObserver(long long engineHandle, void *observer)
      : engineHandle(engineHandle), observer(observer) {
    auto rtcEngine = reinterpret_cast<rtc::IRtcEngine *>(engineHandle);
    if (rtcEngine) {
      util::AutoPtr<media::IMediaEngine> mediaEngine;
      mediaEngine.queryInterface(rtcEngine, AGORA_IID_MEDIA_ENGINE);
      if (mediaEngine) {
        mediaEngine->registerVideoFrameObserver(this);
      }
    }
  }

  virtual ~VideoFrameObserver() {
    auto rtcEngine = reinterpret_cast<rtc::IRtcEngine *>(engineHandle);
    if (rtcEngine) {
      util::AutoPtr<media::IMediaEngine> mediaEngine;
      mediaEngine.queryInterface(rtcEngine, AGORA_IID_MEDIA_ENGINE);
      if (mediaEngine) {
        mediaEngine->registerVideoFrameObserver(nullptr);
      }
    }
  }

public:
  bool onCaptureVideoFrame(VideoFrame &videoFrame) override {
    @autoreleasepool {
      AgoraVideoFrame *videoFrameApple = NativeToAppleVideoFrame(videoFrame);

      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(onCaptureVideoFrame:)]) {
          bool result = [observerApple.delegate onCaptureVideoFrame:videoFrameApple];
          modifiedVideoFrameWithNewVideoRawData(videoFrame, videoFrameApple);
          return result;
      }
    }
    return true;
  }

  bool onRenderVideoFrame(unsigned int uid, VideoFrame &videoFrame) override {
    @autoreleasepool {
      AgoraVideoFrame *videoFrameApple = NativeToAppleVideoFrame(videoFrame);
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(onRenderVideoFrame:uid:)]) {
        bool result = [observerApple.delegate onRenderVideoFrame:videoFrameApple
                                                             uid:uid];
          modifiedVideoFrameWithNewVideoRawData(videoFrame, videoFrameApple);
        return result;
      }
    }
    return true;
  }
    

  bool onPreEncodeVideoFrame(VideoFrame &videoFrame) override {
    @autoreleasepool {
      AgoraVideoFrame *videoFrameApple = NativeToAppleVideoFrame(videoFrame);

      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(onPreEncodeVideoFrame:)]) {
        return [observerApple.delegate onPreEncodeVideoFrame:videoFrameApple];
      }
    }
    return IVideoFrameObserver::onPreEncodeVideoFrame(videoFrame);
  }

  VIDEO_FRAME_TYPE getVideoFormatPreference() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(getVideoFormatPreference)]) {
        return (
            VIDEO_FRAME_TYPE)[observerApple.delegate getVideoFormatPreference];
      }
    }
    return IVideoFrameObserver::getVideoFormatPreference();
  }

  bool getRotationApplied() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(getRotationApplied)]) {
        return [observerApple.delegate getRotationApplied];
      }
    }
    return IVideoFrameObserver::getRotationApplied();
  }

  bool getMirrorApplied() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(getMirrorApplied)]) {
        return [observerApple.delegate getMirrorApplied];
      }
    }
    return IVideoFrameObserver::getMirrorApplied();
  }

  bool getSmoothRenderingEnabled() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(getSmoothRenderingEnabled)]) {
        return [observerApple.delegate getSmoothRenderingEnabled];
      }
    }
    return IVideoFrameObserver::getSmoothRenderingEnabled();
  }

  uint32_t getObservedFramePosition() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(getObservedFramePosition)]) {
        return [observerApple.delegate getObservedFramePosition];
      }
    }
    return IVideoFrameObserver::getObservedFramePosition();
  }

  bool isMultipleChannelFrameWanted() override {
    @autoreleasepool {
      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate
              respondsToSelector:@selector(isMultipleChannelFrameWanted)]) {
        return [observerApple.delegate isMultipleChannelFrameWanted];
      }
    }
    return IVideoFrameObserver::isMultipleChannelFrameWanted();
  }

  bool onRenderVideoFrameEx(const char *channelId, unsigned int uid,
                            VideoFrame &videoFrame) override {
    @autoreleasepool {
      AgoraVideoFrame *videoFrameApple = NativeToAppleVideoFrame(videoFrame);
      NSString *channelIdApple = [NSString stringWithUTF8String:channelId];

      AgoraVideoFrameObserver *observerApple =
          (__bridge AgoraVideoFrameObserver *)observer;
      if (observerApple.delegate != nil &&
          [observerApple.delegate respondsToSelector:@selector
                                  (onRenderVideoFrameEx:channelId:uid:)]) {
        return [observerApple.delegate onRenderVideoFrameEx:videoFrameApple
                                                  channelId:channelIdApple
                                                        uid:uid];
      }
    }
    return IVideoFrameObserver::onRenderVideoFrameEx(channelId, uid,
                                                     videoFrame);
  }
    
//  //??????????????????
//  void renderWithInput(VideoFrame &videoFrame)  {
//      @autoreleasepool {
//          FURenderInput *input = [[FURenderInput alloc] init];
//          if (videoFrame.type == FRAME_TYPE_YUV420) {
//              //????????????????????????????????????????????????????????????????????????????????????
//              input.renderConfig.imageOrientation = FUImageOrientationUP;
//              //???????????????????????????????????????????????????????????????fuSetDefaultRotationMode?????????????????????
//              input.renderConfig.gravityEnable = YES;
//              //???????????????????????????????????????????????????????????????????????????????????????
//              input.renderConfig.isFromFrontCamera = YES;
//              //?????????????????????????????????????????????: ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
//              input.renderConfig.isFromMirroredCamera = YES;
////              I420(videoFrame.yBuffer, videoFrame.uBuffer, videoFrame.vBuffer, videoFrame.width, videoFrame.height, videoFrame.yStride, videoFrame.uStride, videoFrame.vStride);
//              FUImageBuffer imagebuffer = FUImageBufferMakeI420((Byte *)videoFrame.yBuffer, (Byte *)videoFrame.uBuffer, (Byte *)videoFrame.vBuffer, (size_t)videoFrame.width,(size_t)videoFrame.height, (size_t)videoFrame.yStride, (size_t)videoFrame.uStride, (size_t)(size_t)videoFrame.vStride);
//              input.imageBuffer = imagebuffer;
//              FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
//
//              videoFrame.yBuffer = (void *)output.imageBuffer.buffer0;
//              videoFrame.yStride = (int)output.imageBuffer.stride0;
//              videoFrame.uBuffer = (void *)output.imageBuffer.buffer1;
//              videoFrame.uStride = (int)output.imageBuffer.stride1;
//              videoFrame.vBuffer = (void *)output.imageBuffer.buffer2;
//              videoFrame.vStride = (int)output.imageBuffer.stride2;
//              videoFrame.width = (int)output.imageBuffer.size.width;
//              videoFrame.height = (int)output.imageBuffer.size.height;
//          }
//      }
//
//  }

private:
  AgoraVideoFrame *NativeToAppleVideoFrame(VideoFrame &videoFrame) {
    AgoraVideoFrame *videoFrameApple = [[AgoraVideoFrame alloc] init];
    videoFrameApple.type = (AgoraVideoFrameType)videoFrame.type;
    videoFrameApple.width = videoFrame.width;
    videoFrameApple.height = videoFrame.height;
    videoFrameApple.yStride = videoFrame.yStride;
    videoFrameApple.uStride = videoFrame.uStride;
    videoFrameApple.vStride = videoFrame.vStride;
    videoFrameApple.yBuffer = videoFrame.yBuffer;
    videoFrameApple.uBuffer = videoFrame.uBuffer;
    videoFrameApple.vBuffer = videoFrame.vBuffer;
    videoFrameApple.rotation = videoFrame.rotation;
    videoFrameApple.renderTimeMs = videoFrame.renderTimeMs;
    videoFrameApple.avsync_type = videoFrame.avsync_type;
    return videoFrameApple;
  }
    
    
    void modifiedVideoFrameWithNewVideoRawData(VideoFrame& videoFrame, AgoraVideoFrame *videoRawData) {
        videoFrame.width = videoRawData.width;
        videoFrame.height = videoRawData.height;
        videoFrame.yStride = videoRawData.yStride;
        videoFrame.uStride = videoRawData.uStride;
        videoFrame.vStride = videoRawData.vStride;
        videoFrame.rotation = videoRawData.rotation;
//        videoFrame.yBuffer = videoRawData.yBuffer;
//        videoFrame.uBuffer = videoRawData.uBuffer;
//        videoFrame.vBuffer = videoRawData.vBuffer;
        videoFrame.renderTimeMs = videoRawData.renderTimeMs;
    }

private:
  void *observer;
  long long engineHandle;
};
}

@interface AgoraVideoFrameObserver ()
@property(nonatomic) agora::VideoFrameObserver *observer;
@end

@implementation AgoraVideoFrameObserver
- (instancetype)initWithEngineHandle:(NSUInteger)engineHandle {
  if (self = [super init]) {
    self.engineHandle = engineHandle;
  }
  return self;
}

- (void)registerVideoFrameObserver {
  if (!_observer) {
    _observer =
        new agora::VideoFrameObserver(_engineHandle, (__bridge void *)self);
  }
}

- (void)unregisterVideoFrameObserver {
  if (_observer) {
    delete _observer;
    _observer = nullptr;
  }
}
@end
