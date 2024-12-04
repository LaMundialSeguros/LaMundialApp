
import 'package:lamundialapp/Utilidades/Class/Currency.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:lamundialapp/Utilidades/Class/TypePayment.dart';

class NotifyPayment {

  final int id;
  final TypeDoc typeDoc;
  final String idCard;
  final String reference;
  final String amount;
  final String date;
  final TypePayment typePayment;
  final Currency currency;
  final dynamic bankRec;
  final dynamic bank;

  NotifyPayment(this.id,this.typeDoc,this.idCard, this.amount,this.date,this.reference,this.typePayment,this.currency,this.bankRec,this.bank);
}
