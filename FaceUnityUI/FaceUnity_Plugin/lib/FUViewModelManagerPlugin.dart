import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:flutter/services.dart';

//Flutter 和native 基本数据协议
// dynamic  value; //可以是字符串，NSNumber，数组，字典等。具体类型由Flutter 开发和native 开发制定
// String method 用于native 定义接受参数的方法名
// optional id channel 对应具体的通道实例，不是必须一般可以忽略
// 其余的新增字段 需要native 和Flutter 开发共同商量制定。
class FUViewModelManagerPlugin {
  static MethodChannel channel = FaceunityPlugin.channel;
  static const String viewModelManagerPlugin = "viewModelManagerPlugin";

  //init
  static Future config() async {
    channel.invokeMethod(viewModelManagerPlugin, {"method": "config"});
  }

  //dispose
  static Future dispose() async {
    channel.invokeMethod(viewModelManagerPlugin, {"method": "dispose"});
  }

  //int 标识当天的type类型：美颜、美体、美妆等，具体在native 侧参考native侧枚举
//   typedef NS_ENUM(NSUInteger, FUDataType) {
//     FUDataTypeBeauty         = 0,
//     FUDataTypeSticker,
//     FUDataTypeMakeup,
//     FUDataTypebody
// };
// bizType: 额外新增字协议段, 用来区分当前开关控制的是哪个业务(美颜、美体、美妆等)
  static Future switchOn(bool isOn, int bizType) async {
    channel.invokeMethod(viewModelManagerPlugin,
        {"method": "switchOn", "value": isOn, "bizType": bizType});
  }

  //对应的业务添加到渲染循环
  static Future addViewModelToRunLoop(int bizType) async {
    channel.invokeMethod(viewModelManagerPlugin,
        {"method": "addViewModelToRunLoop", "bizType": bizType});
  }

  //对应的业务从渲染循环移除
  static Future removeViewModelFromRunLoop(int bizType) async {
    channel.invokeMethod(viewModelManagerPlugin,
        {"method": "removeViewModelFromRunLoop", "bizType": bizType});
  }

  ///选中底部业务
  ///上层业务层已经处理掉了映射关系
  ///由于实际业务 美型、美肤、滤镜 是一个整体：美颜，所以索引需要一层映射处理，即美型、美肤、滤镜对应的index = 0
  ///其余的索引 依次 index = index - 2
  static Future compatibleClickBeautyItem(int index) async {
    channel.invokeMethod(viewModelManagerPlugin,
        {"method": "compatibleClickBeautyItem", "value": index});
  }

  ///开启模块流式监听，每帧获取 debug信息和检测人脸信息, 数据以json 格式返回{"debug": "debug内容", "hasFace": bool}
  static Future startBeautyStreamListen() async {
    channel.invokeMethod(viewModelManagerPlugin, {
      "method": "startBeautyStreamListen",
    });
  }

  static Future<int> getPerformanceLevel() async {
    final int ret = await channel.invokeMethod(viewModelManagerPlugin, {
      "method": "getPerformanceLevel",
    });
    return ret;
  }
}
