import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Producer.g.dart';

@JsonSerializable()
class Producer {

  final int id;
  final String user;
  final String name;
  final String lastName;
  final String email;
  final String cedula;
  final String password;

  Producer(this.id,this.user,this.name,this.lastName,this.email,this.cedula,this.password);

  // Métodos generados automáticamente
  factory Producer.fromJson(Map<String, dynamic> json) => _$ProducerFromJson(json);
  Map<String, dynamic> toJson() => _$ProducerToJson(this);
}
