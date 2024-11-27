// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Relationship _$RelationshipFromJson(Map<String, dynamic> json) => Relationship(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$RelationshipToJson(Relationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
