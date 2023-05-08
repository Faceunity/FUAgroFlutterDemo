import 'dart:io';

import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Tools/FUDataDefine.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';
import 'package:flutter/material.dart';

class FUImageTool {
  ///pathPre：不包含图片名称的图片前缀路径，ex:resource/images/beauty/skin
  static String getImagePathWithRelativePathPre(String pathPre) {
    String imagePath = pathPre;
    //处理 '/'问题
    if (!imagePath.endsWith('/')) {
      imagePath = imagePath + '/';
    }
    if (Platform.isIOS) {
      ///在设备像素比率为1.8的设备上，.../2.0x/my_icon.png 将被选择。对于2.7的设备像素比率，.../3.0x/my_icon.png将被选择。
      /// iphone 上面不是这个规则，以 逻辑点距和像素点之间关系来决定几倍图 例如iphone 屏幕像素比和点距比例例为 1.78, 但是用的2x图片来显示，所以需要区分平台来加载，这里iOS 统一用高分别率图片。不区分了
      if (!imagePath.contains("3.0x")) {
        imagePath = imagePath + '3.0x/';
      }
    } else if (Platform.isAndroid) {
      if (!imagePath.contains("3.0x")) {
        imagePath = imagePath + '3.0x/';
      }
    } else {
      imagePath = pathPre;
    }
    return imagePath;
  }

  //8.0 以后版本增加设备性能等级区分，
  static String selectedImageStateWithPerformanceLevel(int curIndex,
      BaseViewModel viewModel, FUDevicePerformanceLevel performanceLevel) {
    String imagePath = "";
    FUDataType bizType = viewModel.dataModel.bizType;
    BaseModel model = viewModel.dataModel.dataList[curIndex];
    if (bizType == FUDataType.FUDataTypeBeautyFilter) {
      imagePath = model.imagePath + '.png';
    } else if (bizType == FUDataType.FUDataTypeBeautySkin ||
        bizType == FUDataType.FUDataTypeBeautyShape) {
      bool opened = false;
      if (model.midSlider) {
        opened = (model.value - 0.5).abs() > 0.01 ? true : false;
      } else {
        opened = (model.value.abs() - 0) > 0.01 ? true : false;
      }

      //高低端机逻辑处理
      bool disable = false;
      if (model.differentiateDevicePerformance == true) {
        if (performanceLevel !=
            FUDevicePerformanceLevel.FUDevicePerformanceLevelHigh)
          disable = true;
      }

      if (disable) {
        imagePath = model.imagePath + '-0.png';
      } else {
        if (viewModel.selectedIndex == curIndex) {
          imagePath = opened == true
              ? model.imagePath + '-3.png'
              : model.imagePath + '-2.png';
        } else {
          imagePath = opened == true
              ? model.imagePath + '-1.png'
              : model.imagePath + '-0.png';
        }
      }
    } else {
      //后续业务添加对应的图片逻辑
      imagePath = model.imagePath + '.png';
    }
    return imagePath;
  }

  static AssetImage getAssertImage(String imagePath) {
    return AssetImage(imagePath, package: "faceunity_ui");
  }
}
