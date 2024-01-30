import 'package:json_annotation/json_annotation.dart';

part 'sticker_model.g.dart';

@JsonSerializable()

class StickerModel {
  String bundleName;
  String icon;

  StickerModel(this.bundleName, this.icon);

  factory StickerModel.fromJson(Map<String, dynamic> json) => _$StickerModelFromJson(json);
  Map<String, dynamic> toJson() => _$StickerModelToJson(this);
}