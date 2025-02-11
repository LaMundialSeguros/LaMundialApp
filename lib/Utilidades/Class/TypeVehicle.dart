// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'TypeVehicle.g.dart';

@JsonSerializable()
class TypeVehicle {

  final int id;
  final String name;

  TypeVehicle(this.id,this.name);

  // Métodos generados automáticamente
  factory TypeVehicle.fromJson(Map<String, dynamic> json) => _$TypeVehicleFromJson(json);
  Map<String, dynamic> toJson() => _$TypeVehicleToJson(this);
}
