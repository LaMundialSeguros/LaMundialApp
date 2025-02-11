// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'Gender.g.dart';

@JsonSerializable()
class Gender {
  final String name;
  final int id;

  Gender(this.name, this.id);

  // Métodos generados automáticamente
  factory Gender.fromJson(Map<String, dynamic> json) => _$GenderFromJson(json);
  Map<String, dynamic> toJson() => _$GenderToJson(this);

}
