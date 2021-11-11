import 'package:faceunity_ui/Tools/FUDataDefine.dart';

class FaceUnityModel extends Object {
  late final FUDataType bizType;
  late final String title;
  //Switch 开关状态
  late bool isOn;
  //Switch 是否隐藏
  late final bool showSwitch;
  //存放美肤、美型、美体等模型列表
  late List<dynamic> dataList = [];
  FaceUnityModel(this.bizType, this.title, this.showSwitch, this.isOn);
}
