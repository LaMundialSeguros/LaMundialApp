import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';

class Vehicle {

  final String brand;
  final String model;
  final String year;
  final String color;
  final String placa;
  final String serial;
  final TypeVehicle typeVehicle;

  Vehicle(this.brand,this.model,this.year,this.color,this.placa,this.serial,this.typeVehicle);
}
