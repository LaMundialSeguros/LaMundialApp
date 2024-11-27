import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PaymentFrequency.g.dart';

@JsonSerializable()
class PaymentFrequency {

  final int id;
  final String name;

  PaymentFrequency(this.id,this.name);


  // Métodos generados automáticamente
  factory PaymentFrequency.fromJson(Map<String, dynamic> json) => _$PaymentFrequencyFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentFrequencyToJson(this);
}
