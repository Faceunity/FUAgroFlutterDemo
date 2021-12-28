import 'package:faceunity_plugin/FUBeautyPlugin.dart';
import 'package:faceunity_plugin/FUViewModelManagerPlugin.dart';
import 'package:faceunity_ui/Models/BaseModel.dart';
import 'package:faceunity_ui/Models/FaceUnityModel.dart';
import 'package:faceunity_ui/Tools/FUDataDefine.dart';
import 'package:faceunity_ui/ViewModels/BaseViewModel.dart';
import 'package:faceunity_ui/ViewModels/FUBeautyFilterViewModel.dart';
import 'package:faceunity_ui/ViewModels/FUBeautyShapeViewModel.dart';
import 'package:faceunity_ui/ViewModels/FUBeautySkinViewModel.dart';
import 'package:faceunity_ui/ViewModels/FUMakeupViewModel.dart';
import 'package:faceunity_ui/ViewModels/FUStickerViewModel.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe

///管理 各个类的viewModel 和 底部标题数组，并且刷新UI，
/////后续优化方向(看需求而定):可以把标题数据和具体子业务(美型、美妆等)数据分开，建立映射关系，这样标题刷新和子业务刷新就可以隔离开而不是公用ViewModelManager
class ViewModelManager extends Object with ChangeNotifier {
  //当前选中的viewModel
  late BaseViewModel curViewModel;

  //底部业务模型列表
  late List<BaseViewModel> viewModelList = [];

  //当前业务模型添加到渲染循环的映射，通过switch开关来控制
  late Map<dynamic, BaseViewModel> viewModelCache = {};

  //当前选中底部的业务模型索引
  late int seletedViewModelIndex = -1;

  //是否展示子菜单(美肤、美型、滤镜等等)
  late bool showSubUI = false;

  ViewModelManager() {
    //美肤
    FUBeautySkinViewModel skinViewModel = FUBeautySkinViewModel(
        FaceUnityModel(FUDataType.FUDataTypeBeautySkin, "美肤", true, true));
    curViewModel = skinViewModel;
    viewModelList.add(skinViewModel);
    //美型
    FUBeautyShapeViewModel shapeViewModel = FUBeautyShapeViewModel(
        FaceUnityModel(FUDataType.FUDataTypeBeautyShape, "美型", true, true));
    viewModelList.add(shapeViewModel);

    //滤镜
    FUBeautyFilterViewModel filterViewModel = FUBeautyFilterViewModel(
        FaceUnityModel(FUDataType.FUDataTypeBeautyFilter, "滤镜", true, true));
    viewModelList.add(filterViewModel);

    //贴纸
    FUStickerViewModel stickerViewModel = FUStickerViewModel(
        FaceUnityModel(FUDataType.FUDataTypeSticker, "贴纸", false, false));
    viewModelList.add(stickerViewModel);

    //美妆
    FUMakeupViewModel makeupViewModel = FUMakeupViewModel(
        FaceUnityModel(FUDataType.FUDataTypeMakeup, "美妆", false, false));
    viewModelList.add(makeupViewModel);

    //配置ViewModekManager插件
    FUViewModelManagerPlugin.config();

    //配置化美颜模块: UI上美颜的子模块: 美肤、美型、滤镜是独立的，但是业务上其实是合起来的，所以在这里初始化一次美颜模块即可. 无需在每一个里面各自初始化
    FUBeautyPlugin.config();
  }

  //选中某个item
  void selectedItem(
    int index,
  ) {
    curViewModel.selectedItem(index);
    notifyListeners();
  }

  void sliderValueChange(double value) {
    curViewModel.sliderValueChange(value);
    notifyListeners();
  }

  //点击子标题回调
  void clickTitleItem(int index) {
    if (!showSubUI) {
      showSubUI = true;
    } else {
      showSubUI = index != seletedViewModelIndex;
    }
    seletedViewModelIndex = index;
    //让native把当前的业务添加到渲染循环
    addViewModelRenderLoop(this.viewModelList[index]);

    if (index < 3) {
      //兼容处理具体的美颜子项
      FUViewModelManagerPlugin.compatibleClickBeautyItem(index);
    }

    notifyListeners();
  }

  //特殊处理美颜部分数据
  static List<FUDataType> beautyDataType = [
    FUDataType.FUDataTypeBeautyShape,
    FUDataType.FUDataTypeBeautySkin,
    FUDataType.FUDataTypeBeautyFilter
  ];
  //switch开关
  void switchIsOn(bool isOn) {
    //对应业务从渲染循环添加或者移除
    curViewModel.switchIsOn(isOn);

    //默认选择美颜
    int bizType = 0;
    //美型、美肤、滤镜公用一个switch 开关状态，所以需要特殊处理下
    if (beautyDataType.contains(curViewModel.dataModel.bizType)) {
      //遍历列表处理其他两个curViewModel的isOn状态
      for (BaseViewModel viewModel in viewModelList) {
        if (beautyDataType.contains(viewModel.dataModel.bizType)) {
          viewModel.dataModel.isOn = isOn;
        }
      }
    } else {
      //业务上美颜是合起来的，但是UI是分开的，所以 业务索引存在 index - 2 的关系(美颜包含美肤、美型，滤镜三项)
      //具体可以参考switchOn接口注释
      bizType = curViewModel.dataModel.bizType.index - 2;
    }
    FUViewModelManagerPlugin.switchOn(isOn, bizType);
  }

  //美型、美肤reset按钮
  bool isDefaultValue() {
    bool flag = true;
    for (BaseModel model in curViewModel.dataModel.dataList) {
      if ((model.value - model.defaultValue).abs() > 0.01) {
        flag = false;
        break;
      }
    }
    return flag;
  }

  void reset() {
    for (BaseModel model in curViewModel.dataModel.dataList) {
      //只针对有修改的进行还原
      if ((model.value - model.defaultValue).abs() > 0.01) {
        model.value = model.defaultValue;
      }
    }

    FUBeautyPlugin.resetDefault(curViewModel.dataModel.bizType.index);

    notifyListeners();
  }

  //添加到渲染循环
  void addViewModelRenderLoop(BaseViewModel viewModel) {
    curViewModel = viewModel;
    if (!viewModelCache.containsKey(viewModel.dataModel.bizType)) {
      viewModelCache[viewModel.dataModel.bizType] = viewModel;
      //通知native 添加到loop
      //默认选择美颜
      int tempBizType = 0;
      //美型、美肤、滤镜公用一个switch 开关状态，所以需要特殊处理下
      if (!beautyDataType.contains(curViewModel.dataModel.bizType)) {
        tempBizType = curViewModel.dataModel.bizType.index - 2;
      }
      FUViewModelManagerPlugin.addViewModelToRunLoop(tempBizType);
    }
  }

  //移除渲染循环
  void removeViewModelRenderLoop(FUDataType bizType) {
    if (viewModelCache.containsKey(bizType)) {
      viewModelCache.remove(bizType);
      //默认选择美颜
      int tempBizType = 0;
      //美型、美肤、滤镜公用一个switch 开关状态，所以需要特殊处理下
      if (!beautyDataType.contains(bizType)) {
        tempBizType = bizType.index - 2;
      }
      //通知native 移除loop
      FUViewModelManagerPlugin.removeViewModelFromRunLoop(tempBizType);
    }
  }

  @override
  void dispose() {
    for (BaseViewModel viewModel in viewModelList) {
      viewModel.dealloc();
    }

    FUViewModelManagerPlugin.dispose();

    super.dispose();
  }
}
