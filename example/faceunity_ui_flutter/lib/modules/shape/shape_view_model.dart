import 'dart:convert';

import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:faceunity_plugin/shape_plugin.dart';
import 'package:faceunity_ui_flutter/modules/shape/shape_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/faceunity_defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShapeViewModel extends ChangeNotifier {
  ShapeViewModel() : super() {
    initialize();
  }

  late List<ShapeModel> shapes = [];
  // 设备是否高性能机型
  late bool highPerformanceDevice = true;

  int selectedIndex = -1;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= shapes.length) {
      return;
    }
    selectedIndex = index;
  }

  void setShapeIntensity(double intensity) {
    if (selectedIndex < 0 || selectedIndex >= shapes.length) {
      return;
    }
    shapes[selectedIndex].currentValue = intensity;
    setIntensity(intensity, shapes[selectedIndex].type);
  }

  void setIntensity(double intensity, BeautyShape type) {
    ShapePluin.setShapeIntensity(intensity, type.number);
  }

  void initialize() async {
    String jsonString = await rootBundle.loadString(CommonUtil.bundleFileNamed("shape/beauty_shape.json"));
    final jsonData = json.decode(jsonString);
    List<ShapeModel> shapeModels = [];
    for (Map<String, dynamic> item in jsonData) {
      ShapeModel shape = ShapeModel.fromJson(item);
      shapeModels.add(shape);
    }
    shapes = shapeModels;
    highPerformanceDevice = await FaceunityPlugin.isHighPerformanceDevice();
    recoverAllShapeValuesToDefault();
    notifyListeners();
  }

  bool get isDefaultValue {
    for (ShapeModel shape in shapes) {
      int currentIntValue = shape.defaultValueInMiddle ? (shape.currentValue * 100 - 50).toInt() : (shape.currentValue * 100).toInt();
      int defaultIntValue = shape.defaultValueInMiddle ? (shape.defaultValue * 100 - 50).toInt() : (shape.defaultValue * 100).toInt();
      if (currentIntValue != defaultIntValue) {
          return false;
      }
    }
    return true;
  }

  // 恢复所有美型值为默认
  void recoverAllShapeValuesToDefault() async {
    for (int i = 0; i < shapes.length; i++) {
      shapes[i].currentValue = shapes[i].defaultValue;
      setIntensity(shapes[i].currentValue, shapes[i].type);
    }
    notifyListeners();
  }
}