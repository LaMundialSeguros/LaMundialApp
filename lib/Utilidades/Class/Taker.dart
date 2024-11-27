import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Taker.g.dart';

@JsonSerializable()
class Taker {
  final TypeDoc typeDoc;
  final String iDcard;
  final String name;
  final String lastName;
  final String Birthdate;

  Taker(this.typeDoc, this.iDcard, this.name,this.lastName,this.Birthdate);


  // Métodos generados automáticamente
  factory Taker.fromJson(Map<String, dynamic> json) => _$TakerFromJson(json);
  Map<String, dynamic> toJson() => _$TakerToJson(this);
}
