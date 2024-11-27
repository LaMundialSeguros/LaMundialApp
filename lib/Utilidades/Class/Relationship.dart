import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Relationship.g.dart';

@JsonSerializable()
class Relationship {
  final int id;
  final String name;

  Relationship(this.id,this.name);


  // Métodos generados automáticamente
  factory Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);
  Map<String, dynamic> toJson() => _$RelationshipToJson(this);

}
