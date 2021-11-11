import 'package:faceunity_plugin/FUBeautyPlugin.dart';
import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';

abstract class BaseViewModel extends Object {
  //数据模型
  late FaceUnityModel dataModel;

  //默认选中的索引
  late int selectedIndex;

  //当前选中的模型
  // ignore: avoid_init_to_null
  late BaseModel? selectedModel = null;

  BaseViewModel(this.dataModel);

  //是否展示Sider，子类重写
  showSlider() {
    return false;
  }

  //选中某个item
  void selectedItem(
    int index,
  ) {
    if (selectedIndex < dataModel.dataList.length) {
      selectedIndex = index;
      selectedModel = dataModel.dataList[selectedIndex];
    }
    //0 对应的就是美颜
    FUBeautyPlugin.selectedItem(index);
  }

  //具体选中哪一个由子类决定
  void sliderValueChange(double value) {
    if (selectedIndex < dataModel.dataList.length) {
      BaseModel model = dataModel.dataList[selectedIndex];
      model.value = value * model.ratio;
    }
  }

  void switchIsOn(bool isOn) {
    dataModel.isOn = isOn;
  }

  //组件初始化像native发消息
  init() {}
  //组件释放 向native 发送消息
  dealloc() {}
}
