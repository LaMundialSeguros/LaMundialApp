import 'package:flutter/material.dart';

class Amount {

  final int id;
  final String currency;
  final String amount;
  final int productId;
  bool active;

  Amount(this.id,this.currency,this.amount,this.productId,this.active);
}
