import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/ArrayExtension.dart';
import 'package:faceunity_ui/ViewModels/FUAbstractWidget.dart';

//中间层 处理一些共性的接口，FUAbstractWidget 是底层抽象接口，定义业务行为
class BaseViewModel extends FUAbstractWidget {
  //数据模型
  late FaceUnityModel dataModel;

  //默认选中的索引
  late int selectedIndex;

  //当前选中的模型
  // ignore: avoid_init_to_null
  late BaseModel? selectedModel = null;

  BaseViewModel(this.dataModel);

  //是否展示Sider
  @override
  showSlider() {
    return false;
  }

  @override
  showBoard() {
    return false;
  }

  //选中某个item
  void selectedItem(
    int index,
  ) {
    if (dataModel.dataList.inRange(index)) {
      selectedIndex = index;
      selectedModel = dataModel.dataList[selectedIndex];
    } else {
      print("$this index 越界");
    }
  }

  //具体选中哪一个由子类决定
  void sliderValueChange(double value) {
    if (dataModel.dataList.inRange(selectedIndex)) {
      BaseModel model = dataModel.dataList[selectedIndex];
      model.value = value * model.ratio;
    } else {
      print("$this selectedIndex 越界");
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
