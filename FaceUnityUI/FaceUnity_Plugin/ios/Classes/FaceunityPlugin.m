#import "FaceunityPlugin.h"
#if __has_include(<faceunity_plugin/faceunity_plugin-Swift.h>)
#import <faceunity_plugin/faceunity_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "faceunity_plugin-Swift.h"
#endif

@implementation FaceunityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFaceunityPlugin registerWithRegistrar:registrar];
}
@end
