// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'Brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
