// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'Producer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producer _$ProducerFromJson(Map<String, dynamic> json) => Producer(
      (json['id'] as num).toInt(),
      json['user'] as String,
      json['name'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['cedula'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$ProducerToJson(Producer instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'name': instance.name,
      'lastName': instance.lastName,
      'email': instance.email,
      'cedula': instance.cedula,
      'password': instance.password,
    };
