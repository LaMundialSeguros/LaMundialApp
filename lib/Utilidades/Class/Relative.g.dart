// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Relative.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relative _$RelativeFromJson(Map<String, dynamic> json) => Relative(
      TypeDoc.fromJson(json['typeDoc'] as Map<String, dynamic>),
      json['idCard'] as String,
      json['birthDate'] as String,
      Relationship.fromJson(json['relationship'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelativeToJson(Relative instance) => <String, dynamic>{
      'typeDoc': instance.typeDoc,
      'idCard': instance.idCard,
      'birthDate': instance.birthDate,
      'relationship': instance.relationship,
    };
