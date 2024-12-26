// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      Product.fromJson(json['product'] as Map<String, dynamic>),
      Taker.fromJson(json['taker'] as Map<String, dynamic>),
      DetailsOwner.fromJson(json['detailsOwner'] as Map<String, dynamic>),
      Producer.fromJson(json['producer'] as Map<String, dynamic>),
      (json['beneficiaries'] as List<dynamic>)
          .map((e) => Beneficiary.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['familyQuantity'] as num).toInt(),
      (json['relatives'] as List<dynamic>)
          .map((e) => Relative.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      json['dataPolicy'] as bool,
      json['moneyPolitics'] as bool,
      json['healthPolicy'] as bool,
      json['extremeSportsPolicy'] as bool,
      json['cardiovascularDiseasesPolicy'] as bool,
      json['cardiovascularDiseasesPolicyDetails'] as String,
      json['EndocrineDiseasesPolicy'] as bool,
      json['EndocrineDiseasesPolicyDetails'] as String,
      json['hematologicalDiseasesPolicy'] as bool,
      json['hematologicalDiseasesPolicyDetails'] as String,
      json['drugsPolicy'] as bool,
      json['plan'] as String,
      (json['basicSumInsured'] as num).toDouble(),
      (json['basicSumInsuredUSD'] as num).toDouble(),
      json['coupon'] as String,
      json['paymentFrequency'] as String,
      json['PoliticianExposed'] as bool,
      json['currentHealth'] as bool,
      json['additionalText'] as String,
      json['id'] as File,
      json['rif'] as File,
      json['auto'] as File,
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'product': instance.product,
      'taker': instance.taker,
      'detailsOwner': instance.detailsOwner,
      'producer': instance.producer,
      'beneficiaries': instance.beneficiaries,
      'familyQuantity': instance.familyQuantity,
      'relatives': instance.relatives,
      'vehicle': instance.vehicle,
      'dataPolicy': instance.dataPolicy,
      'moneyPolitics': instance.moneyPolitics,
      'healthPolicy': instance.healthPolicy,
      'extremeSportsPolicy': instance.extremeSportsPolicy,
      'cardiovascularDiseasesPolicy': instance.cardiovascularDiseasesPolicy,
      'cardiovascularDiseasesPolicyDetails':
          instance.cardiovascularDiseasesPolicyDetails,
      'EndocrineDiseasesPolicy': instance.EndocrineDiseasesPolicy,
      'EndocrineDiseasesPolicyDetails': instance.EndocrineDiseasesPolicyDetails,
      'hematologicalDiseasesPolicy': instance.hematologicalDiseasesPolicy,
      'hematologicalDiseasesPolicyDetails':
          instance.hematologicalDiseasesPolicyDetails,
      'drugsPolicy': instance.drugsPolicy,
      'plan': instance.plan,
      'basicSumInsured': instance.basicSumInsured,
      'basicSumInsuredUSD': instance.basicSumInsuredUSD,
      'coupon': instance.coupon,
      'paymentFrequency': instance.paymentFrequency,
      'PoliticianExposed': instance.PoliticianExposed,
      'currentHealth': instance.currentHealth,
      'additionalText': instance.additionalText,
      'id': instance.id,
      'rif': instance.rif,
      'auto': instance.auto,
    };
