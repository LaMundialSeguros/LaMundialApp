// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'Product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['id'] as num).toInt(),
      json['product'] as String,
      (json['cramo'] as num).toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'cramo': instance.cramo,
    };
