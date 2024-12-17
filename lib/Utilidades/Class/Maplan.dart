import 'package:lamundialapp/Utilidades/Class/Cobertura.dart';
import 'package:lamundialapp/Utilidades/Class/Frecuencia.dart';
import 'package:lamundialapp/Utilidades/Class/Plan.dart';

class Maplan {
  final List<Plan> plan;
  final List<Cobertura> coberturas;
  final List<Frecuencia> frecuencias;

  Maplan({required this.plan, required this.coberturas, required this.frecuencias});

  factory Maplan.fromJson(Map<String, dynamic> json) {
    var planList = json['plan'] as List;
    var coberturasList = json['coberturas'] as List;
    var frecuenciasList = json['frecuencias'] as List;

    return Maplan(
      plan: planList.map((i) => Plan.fromJson(i)).toList(),
      coberturas: coberturasList.map((i) => Cobertura.fromJson(i)).toList(),
      frecuencias: frecuenciasList.map((i) => Frecuencia.fromJson(i)).toList(),
    );
  }
}