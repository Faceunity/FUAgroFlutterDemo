import 'package:faceunity_plugin/faceunity_plugin.dart';

class MakeupPluin {
  static const _channel = FaceunityPlugin.methodChannel;

  static const int moduleCode = 4;

  /// 选择美妆
  /// @param bundleName 美妆 bundle 名称
  /// @param isCombined 是否新的组合妆（嗲嗲兔、冻龄、国风、混血）
  static Future<void> selectMakeup(String bundleName, bool isCombined, double intensity) async {
    _channel.invokeMethod("selectMakeup", {"module" : moduleCode, "arguments" : [{"bundleName" : bundleName}, {"isCombined" : isCombined}, {"intensity" : intensity}]});
  }

  // 设置妆容程度值
  static Future<void> setMakeupIntensity(double intensity) async {
    _channel.invokeMethod("setMakeupIntensity", {"module" : moduleCode, "arguments" : [{"intensity" : intensity}]});
  }

  // 移除当前美妆，释放内存
  static Future<void> removeMakeup() async {
    _channel.invokeMethod("removeMakeup", {"module" : moduleCode});
  }
}