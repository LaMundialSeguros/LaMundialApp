// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'Amount.g.dart';

@JsonSerializable()
class Amount {

  final int id;
  final String currency;
  final String amount;
  final int productId;
  bool active;

  Amount(this.id,this.currency,this.amount,this.productId,this.active);


  // Métodos generados automáticamente
  factory Amount.fromJson(Map<String, dynamic> json) => _$AmountFromJson(json);
  Map<String, dynamic> toJson() => _$AmountToJson(this);
}
