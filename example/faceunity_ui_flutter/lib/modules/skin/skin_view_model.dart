import 'dart:convert';
import 'dart:io';

import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:faceunity_plugin/skin_plugin.dart';
import 'package:faceunity_ui_flutter/modules/skin/skin_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/faceunity_defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SkinViewModel extends ChangeNotifier {
  SkinViewModel() : super() {
    initialize();
  }

  late List<SkinModel> skins = [];
  // 设备是否高性能机型
  late int devicePerformanceLevel = DevicePerformanceLevel.levelTwo;
  late List<int> blackList = [];

  int selectedIndex = -1;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= skins.length) {
      return;
    }
    selectedIndex = index;
  }

  void setSkinIntensity(double intensity) {
    if (selectedIndex < 0 || selectedIndex >= skins.length) {
      return;
    }
    double current = intensity * skins[selectedIndex].ratio;
    skins[selectedIndex].currentValue = current;
    setIntensity(current, skins[selectedIndex].type);
  }

  void setIntensity(double intensity, BeautySkin type) {
    SkinPluin.setSkinIntensity(intensity, type.number);
  }

  void initialize() async {
    devicePerformanceLevel = await FaceunityPlugin.devicePerformanceLevel();
    if (Platform.isAndroid) {
      blackList = await FaceunityPlugin.restrictedSkinParams();
    }
    String fileName = devicePerformanceLevel == DevicePerformanceLevel.levelMinusOne ? "skin/beauty_skin_low.json" : "skin/beauty_skin.json";
    String jsonString = await rootBundle.loadString(CommonUtil.bundleFileNamed(fileName));
    final jsonData = json.decode(jsonString);
    List<SkinModel> skinModels = [];
    for (Map<String, dynamic> item in jsonData) {
      SkinModel skin = SkinModel.fromJson(item);
      skinModels.add(skin);
    }
    skins = skinModels;

    recoverAllSkinValuesToDefault();
    notifyListeners();
  }

  bool get isDefaultValue {
    for (SkinModel skin in skins) {
      int currentIntValue = skin.defaultValueInMiddle ? (skin.currentValue / skin.ratio * 100 - 50).toInt() : (skin.currentValue / skin.ratio * 100).toInt();
      int defaultIntValue = skin.defaultValueInMiddle ? (skin.defaultValue / skin.ratio * 100 - 50).toInt() : (skin.defaultValue / skin.ratio * 100).toInt();
      if (currentIntValue != defaultIntValue) {
          return false;
      }
      if (skin.extra != null) {
        if (skin.extra?.value != skin.extra?.defaultValue) {
          return false;
        }
      }
    }
    return true;
  }

  // 恢复所有美肤值为默认
  void recoverAllSkinValuesToDefault() async {
    for (int i = 0; i < skins.length; i++) {
      skins[i].currentValue = skins[i].defaultValue;
      setIntensity(skins[i].currentValue, skins[i].type);
      setSkinExtraToDefault(skins[i].extra);
    }
    notifyListeners();
  }

  void setSkinExtra(SkinExtraModel? extra) {
    if (extra == null) return;
    SkinPluin.setBeautyParam(extra.key, extra.value);
  }

  void setSkinExtraToDefault(SkinExtraModel? skinExtraModel) {
    if (skinExtraModel == null) return;
    skinExtraModel.value = skinExtraModel.defaultValue;
    SkinPluin.setBeautyParam(skinExtraModel.key, skinExtraModel.defaultValue);
  }

  bool isSupport(SkinModel skin) {
    if (blackList.contains(skin.type.number)) {
      return false;
    }
    return devicePerformanceLevel >= skin.supportDeviceLevel;
  }
}
