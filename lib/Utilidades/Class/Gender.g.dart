// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

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
