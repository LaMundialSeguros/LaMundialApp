// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'Vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      Brand.fromJson(json['brand'] as Map<String, dynamic>),
      json['model'] as String,
      (json['modelId'] as num).toInt(),
      json['version'] as String,
      (json['versionId'] as num).toInt(),
      json['year'] as String,
      json['color'] as String,
      (json['colorId'] as num).toInt(),
      json['placa'] as String,
      json['serial'] as String,
      json['typeVehicle'] as String,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'brand': instance.brand,
      'model': instance.model,
      'modelId': instance.modelId,
      'version': instance.version,
      'versionId': instance.versionId,
      'year': instance.year,
      'color': instance.color,
      'colorId': instance.colorId,
      'placa': instance.placa,
      'serial': instance.serial,
      'typeVehicle': instance.typeVehicle,
    };
