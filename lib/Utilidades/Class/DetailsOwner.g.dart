// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DetailsOwner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailsOwner _$DetailsOwnerFromJson(Map<String, dynamic> json) => DetailsOwner(
      TypeDoc.fromJson(json['typeDoc'] as Map<String, dynamic>),
      json['idCard'] as String,
      json['name'] as String,
      json['lastName'] as String,
      Gender.fromJson(json['gender'] as Map<String, dynamic>),
      json['birthDate'] as String,
      json['smoker'] as bool,
      Country.fromJson(json['county'] as Map<String, dynamic>),
      json['phone'] as String,
      json['email'] as String,
      (json['beneficiaries'] as num).toInt(),
    );

Map<String, dynamic> _$DetailsOwnerToJson(DetailsOwner instance) =>
    <String, dynamic>{
      'typeDoc': instance.typeDoc,
      'idCard': instance.idCard,
      'name': instance.name,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'smoker': instance.smoker,
      'county': instance.county,
      'phone': instance.phone,
      'email': instance.email,
      'beneficiaries': instance.beneficiaries,
    };
