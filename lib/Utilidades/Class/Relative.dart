import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Relative.g.dart';

@JsonSerializable()
class Relative {
  final TypeDoc typeDoc;
  final String idCard;
  final String birthDate;
  final Relationship relationship;

  Relative(
                this.typeDoc,
                this.idCard,
                this.birthDate,
                this.relationship
              );


  // Métodos generados automáticamente
  factory Relative.fromJson(Map<String, dynamic> json) => _$RelativeFromJson(json);
  Map<String, dynamic> toJson() => _$RelativeToJson(this);
}
