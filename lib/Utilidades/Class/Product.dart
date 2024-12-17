import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product {

  final int id;
  final String product;
  final int cramo;

  Product(this.id,this.product,this.cramo);

  // Métodos generados automáticamente
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);


  // Método para crear una instancia desde un mapa JSON
  factory Product.fromJsonApi(Map<String, dynamic> json) {
    return Product(
      json['id'], // Asegura que sea un entero
      json['product'],
      json['cramo']
    );
  }
}
