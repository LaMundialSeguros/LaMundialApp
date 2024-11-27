// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Producer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producer _$ProducerFromJson(Map<String, dynamic> json) => Producer(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$ProducerToJson(Producer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
