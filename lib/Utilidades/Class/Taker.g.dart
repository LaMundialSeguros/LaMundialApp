// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Taker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Taker _$TakerFromJson(Map<String, dynamic> json) => Taker(
      TypeDoc.fromJson(json['typeDoc'] as Map<String, dynamic>),
      json['iDcard'] as String,
      json['name'] as String,
      json['lastName'] as String,
      json['Birthdate'] as String,
    );

Map<String, dynamic> _$TakerToJson(Taker instance) => <String, dynamic>{
      'typeDoc': instance.typeDoc,
      'iDcard': instance.iDcard,
      'name': instance.name,
      'lastName': instance.lastName,
      'Birthdate': instance.Birthdate,
    };
