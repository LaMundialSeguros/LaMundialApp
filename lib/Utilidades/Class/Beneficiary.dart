import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Beneficiary.g.dart';

@JsonSerializable()
class Beneficiary {
  final TypeDoc typeDoc;
  final String idCard;
  final String name;
  final String lastName;
  final Relationship relationship;
  final String percent;

  Beneficiary(
                this.typeDoc,
                this.idCard,
                this.name,
                this.lastName,
                this.relationship,
                this.percent
              );

  // Métodos generados automáticamente
  factory Beneficiary.fromJson(Map<String, dynamic> json) => _$BeneficiaryFromJson(json);
  Map<String, dynamic> toJson() => _$BeneficiaryToJson(this);
}
