import 'package:flutter/material.dart';

class TypePayment {

  final int id;
  final String name;

  TypePayment(this.id,this.name);

  // Método para crear una instancia desde un mapa JSON
  factory TypePayment.fromJsonApi(Map<String, dynamic> json) {
    return TypePayment(
      json['ctipopago'], // Asegura que sea un entero
      json['xtipopago'],
    );
  }
}
