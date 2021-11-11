import 'package:faceunity_ui/Mix/CharacterProperty.dart';

class BaseModel extends Object with CharacterProperty {
  late String title;
  late final String imagePath;
  late double value;

  BaseModel(this.imagePath, this.title, this.value) {
    ratio = 1.0;
    showSlider = false;
    midSlider = false;
    strValue = "";
    defaultValue = this.value;
  }
}
