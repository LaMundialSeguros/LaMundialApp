// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'TypeVehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypeVehicle _$TypeVehicleFromJson(Map<String, dynamic> json) => TypeVehicle(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$TypeVehicleToJson(TypeVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
