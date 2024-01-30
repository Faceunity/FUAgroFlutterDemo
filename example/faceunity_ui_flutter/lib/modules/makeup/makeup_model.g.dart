// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'makeup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeupModel _$MakeupModelFromJson(Map<String, dynamic> json) => MakeupModel(
      json['name'] as String,
      json['bundleName'] as String,
      json['icon'] as String,
      (json['value'] as num).toDouble(),
      json['isCombined'] as bool,
    );

Map<String, dynamic> _$MakeupModelToJson(MakeupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bundleName': instance.bundleName,
      'icon': instance.icon,
      'value': instance.value,
      'isCombined': instance.isCombined,
    };
