import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Producer.g.dart';

@JsonSerializable()
class Producer {

  final int id;
  final String name;

  Producer(this.id,this.name);

  // Métodos generados automáticamente
  factory Producer.fromJson(Map<String, dynamic> json) => _$ProducerFromJson(json);
  Map<String, dynamic> toJson() => _$ProducerToJson(this);
}
