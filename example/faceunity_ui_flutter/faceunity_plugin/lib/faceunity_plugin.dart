
import 'package:flutter/services.dart';

class FaceunityPlugin {
  static const methodChannel = MethodChannel('faceunity_plugin');
  
  static Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // 设备是否高端机型
  static Future<bool> isHighPerformanceDevice() async {
    final bool result = await methodChannel.invokeMethod("isHighPerformanceDevice");
    return result;
  }

  // 设备是否支持 NPU
  static Future<bool> isNPUSupported() async {
    final bool result = await methodChannel.invokeMethod("isNPUSupported");
    return result;
  }

  // 初始化 FURenderKit，包括 AI bundle 加载
  static Future<void> setupRenderKit() async {
    await methodChannel.invokeMethod("setupRenderKit");
  }

  // 销毁 FURenderKit
  static Future<void> destoryRenderKit() async {
    await methodChannel.invokeMethod("destoryRenderKit");
  }

  // 检查美颜是否已经加载，没有加载则需要在接口方法加载美颜
  static Future<void> checkIsBeautyLoaded() async {
    await methodChannel.invokeMethod("checkIsBeautyLoaded");
  }

  // 检查美体是否已经加载，没有加载则需要在接口方法加载美体
  static Future<void> checkIsBodyLoaded() async {
    await methodChannel.invokeMethod("checkIsBodyLoaded");
  }

  /// 加载美颜
  /// @note 两端插件初始化时已经加载了美颜，可以不用再加载美颜，卸妆后可以调用该方法重新加载
  static Future<void> loadBeauty() async {
    await methodChannel.invokeMethod("loadBeauty");
  }
  
  // 卸载美颜（释放内存）
  static Future<void> unloadBeauty() async {
    methodChannel.invokeMethod("unloadBeauty");
  }

  // 加载美体
  static Future<void> loadBody() async {
    await methodChannel.invokeMethod("loadBody");
  }
  
  // 卸载美体（释放内存）
  static Future<void> unloadBody() async {
    methodChannel.invokeMethod("unloadBody");
  }

  /// 关闭所有已经加载的特效（美颜、美妆、贴纸、美体）
  /// @note iOS插件只是把加载的特效对象的 enable 属性设置为 NO，并不卸载已经加载的特效对象
  static Future<void>  turnOffEffects() async {
    await methodChannel.invokeMethod("turnOffEffects");
  }

  /// 开启所有特效
  /// @note iOS插件只是把加载的特效对象的 enable 属性设置为 YES，并不重新加载特效对象
  static Future<void> turnOnEffects() async {
    await methodChannel.invokeMethod("turnOnEffects");
  }

  /// 设置最大人脸数量
  /// @param number 1-4
  static Future<void> setMaximumFacesNumber(int number) async {
    await methodChannel.invokeMethod("setMaximumFacesNumber", {"arguments" : [{"number" : number}]});
  }

}
