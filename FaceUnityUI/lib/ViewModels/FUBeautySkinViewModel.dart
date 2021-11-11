import 'package:faceunity_plugin/FUBeautyPlugin.dart';
import 'package:faceunity_ui/Tools/FUImageTool.dart';
import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/FUBeautyDefine.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';

class FUBeautySkinViewModel extends BaseViewModel {
  FUBeautySkinViewModel(FaceUnityModel dataModel) : super(dataModel) {
    List<BaseModel> uiList = [];
    List<String> titles = [
      "精细磨皮",
      "美白",
      "红润",
      "锐化",
      "亮眼",
      "美牙",
      "去黑眼圈",
      "去法令纹"
    ];
    String commonPre =
        FUImageTool.getImagePathWithRelativePathPre("Asserts/beauty/skin/");
    List<String> imagePaths = List.generate(titles.length, (index) {
      String title = titles[index];
      return commonPre + title;
    });
    List<double> values = [4.2, 0.3, 0.3, 0.2, 0.0, 0.0, 0.0, 0.0];
    List<double> ratio = [6.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
    for (var i = 0; i < FUBeautifySkin.FUBeautifySkinMax.index; i++) {
      BaseModel model = BaseModel(imagePaths[i], titles[i], values[i]);
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
  dealloc() {}
}
