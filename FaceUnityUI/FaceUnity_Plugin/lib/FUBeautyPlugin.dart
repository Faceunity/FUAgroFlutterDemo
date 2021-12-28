import 'package:flutter/services.dart';
import 'package:faceunity_plugin/faceunity_plugin.dart';

class FUBeautyPlugin {
  static MethodChannel channel = FaceunityPlugin.channel;

  //美颜
  static const String beauty = "beauty";

  ///subBizType 具体子类型，瘦脸、窄脸这些
  /// 参数 method 是对应的美颜模块具体方法名称
  static Future selectedItem<T>(int subBizType) async {
    channel.invokeMethod(beauty, {
      "method": "selectedItem",
      "subBizType": subBizType,
    });
  }

  ///value 强度值
  ///strvalue 滤镜字符串值，非滤镜可以传空字符串
  ///subBizType 具体子类型，瘦脸、窄脸这些
  static Future sliderValueChange(
      int subBizType, double value, String strValue) async {
    channel.invokeMethod(beauty, {
      "method": "sliderValueChange",
      "subBizType": subBizType,
      "value": value,
      "strValue": strValue
    });
  }

  /// 滤镜slider
  ///value 强度值
  ///strvalue 滤镜字符串值，非滤镜可以传空字符串
  ///subBizType 具体子类型，瘦脸、窄脸这些
  static Future filterSliderValueChange(
      int subBizType, double value, String strValue) async {
    channel.invokeMethod(beauty, {
      "method": "filterSliderValueChange",
      "subBizType": subBizType,
      "value": value,
      "strValue": strValue
    });
  }

  ///native 初始化美颜
  static Future config() async {
    channel.invokeMethod(beauty, {
      "method": "config",
    });
  }

  ///销毁美颜插件
  static Future dispose() async {
    channel.invokeMethod(beauty, {
      "method": "dispose",
    });
  }

  ///widget 重置美颜某个业务的效果
  static Future resetDefault(int bizType) async {
    channel
        .invokeMethod(beauty, {"method": "resetDefault", "bizType": bizType});
  }
}
