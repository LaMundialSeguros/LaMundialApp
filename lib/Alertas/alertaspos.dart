import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lamundialapp/Stilos/stilospos.dart';

//Fin de instancia

// Rutia para habilitar los dias en el calendario
bool disableDate(DateTime day) {
  if ((day.isAfter(DateTime.now().subtract(const Duration(days: 31))) &&
      day.isBefore(DateTime.now().add(const Duration(days: 1))))) {
    return true;
  }
  return false;
}
// Fin de rutina

// ignore: camel_case_types
class Alerta extends StatefulWidget {
  const Alerta({Key? key}) : super(key: key);
  //const MyApp({super.key});

  @override
  State<Alerta> createState() => AlertaState();
}

// ignore: camel_case_types
class AlertaState extends State<Alerta> {
  String fechaactual = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late BuildContext materialAppContext;

  @override
  void initState() {
    super.initState();
    //fechaactual = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> sesionvencida(context) async {
    Alert(
      style: alertStyle,
      context: context,
      //title: "FONDO INSUFICIENTE",
      buttons: [
        DialogButton(
            onPressed: () {},
            color: const Color.fromRGBO(3, 134, 208, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins', fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error.png"),
      ),
    ).show();
  }

  Future<void> sinArchivo(context) async {
    Alert(
      style: alertStyle,

      context: context,
      //title: "Sin archivos sin imprimir",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error.png"),
      ),
      //image: Image.asset("img/no_existe_registro.png"),
    ).show();
  }

  Future<void> sinConexion(context) async {
    Alert(
      style: alertStyle,
      context: context,
      title: "Error de conexión",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            color: const Color.fromRGBO(232, 79, 81, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error.png"),
      ),
    ).show();
  }

  Future<void> usuarioNoexiste(context) async {
    Alert(
      style: alertStyle,
      context: context,
      title: "DATOS INVÁLIDOS",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            color: const Color.fromRGBO(232, 79, 81, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins', fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error.png"),
      ),
      //image: Image.asset("img/datos_invalidos.png"),
    ).show();
  }

  Future<void> noVer(context) async {
    Alert(
      style: alertStyle,
      context: context,
      //title: "USUARIO INVÁLIDO",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error.png"),
      ),
      //image: Image.asset("img/qrinvalido.png"),
    ).show();
  }
}
