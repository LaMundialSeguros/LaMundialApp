// ignore_for_file: file_names, non_constant_identifier_names, deprecated_member_use

import 'dart:io';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/Utilidades/Class/Relative.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/Vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Policy.g.dart';

@JsonSerializable()
class Policy {
  Product product;
  Taker taker;
  DetailsOwner detailsOwner;
  Producer? producer;
  List<Beneficiary> beneficiaries;
  int familyQuantity;
  List<Relative> relatives;
  Vehicle? vehicle;
  bool dataPolicy;
  bool moneyPolitics;
  bool healthPolicy;
  bool extremeSportsPolicy;
  bool cardiovascularDiseasesPolicy;
  String cardiovascularDiseasesPolicyDetails;
  bool EndocrineDiseasesPolicy;
  String EndocrineDiseasesPolicyDetails;
  bool hematologicalDiseasesPolicy;
  String hematologicalDiseasesPolicyDetails;
  bool drugsPolicy;
  String plan;
  double basicSumInsured;
  double basicSumInsuredUSD;
  String coupon;
  String paymentFrequency;
  bool PoliticianExposed;
  bool currentHealth;
  String additionalText;

 
  @JsonKey(ignore: true)
  File? id;
  
  @JsonKey(ignore: true)
  File? rif;
  
  @JsonKey(ignore: true)
  File? auto;

  @JsonKey(ignore: true)
File? ownerId; // For "cargar cédula titular"

  Policy(
          this.product,
          this.taker,
          this.detailsOwner,
          this.producer,
          this.beneficiaries,
          this.familyQuantity,
          this.relatives,
          this.vehicle,
          this.dataPolicy,
          this.moneyPolitics,
          this.healthPolicy,
          this.extremeSportsPolicy,
          this.cardiovascularDiseasesPolicy,
          this.cardiovascularDiseasesPolicyDetails,
          this.EndocrineDiseasesPolicy,
          this.EndocrineDiseasesPolicyDetails,
          this.hematologicalDiseasesPolicy,
          this.hematologicalDiseasesPolicyDetails,
          this.drugsPolicy,
          this.plan,
          this.basicSumInsured,
          this.basicSumInsuredUSD,
          this.coupon,
          this.paymentFrequency,
          this.PoliticianExposed,
          this.currentHealth,
          this.additionalText,
      {this.id,
      this.rif,
      this.auto,
      this.ownerId // Owner’s ID
} // Optional named parameters for File fields

        );

  // Métodos generados automáticamente
  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyToJson(this);
}
