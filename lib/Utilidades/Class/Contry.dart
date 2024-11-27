import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Contry.g.dart';

@JsonSerializable()
class Country {
  final String name;
  final int id;

  Country(this.name, this.id);

  // Métodos generados automáticamente
  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

}
