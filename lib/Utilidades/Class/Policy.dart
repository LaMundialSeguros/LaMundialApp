import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Amount.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/Utilidades/Class/Relative.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/Vehicle.dart';

class Policy {
  Product product;
  Taker taker;
  DetailsOwner detailsOwner;
  Producer producer;
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
  List<Amount> basicSumInsured;
  String coupon;
  PaymentFrequency paymentFrequency;
  bool PoliticianExposed;
  bool currentHealth;
  String additionalText;

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
          this.basicSumInsured,
          this.coupon,
          this.paymentFrequency,
          this.PoliticianExposed,
          this.currentHealth,
          this.additionalText
        );
}
