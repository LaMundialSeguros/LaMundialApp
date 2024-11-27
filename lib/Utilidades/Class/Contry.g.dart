// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      json['name'] as String,
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
