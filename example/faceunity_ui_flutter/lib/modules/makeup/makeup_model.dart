import 'package:json_annotation/json_annotation.dart';

part 'makeup_model.g.dart';

@JsonSerializable()

class MakeupModel {
  String name;
  String bundleName;
  String icon;
  double value;
  bool isCombined;

  MakeupModel(this.name, this.bundleName, this.icon, this.value, this.isCombined);

  factory MakeupModel.fromJson(Map<String, dynamic> json) => _$MakeupModelFromJson(json);
  Map<String, dynamic> toJson() => _$MakeupModelToJson(this);
} 