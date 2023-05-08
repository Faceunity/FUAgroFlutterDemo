import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/FUImageTool.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';
import 'package:faceunity_plugin/FUMakeupPlugin.dart';

class FUMakeupViewModel extends BaseViewModel {
  FUMakeupViewModel(FaceUnityModel dataModel) : super(dataModel) {
    List<String> imageName = [
      "makeup_noitem",
      "demo_combination_rabbit",
      "demo_combination_freezing_age",
      "demo_combination_guo_feng",
      "demo_combination_mixed_race",
      "demo_combination_age",
      "demo_combination_warm_winter"
    ];
    Map<String, dynamic> imageNameAndTitle = {
      "makeup_noitem": "卸妆",
      "demo_combination_rabbit": "嗲嗲兔",
      "demo_combination_freezing_age": "冻龄",
      "demo_combination_guo_feng": "国风",
      "demo_combination_mixed_race": "混血",
      "demo_combination_age": "减龄",
      "demo_combination_warm_winter": "暖冬"
    };

    String commonPre =
        FUImageTool.getImagePathWithRelativePathPre("Asserts/makeup/3.0x/");
    List<String> imagePaths = List.generate(imageName.length, (index) {
      String title = imageName[index];

      title = commonPre + title;

      return title;
    });

    List<BaseModel> uiList = [];
    for (var i = 0; i < imageName.length; i++) {
      String key = imageName[i];
      BaseModel model =
          BaseModel(imagePaths[i], imageNameAndTitle[key], 0.7, false);
      model.ratio = 1.0;
      uiList.add(model);
    }
    this.dataModel.dataList = uiList;
    this.selectedIndex = 0;
    this.selectedModel = this.dataModel.dataList[this.selectedIndex];

    FUMakeupPlugin.config();

    selectedItem(selectedIndex);
  }

  @override
  showBoard() {
    return true;
  }

  //是否展示Sider
  @override
  showSlider() {
    if (selectedIndex == 0) {
      return false;
    }
    return true;
  }

  @override
  void selectedItem(int index) {
    super.selectedItem(index);
    //native plugin
    FUMakeupPlugin.selectedItem(index);
  }

  @override
  void sliderValueChange(double value) {
    super.sliderValueChange(value);
    FUMakeupPlugin.sliderValueChange(selectedIndex, value);
  }

  @override
  init() {}
  @override
  dealloc() {
    //先设置卸妆
    if (selectedIndex != 0) {
      //美妆业务dispose 不保留，所以要卸妆
      FUMakeupPlugin.selectedItem(0);
      selectedIndex = 0;
    }
    FUMakeupPlugin.dispose();
  }
}
