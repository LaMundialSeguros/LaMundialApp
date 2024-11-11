import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';

class Beneficiary {
  final TypeDoc typeDoc;
  final String idCard;
  final String name;
  final String lastName;
  final Relationship relationship;
  final int nothing;

  Beneficiary(
                this.typeDoc,
                this.idCard,
                this.name,
                this.lastName,
                this.relationship,
                this.nothing
              );
}
