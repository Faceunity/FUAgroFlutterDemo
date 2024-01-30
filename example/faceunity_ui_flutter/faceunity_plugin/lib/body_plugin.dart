import 'package:faceunity_plugin/faceunity_plugin.dart';

class BodyPluin {
  static const _channel = FaceunityPlugin.methodChannel;

  static const int moduleCode = 5;

  /// 设置美体程度值
  /// @param intensity 程度值
  /// @param type 美体类型(参考枚举 BeautyBody)
  static Future<void> setBodyIntensity(double intensity, int type) async {
    _channel.invokeMethod("setBodyIntensity", {"module" : moduleCode, "arguments" : [{"intensity" : intensity}, {"type" : type}]});
  }
}