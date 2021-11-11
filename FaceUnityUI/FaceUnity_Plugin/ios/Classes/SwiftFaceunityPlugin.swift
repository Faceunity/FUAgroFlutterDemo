import Flutter
import UIKit

public class SwiftFaceunityPlugin: NSObject, FlutterPlugin {
    private static var channel: FaceUnityEntry?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "faceunity_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFaceunityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.isEqual("getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        } else {
            FaceUnityEntry.handle(call, result: result);
        }
        
    }
}
