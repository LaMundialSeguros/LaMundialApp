import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TypeDoc.g.dart';

@JsonSerializable()
class TypeDoc {
  final String name;
  final String id;

  TypeDoc(this.name, this.id);

  // Métodos generados automáticamente
  factory TypeDoc.fromJson(Map<String, dynamic> json) => _$TypeDocFromJson(json);
  Map<String, dynamic> toJson() => _$TypeDocToJson(this);

}