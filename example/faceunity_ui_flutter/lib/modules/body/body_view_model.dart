import 'dart:convert';

import 'package:faceunity_plugin/body_plugin.dart';
import 'package:faceunity_ui_flutter/modules/body/body_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/faceunity_defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BodyViewModel extends ChangeNotifier {
  BodyViewModel() : super() {
    initialize();
  }
  
  late List<BodyModel> bodies = [];
  
  int selectedIndex = -1;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= bodies.length) {
      return;
    }
    selectedIndex = index;
  }

  void setBodyIntensity(double intensity) {
    if (selectedIndex < 0 || selectedIndex >= bodies.length) {
      return;
    }
    bodies[selectedIndex].currentValue = intensity;
    setIntensity(intensity, bodies[selectedIndex].type);
  }

  void setIntensity(double intensity, BeautyBody type) {
    BodyPluin.setBodyIntensity(intensity, type.number);
  }

  void initialize() async {
    String jsonString = await rootBundle.loadString(CommonUtil.bundleFileNamed("body/body.json"));
    final jsonData = json.decode(jsonString);
    List<BodyModel> bodyModels = [];
    for (Map<String, dynamic> item in jsonData) {
      BodyModel body = BodyModel.fromJson(item);
      bodyModels.add(body);
    }
    bodies = bodyModels;
    recoverAllBodyValuesToDefault();
    notifyListeners();
  }

  bool get isDefaultValue {
    for (BodyModel body in bodies) {
      int currentIntValue = body.defaultValueInMiddle ? (body.currentValue * 100 - 50).toInt() : (body.currentValue * 100).toInt();
      int defaultIntValue = body.defaultValueInMiddle ? (body.defaultValue * 100 - 50).toInt() : (body.defaultValue * 100).toInt();
      if (currentIntValue != defaultIntValue) {
          return false;
      }
    }
    return true;
  }

  // 恢复所有美体值为默认
  void recoverAllBodyValuesToDefault() async {
    for (int i = 0; i < bodies.length; i++) {
      bodies[i].currentValue = bodies[i].defaultValue;
      setIntensity(bodies[i].currentValue, bodies[i].type);
    }
    notifyListeners();
  }
}