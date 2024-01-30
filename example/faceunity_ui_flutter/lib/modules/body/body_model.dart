import 'package:json_annotation/json_annotation.dart';
import 'package:faceunity_ui_flutter/util/faceunity_defines.dart';

part 'body_model.g.dart';

@JsonSerializable()

class BodyModel {
  String name;
  BeautyBody type;
  double currentValue;
  double defaultValue;
  /// 默认值是否中位数
  late bool defaultValueInMiddle;

  BodyModel(this.name, this.type, this.currentValue, this.defaultValue, this.defaultValueInMiddle);

  factory BodyModel.fromJson(Map<String, dynamic> json) => _$BodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$BodyModelToJson(this);
}