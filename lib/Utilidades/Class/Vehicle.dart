import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Brand.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Vehicle.g.dart';

@JsonSerializable()
class Vehicle {

  final Brand brand;
  final String model;
  final int modelId;
  final String version;
  final int versionId;
  final String year;
  final String color;
  final int colorId;
  final String placa;
  final String serial;
  final String typeVehicle;

  Vehicle(this.brand,this.model,this.modelId, this.version, this.versionId, this.year,this.color, this.colorId, this.placa,this.serial,this.typeVehicle);

  // Métodos generados automáticamente
  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
