import 'package:faceunity_plugin/FUBeautyPlugin.dart';
import 'package:faceunity_ui/Tools/FUImageTool.dart';
import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';

class FUBeautyFilterViewModel extends BaseViewModel {
  FUBeautyFilterViewModel(FaceUnityModel dataModel) : super(dataModel) {
    List<BaseModel> uiList = [];
    Map<String, dynamic> titleAndImagePath = {
      "origin": "原图",
      "bailiang1": "白亮1",
      "fennen1": "粉嫩1",
      "lengsediao1": "冷色调1",
      "ziran1": "自然1",
      "zhiganhui1": "质感灰1",
    };
    List<String> titlesKey = [
      "origin",
      "ziran1",
      "zhiganhui1",
      "bailiang1",
      "fennen1",
      "lengsediao1",
    ];
    String commonPre =
        FUImageTool.getImagePathWithRelativePathPre("Asserts/beauty/filter/");
    List<String> imagePaths = List.generate(titlesKey.length, (index) {
      String title = titleAndImagePath[titlesKey[index]];
      return commonPre + title;
    });

    for (var i = 0; i < titlesKey.length; i++) {
      String titleKey = titlesKey[i];
      BaseModel model =
          BaseModel(imagePaths[i], titleAndImagePath[titleKey], 0.4, false);
      model.ratio = 1.0;
      model.strValue = titleKey;
      uiList.add(model);
    }
    this.dataModel.dataList = uiList;
    //默认选中的索引
    this.selectedIndex = 1;
    this.selectedModel = this.dataModel.dataList[this.selectedIndex];
  }

  @override
  bool showSlider() {
    if (selectedIndex < 1) {
      return false;
    }
    return true;
  }

  @override
  showBoard() {
    return true;
  }

  @override
  void selectedItem(int index) {
    super.selectedItem(index);
    //0 对应的就是美颜
    FUBeautyPlugin.selectedItem(index);
  }

  @override
  //具体选中哪一个由子类决定
  void sliderValueChange(double value) {
    super.sliderValueChange(value);
    FUBeautyPlugin.filterSliderValueChange(
        selectedIndex,
        selectedModel != null ? selectedModel!.value : 0.0,
        selectedModel!.strValue);
  }

  @override
  init() {}
  @override
  dealloc() {
    FUBeautyPlugin.dispose();
  }
}
