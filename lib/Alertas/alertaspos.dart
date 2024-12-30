import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            onPressed: () {
              /*menu.MenuAppState().disconnectSocket();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );*/
              //Navigator.of(context).popUntil((route) => route.isFirst);
              //pagar.limpiar_campos();
              //SystemNavigator.pop();
              //Restart.restartApp();
            },
            color: const Color.fromRGBO(3, 134, 208, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/Sesion_Caducada.png"),
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
              //Navigator.pop(context);
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
        child: Image.asset("assets/no_existen_registros.png"),
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
              // Navigator.of(context).pop();
            },
            color: Color.fromRGBO(232, 79, 81, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      //image: Image.asset("img/error_de_conexion.png"),
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/error_conexion.png"),
      ),
      //image: SvgPicture.asset("img/icons/error_conexion.svg"),
    ).show();
  }

// Future<void> sinConexion(context) async {
//   AnimationController controller = AnimationController(
//     duration: const Duration(milliseconds: 500),
//     vsync: Navigator.of(context),
//   );

//   Animation<Offset> offsetAnimation = Tween<Offset>(
//     begin: const Offset(0.0, 1.5),
//     end: Offset.zero,
//   ).animate(CurvedAnimation(
//     parent: controller,
//     curve: Curves.easeOut,
//   ));

//   controller.forward();

//   Alert(
//     context: context,
//     style: AlertStyle(
//       animationType: AnimationType.fromBottom, // La animación original
//       animationDuration: const Duration(milliseconds: 500),
//       overlayColor: Colors.black.withOpacity(0.7),
//     ),
//     //title: "ERROR DE CONEXIÓN",
//     buttons: [
//       DialogButton(
//         onPressed: () {
//           Navigator.of(context).popUntil((route) => route.isFirst);
//         },
//         color: Colors.blue,
//         child: const Text("OK", style: TextStyle(color: Colors.white)),
//       ),
//     ],
//     image: Image.asset("img/error_de_conexion.png"),
//   ).show();

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return SlideTransition(
//         position: offsetAnimation,
//         child: const SizedBox.shrink(),
//       );
//     },
//   );
// }

  Future<void> impresoraDesconectada(context) async {
    //loading = false;
    Alert(
      style: alertStyle,
      context: context,
      //title: "ERROR DE CONEXIÓN",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: const Color.fromRGBO(3, 134, 208, 1),
            child: const Text("OK",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Image.asset("assets/errorprinter.png"),
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
              //Navigator.pop(context);
              //cedula.text = '';
              //dosfa.text = '';
            },
            color: Color.fromRGBO(232, 79, 81, 1),
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/errorprinter.png"),
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
        child: Image.asset("assets/no_existen_registros.png"),
      ),
      //image: Image.asset("img/qrinvalido.png"),
    ).show();
  }

}
