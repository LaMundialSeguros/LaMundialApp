import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';

class DetailsOwner {
  final TypeDoc typeDoc;
  final String idCard;
  final String name;
  final String lastName;
  final Gender gender;
  final String birthDate;
  final bool smoker;
  final Country county;
  final String phone;
  final String email;
  final int beneficiaries;

  DetailsOwner(
                this.typeDoc,
                this.idCard,
                this.name,
                this.lastName,
                this.gender,
                this.birthDate,
                this.smoker,
                this.county,
                this.phone,
                this.email,
                this.beneficiaries
              );
}
