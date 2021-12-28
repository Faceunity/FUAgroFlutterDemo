import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:flutter/services.dart';

class FUStickerPlugin {
  static MethodChannel channel = FaceunityPlugin.channel;
  //贴纸
  static const String sticker = "sticker";

  ///native 初始化美颜
  static Future config() async {
    channel.invokeMethod(sticker, {
      "method": "config",
    });
  }

  ///销毁美颜插件
  static Future dispose() async {
    channel.invokeMethod(sticker, {
      "method": "dispose",
    });
  }

  ///index 选择贴纸的索引
  static Future selectedItem<T>(int index) async {
    channel.invokeMethod(sticker, {
      "method": "selectedItem",
      "index": index,
    });
  }
}
