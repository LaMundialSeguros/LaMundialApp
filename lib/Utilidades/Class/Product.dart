import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product {
  final String name;
  final int id;

  Product(this.name, this.id);


  // Métodos generados automáticamente
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
