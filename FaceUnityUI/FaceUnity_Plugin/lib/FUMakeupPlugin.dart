import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:flutter/services.dart';

class FUMakeupPlugin {
  static MethodChannel channel = FaceunityPlugin.channel;
  //贴纸
  static const String makeup = "makeup";

  ///native 初始化美颜
  static Future config() async {
    channel.invokeMethod(makeup, {
      "method": "config",
    });
  }

  ///销毁美妆插件
  static Future dispose() async {
    channel.invokeMethod(makeup, {
      "method": "dispose",
    });
  }

  //index 选择美妆的索引
  static Future selectedItem<T>(int index) async {
    channel.invokeMethod(makeup, {
      "method": "selectedItem",
      "index": index,
    });
  }

  /// 美妆slider滑动
  /// index 美妆对应的索引
  /// value 强度值
  static Future sliderValueChange(int index, double value) async {
    channel.invokeMethod(makeup, {
      "method": "sliderValueChange",
      "index": index,
      "value": value,
    });
  }
}
