import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/FUImageTool.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';
import 'package:faceunity_plugin/FUStickerPlugin.dart';

class FUStickerViewModel extends BaseViewModel {
  FUStickerViewModel(FaceUnityModel dataModel) : super(dataModel) {
    List<BaseModel> uiList = [];
    List<String> titles = ["noitem", "sdlu", "fashi"];
    String commonPre =
        FUImageTool.getImagePathWithRelativePathPre("Asserts/sticker/3.0x/");
    List<String> imagePaths = List.generate(titles.length, (index) {
      String title = "";
      if (index == 0) {
        title = "Asserts/common/3.0x/" + titles[index];
      } else {
        title = commonPre + titles[index];
      }
      return title;
    });

    for (var i = 0; i < titles.length; i++) {
      BaseModel model = BaseModel(imagePaths[i], '', 0.0, false);
      uiList.add(model);
    }

    this.dataModel.dataList = uiList;
    this.selectedIndex = 0;
    this.selectedModel = this.dataModel.dataList[this.selectedIndex];

    FUStickerPlugin.config();

    selectedItem(selectedIndex);
  }

  @override
  showBoard() {
    return true;
  }

  @override
  void selectedItem(int index) {
    super.selectedItem(index);
    //native plugin
    FUStickerPlugin.selectedItem(index);
  }

  @override
  void sliderValueChange(double value) {
    //没有slider 不处理
  }

  @override
  init() {}
  @override
  dealloc() {
    FUStickerPlugin.dispose();
  }
}
