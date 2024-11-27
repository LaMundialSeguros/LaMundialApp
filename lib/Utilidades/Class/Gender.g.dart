// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Gender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gender _$GenderFromJson(Map<String, dynamic> json) => Gender(
      json['name'] as String,
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$GenderToJson(Gender instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
