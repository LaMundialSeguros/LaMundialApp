import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/Vehicle.dart';

class Policy {
  final Taker taker;
  final DetailsOwner detailsOwner;
  final Producer producer;
  final List<Beneficiary> beneficiaries;
  final Vehicle vehicle;
  final bool individual;
  final bool familiar;
  final bool dataPolicy;
  final bool moneyPolitics;
  final bool healthPolicy;
  final bool currentHealthPolicy;
  final bool hematologicalDiseasesPolicy;
  final bool drugsPolicy;
  final double basicSumInsured;
  final String coupon;
  final PaymentFrequency paymentFrequency;
  final bool PoliticianExposed;
  final bool currentHealth;
  final String additionalText;
  Policy(
          this.taker,
          this.detailsOwner,
          this.producer,
          this.beneficiaries,
          this.vehicle,
          this.individual,
          this.familiar,
          this.dataPolicy,
          this.moneyPolitics,
          this.healthPolicy,
          this.currentHealthPolicy,
          this.hematologicalDiseasesPolicy,
          this.drugsPolicy,
          this.basicSumInsured,
          this.coupon,
          this.paymentFrequency,
          this.PoliticianExposed,
          this.currentHealth,
          this.additionalText
        );
}
