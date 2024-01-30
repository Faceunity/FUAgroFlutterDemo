import 'package:json_annotation/json_annotation.dart';

enum ModuleType {
  skin(0),
  shape(1),
  filter(2),
  sticker(3),
  makeup(4),
  body(5);
  
  const ModuleType(this.number);
  final int number;
}

enum BeautySkin {
  @JsonValue(0)
  blurLevel(0), // 磨皮

  @JsonValue(1)
  colorLevel(1),  // 美白

  @JsonValue(2)
  redLevel(2),  // 红润

  @JsonValue(3)
  sharpen(3), // 锐化

  @JsonValue(4)
  faceThreed(4),  // 五官立体

  @JsonValue(5)
  eyeBright(5), // 亮眼

  @JsonValue(6)
  toothWhiten(6), // 美牙

  @JsonValue(7)
  removePouchStrength(7), // 去黑眼圈

  @JsonValue(8)
  removeNasolabialFoldsStrength(8), // 去法令纹

  @JsonValue(9)
  antiAcneSpot(9),  // 祛斑痘

  @JsonValue(10)  
  clarity(10);  // 清晰

  const BeautySkin(this.number);
  final int number;

}

enum BeautyShape {
  @JsonValue(0)
  cheekThinning(0), // 瘦脸

  @JsonValue(1)
  cheekV(1),  // v脸

  @JsonValue(2)
  cheekNarrow(2),  // 窄脸

  @JsonValue(3)
  cheekShort(3), // 短脸

  @JsonValue(4)
  cheekSmall(4),  // 小脸

  @JsonValue(5)
  cheekbones(5), // 瘦颧骨

  @JsonValue(6)
  lowerJaw(6), // 瘦下颌骨

  @JsonValue(7)
  eyeEnlarging(7), // 大眼

  @JsonValue(8)
  eyeCircle(8), // 圆眼

  @JsonValue(9)
  chin(9),  // 下巴

  @JsonValue(10)  
  forehead(10),  // 额头

  @JsonValue(11)  
  nose(11),  // 瘦鼻

  @JsonValue(12)  
  mouth(12),  // 嘴型

  @JsonValue(13)  
  lipThick(13),  // 嘴唇厚度

  @JsonValue(14)  
  eyeHeight(14),  // 眼睛位置

  @JsonValue(15)  
  canthus(15),  // 开眼角

  @JsonValue(16)  
  eyeLid(16), // 眼睑下至

  @JsonValue(17)  
  eyeSpace(17),  // 眼距

  @JsonValue(18)  
  eyeRotate(18),  // 眼睛角度

  @JsonValue(19)  
  longNose(19),  // 长鼻

  @JsonValue(20)  
  philtrum(20),  // 缩人中

  @JsonValue(21)  
  smile(21),  // 微笑嘴角

  @JsonValue(22)  
  browHeight(22), // 眉毛上下

  @JsonValue(23)  
  browSpace(23),  // 眉间距

  @JsonValue(24)  
  browThick(24); // 眉毛粗细

  const BeautyShape(this.number);
  final int number;
}

enum BeautyBody {
  @JsonValue(0)
  slim(0),  // 瘦身       

  @JsonValue(1)
  longLeg(1), // 长腿

  @JsonValue(2)
  thinWaist(2), // 细腰

  @JsonValue(3)
  beautyShoulder(3),  // 美肩

  @JsonValue(4)
  beautyButtock(4), // 美臀

  @JsonValue(5)
  smallHead(5), // 小头

  @JsonValue(6)
  thinLeg(6); // 瘦腿

  const BeautyBody(this.number);
  final int number;
}