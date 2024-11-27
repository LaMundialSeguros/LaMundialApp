// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Beneficiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Beneficiary _$BeneficiaryFromJson(Map<String, dynamic> json) => Beneficiary(
      TypeDoc.fromJson(json['typeDoc'] as Map<String, dynamic>),
      json['idCard'] as String,
      json['name'] as String,
      json['lastName'] as String,
      Relationship.fromJson(json['relationship'] as Map<String, dynamic>),
      json['percent'] as String,
    );

Map<String, dynamic> _$BeneficiaryToJson(Beneficiary instance) =>
    <String, dynamic>{
      'typeDoc': instance.typeDoc,
      'idCard': instance.idCard,
      'name': instance.name,
      'lastName': instance.lastName,
      'relationship': instance.relationship,
      'percent': instance.percent,
    };
