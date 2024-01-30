import 'package:faceunity_plugin/faceunity_plugin.dart';

class FilterPlugin {
  static const _channel = FaceunityPlugin.methodChannel;

  static const int moduleCode = 2;

  // 切换滤镜
  static Future<void>  selectFilter(String key) async {
    _channel.invokeMethod("selectFilter", {"module" : moduleCode, "arguments" : [{"key" : key}]});
  }

  // 设置滤镜值
  static Future<void> setFilterLevel(double level) async {
    _channel.invokeMethod("setFilterLevel", {"module" : moduleCode, "arguments" : [{"level" : level}]});
  }
}