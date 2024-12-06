import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Vehicle.g.dart';

@JsonSerializable()
class Vehicle {

  final String brand;
  final String model;
  final String year;
  final String color;
  final String placa;
  final String serial;
  final String typeVehicle;

  Vehicle(this.brand,this.model,this.year,this.color,this.placa,this.serial,this.typeVehicle);

  // Métodos generados automáticamente
  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
