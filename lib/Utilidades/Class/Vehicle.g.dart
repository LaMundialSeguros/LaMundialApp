// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      json['brand'] as String,
      json['model'] as String,
      json['year'] as String,
      json['color'] as String,
      json['placa'] as String,
      json['serial'] as String,
      json['serial'] as String
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'color': instance.color,
      'placa': instance.placa,
      'serial': instance.serial,
      'typeVehicle': instance.typeVehicle,
    };
