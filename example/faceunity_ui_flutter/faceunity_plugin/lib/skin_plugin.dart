import 'package:faceunity_plugin/faceunity_plugin.dart';

class SkinPluin {
  static const _channel = FaceunityPlugin.methodChannel;

  static const int moduleCode = 0;

  /// 设置美肤程度值
  /// @param intensity 程度值
  /// @param type 美肤类型(参考枚举 BeautySkin)
  static Future<void> setSkinIntensity(double intensity, int type) async {
    _channel.invokeMethod("setSkinIntensity", {"module" : moduleCode, "arguments" : [{"intensity" : intensity}, {"type" : type}]});
  }
}