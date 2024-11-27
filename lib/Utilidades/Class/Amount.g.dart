// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
      (json['id'] as num).toInt(),
      json['currency'] as String,
      json['amount'] as String,
      (json['productId'] as num).toInt(),
      json['active'] as bool,
    );

Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'amount': instance.amount,
      'productId': instance.productId,
      'active': instance.active,
    };
