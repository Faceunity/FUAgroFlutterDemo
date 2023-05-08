abstract class FUAbstractWidget extends Object {
  //是否展示Sider，子类重写
  showSlider() {}

  //选中某个item
  void selectedItem(
    int index,
  ) {}

  //具体选中哪一个由子类决定
  void sliderValueChange(double value) {}

  void switchIsOn(bool isOn) {}

  showBoard() {}

  //检测性能合法性接口
  bool checkPerforLevelVaild(int index) {
    return true;
  }

  //组件初始化像native发消息
  init() {}
  //组件释放 向native 发送消息
  dealloc() {}
}
