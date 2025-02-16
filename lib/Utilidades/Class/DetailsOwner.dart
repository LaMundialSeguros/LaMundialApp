// ignore_for_file: file_names

import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/Gender.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DetailsOwner.g.dart';

@JsonSerializable()
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

  // Métodos generados automáticamente
  factory DetailsOwner.fromJson(Map<String, dynamic> json) => _$DetailsOwnerFromJson(json);
  Map<String, dynamic> toJson() => _$DetailsOwnerToJson(this);
}
