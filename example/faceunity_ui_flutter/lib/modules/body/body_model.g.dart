// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyModel _$BodyModelFromJson(Map<String, dynamic> json) => BodyModel(
      json['name'] as String,
      $enumDecode(_$BeautyBodyEnumMap, json['type']),
      (json['currentValue'] as num).toDouble(),
      (json['defaultValue'] as num).toDouble(),
      json['defaultValueInMiddle'] as bool,
    );

Map<String, dynamic> _$BodyModelToJson(BodyModel instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$BeautyBodyEnumMap[instance.type]!,
      'currentValue': instance.currentValue,
      'defaultValue': instance.defaultValue,
      'defaultValueInMiddle': instance.defaultValueInMiddle,
    };

const _$BeautyBodyEnumMap = {
  BeautyBody.slim: 0,
  BeautyBody.longLeg: 1,
  BeautyBody.thinWaist: 2,
  BeautyBody.beautyShoulder: 3,
  BeautyBody.beautyButtock: 4,
  BeautyBody.smallHead: 5,
  BeautyBody.thinLeg: 6,
};
