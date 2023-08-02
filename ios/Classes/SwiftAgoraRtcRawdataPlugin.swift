import Flutter
import UIKit
import FURenderKit

public class SwiftAgoraRtcRawdataPlugin: NSObject, FlutterPlugin, AgoraAudioFrameDelegate, AgoraVideoFrameDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "agora_rtc_rawdata", binaryMessenger: registrar.messenger())
        let instance = SwiftAgoraRtcRawdataPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var audioObserver: AgoraAudioFrameObserver?
    private var videoObserver: AgoraVideoFrameObserver?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "registerAudioFrameObserver":
            if audioObserver == nil {
                audioObserver = AgoraAudioFrameObserver(engineHandle: call.arguments as! UInt)
            }
            audioObserver?.delegate = self
            audioObserver?.register()
            result(nil)
        case "unregisterAudioFrameObserver":
            if audioObserver != nil {
                audioObserver?.delegate = nil
                audioObserver?.unregisterAudioFrameObserver()
                audioObserver = nil
            }
            result(nil)
        case "registerVideoFrameObserver":
            if videoObserver == nil {
                videoObserver = AgoraVideoFrameObserver(engineHandle: call.arguments as! UInt)
            }
            videoObserver?.delegate = self
            videoObserver?.register()
            result(nil)
        case "unregisterVideoFrameObserver":
            if videoObserver != nil {
                videoObserver?.delegate = nil
                videoObserver?.unregisterVideoFrameObserver()
                videoObserver = nil
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onRecord(_: AgoraAudioFrame) -> Bool {
        return true
    }

    public func onPlaybackAudioFrame(_: AgoraAudioFrame) -> Bool {
        return true
    }

    public func onMixedAudioFrame(_: AgoraAudioFrame) -> Bool {
        return true
    }

    public func onPlaybackAudioFrame(beforeMixing _: AgoraAudioFrame, uid _: UInt) -> Bool {
        return true
    }
    
    public func getVideoFormatPreference() -> AgoraVideoFrameType {
        return .YUV420
    }

    public func onCaptureVideoFrame(_ sourceType: Int32, frame videoFrame: AgoraVideoFrame) -> Bool {
//        memset(videoFrame.uBuffer, 0, Int(videoFrame.uStride * videoFrame.height) / 2)
//        memset(videoFrame.vBuffer, 0, Int(videoFrame.vStride * videoFrame.height) / 2)
        
        if(fuIsLibraryInit() > 0){
            let input = FURenderInput.init();
            if (videoFrame.type == .YUV420) {
                //默认图片内部的人脸始终是朝上，旋转屏幕也无需修改该属性。
                var inputOriginTation: FUImageOrientation = FUImageOrientationUP;
                
                switch videoFrame.rotation {
                case 0:
                    inputOriginTation = FUImageOrientationUP
                case 90:
                    inputOriginTation = FUImageOrientationLeft
                case 180:
                    inputOriginTation = FUImageOrientationDown
                case 270:
                    inputOriginTation = FUImageOrientationRight
                default:
                    inputOriginTation = FUImageOrientationLeft
                }
                input.renderConfig.imageOrientation = inputOriginTation;
                //开启重力感应，内部会自动计算正确方向，设置fuSetDefaultRotationMode，无须外面设置
                input.renderConfig.gravityEnable = true
                //如果来源相机捕获的图片一定要设置，否则将会导致内部检测异常
                input.renderConfig.isFromFrontCamera = true
                //该属性是指系统相机是否做了镜像: 一般情况前置摄像头出来的帧都是设置过镜像，所以默认需要设置下。如果相机属性未设置镜像，改属性不用设置。
                //实际测试发现图片帧没有镜像所以此属性设置false
                input.renderConfig.isFromMirroredCamera = false
                
                let pointY: UnsafeMutablePointer<UInt8> = transform(videoFrame.yBuffer)
                let pointU: UnsafeMutablePointer<UInt8> = transform(videoFrame.uBuffer)
                let pointV: UnsafeMutablePointer<UInt8> = transform(videoFrame.vBuffer)
                let imagebuffer = FUImageBufferMakeI420(pointY , pointU, pointV, Int(videoFrame.width),Int(videoFrame.height), Int(videoFrame.yStride), Int(videoFrame.uStride), Int(videoFrame.vStride))
                input.imageBuffer = imagebuffer;
                
                if ((FURenderKit.share().beauty == nil) || ((FURenderKit.share().beauty?.enable) == false)) {
                    
                } else {
                    if (FURenderKit.devicePerformanceLevel() == FUDevicePerformanceLevel.high) {
                        var score = FUAIKit.fuFaceProcessorGetConfidenceScore(0)
                        if (score > 0.95) {
                            FURenderKit.share().beauty?.blurType = 3;
                            FURenderKit.share().beauty?.blurUseMask = true;
                        } else {
                            FURenderKit.share().beauty?.blurType = 2;
                            FURenderKit.share().beauty?.blurUseMask = false;
                        }
                    } else {
                        FURenderKit.share().beauty?.blurType = 2;
                        FURenderKit.share().beauty?.blurUseMask = false;
                    }
                }
                FURenderKit.share().render(with: input)
            }
            
        }
        return true
    }

    public func onRenderVideoFrame(_ videoFrame: AgoraVideoFrame, uid _: UInt) -> Bool {
//        memset(videoFrame.uBuffer, 255, Int(videoFrame.uStride * videoFrame.height) / 2)
//        memset(videoFrame.vBuffer, 255, Int(videoFrame.vStride * videoFrame.height) / 2)
        return true
    }
    
    private func transform(_ buffer: UnsafeMutableRawPointer) -> UnsafeMutablePointer<UInt8> {
        let point: UnsafeMutableRawPointer = buffer
        let opaquePtr = OpaquePointer(point)
        let baseAddress = UnsafeMutablePointer<UInt8>(opaquePtr)
        return baseAddress
    }
    
    private func untransform(_ byte:UnsafeMutablePointer<UInt8>) -> UnsafeMutableRawPointer {
        let point: UnsafeMutablePointer<UInt8> = byte;
        let opaquePtr = OpaquePointer(point);
        let voidPoint = UnsafeMutableRawPointer(opaquePtr);
        
        return voidPoint
    }
}
