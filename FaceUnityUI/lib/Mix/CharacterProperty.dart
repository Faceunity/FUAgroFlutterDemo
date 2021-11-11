//非公共基础属性
mixin CharacterProperty {
  late String strValue; //滤镜字符串值
  // slider 中间为起点
  late bool midSlider;

  //是否展示slider
  late bool showSlider;

  late double ratio; //参数强度取值比例 进度条因为是归一化 所以要 除以ratio

  late double defaultValue; //默认值
}
