import 'package:faceunity_plugin/faceunity_plugin.dart';

class ShapePluin {
  static const _channel = FaceunityPlugin.methodChannel;

  static const int moduleCode = 1;

  /// 设置美型程度值
  /// @param intensity 程度值
  /// @param type 美肤类型(参考枚举 BeautyShape)
  static Future<void> setShapeIntensity(double intensity, int type) async {
    _channel.invokeMethod("setShapeIntensity", {"module" : moduleCode, "arguments" : [{"intensity" : intensity}, {"type" : type}]});
  }
}