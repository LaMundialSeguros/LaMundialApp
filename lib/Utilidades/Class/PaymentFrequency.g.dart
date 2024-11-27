// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PaymentFrequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentFrequency _$PaymentFrequencyFromJson(Map<String, dynamic> json) =>
    PaymentFrequency(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$PaymentFrequencyToJson(PaymentFrequency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
