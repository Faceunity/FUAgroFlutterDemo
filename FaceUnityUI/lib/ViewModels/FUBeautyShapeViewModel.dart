import 'package:faceunity_plugin/FUBeautyPlugin.dart';
import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/ArrayExtension.dart';
import 'package:faceunity_ui/Tools/FUBeautyDefine.dart';

import 'package:faceunity_ui/Tools/FUImageTool.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';

import 'package:faceunity_ui/Tools/FUDataDefine.dart';

class FUBeautyShapeViewModel extends BaseViewModel {
  FUBeautyShapeViewModel(FaceUnityModel dataModel) : super(dataModel) {
    List<BaseModel> uiList = [];
    List<String> titles = [
      '瘦脸',
      'v脸',
      '窄脸',
      '短脸',
      '小脸',
      '瘦颧骨',
      '瘦下颌骨',
      '大眼',
      '圆眼',
      '下巴',
      '额头',
      '瘦鼻',
      '嘴型',
      '嘴唇厚度',
      '眼睛位置',
      '开眼角',
      '眼睑下至',
      '眼距',
      '眼睛角度',
      '长鼻',
      '缩人中',
      '微笑嘴角',
      '眉毛上下',
      '眉间距',
      '眉毛粗细'
    ];

    String commonPre =
        FUImageTool.getImagePathWithRelativePathPre("Asserts/beauty/shape/");
    List<String> imagePaths = List.generate(titles.length, (index) {
      String title = titles[index];
      return commonPre + title;
    });
    List<bool> midSlider = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      true,
      false,
      true,
      true,
      true,
      false,
      false,
      true,
      true,
      true,
      true,
      false,
      true,
      true,
      true
    ];
    List<double> values = [
      0,
      0.5,
      0,
      0,
      0,
      0,
      0,
      0.4,
      0.0,
      0.3,
      0.3,
      0.5,
      0.4,
      0.5,
      0.5,
      0,
      0,
      0.5,
      0.5,
      0.5,
      0.5,
      0,
      0.5,
      0.5,
      0.5
    ];
    List<double> ratio = [
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0
    ];
    List<bool> devicePerformance = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      true,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      true,
      true,
      true,
    ];
    for (var i = 0; i < FUBeautifyShape.FUBeautifyShapeMax.index; i++) {
      BaseModel model =
          BaseModel(imagePaths[i], titles[i], values[i], devicePerformance[i]);
      model.midSlider = midSlider[i];
      model.ratio = ratio[i];
      uiList.add(model);
    }
    this.dataModel.dataList = uiList;
    //默认选中的索引
    this.selectedIndex = -1;
  }

  @override
  bool showSlider() {
    if (selectedIndex == -1) {
      return false;
    }
    return checkPerforLevelVaild(selectedIndex);
  }

  @override
  void selectedItem(int index) {
    super.selectedItem(index);

    FUBeautyPlugin.selectedItem(index);
  }

  @override
  bool checkPerforLevelVaild(int index) {
    if (dataModel.dataList.inRange(index)) {
      var selectedModel = dataModel.dataList[index];
      //处理高低性能弹框逻辑
      if (selectedModel?.differentiateDevicePerformance == true) {
        if (performanceLevel !=
            FUDevicePerformanceLevel.FUDevicePerformanceLevelHigh) {
          return false;
        }
      }
    } else {
      print("$this index 越界");
    }
    return true;
  }

  @override
  //具体选中哪一个由子类决定
  void sliderValueChange(double value) {
    super.sliderValueChange(value);
    FUBeautyPlugin.sliderValueChange(
        selectedIndex, selectedModel != null ? selectedModel!.value : 0.0, "");
  }

  @override
  init() {}
  @override
  dealloc() {
    FUBeautyPlugin.dispose();
  }
}
