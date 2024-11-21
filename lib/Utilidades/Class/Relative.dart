import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';

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
}
