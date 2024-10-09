// ignore_for_file: use_build_context_synchronously

//import 'package:crixtopos/sunmi/sunmi_printer.dart';
//import 'package:lamundialapp/pages/lista_recibo.dart';

import 'package:lamundialapp/pages/login_page.dart';
//import 'package:lamundialapp/pages/qrscreen_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:restart_app/restart_app.dart';
import 'package:lamundialapp/pages/menu_page.dart' as menu;
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lamundialapp/Negocio/pagar.dart';
import 'package:lamundialapp/Stilos/stilospos.dart';
import 'package:lamundialapp/Apis/apispos.dart';
//import 'package:crixtopos/sunmi/sunmi_printer.dart';
import 'package:lamundialapp/Utilidades/scanqr.dart'; // Asegúrate de que la ruta sea correcta
//import 'package:flutter_svg/flutter_svg.dart';

//Instancia de las clases
pagarState pagar = pagarState();
QRViewExampleState scan = QRViewExampleState();
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

// Crea una instancia de QRViewExample
const qrViewExample = QRViewExample(
  selectedCurrency: '',
);
QRViewExampleState qrViewState = QRViewExampleState();
QRViewExampleState currentQRViewState = qrViewState;

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

  Future<void> sinsaldo(context) async {
    Alert(
      style: alertStyle,
      context: context,
      //title: "FONDO INSUFICIENTE",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.of(context).popUntil((route) => route.isFirst);
              pagar.limpiar_campos();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/saldo_insuficiente.png"),
      ),
      //image: Image.asset("img/saldo_insuficiente.png"),
    ).show();
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
                    fontFamily: 'Capriola',
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
                    fontFamily: 'Capriola',
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

  Future<void> montoErrado(BuildContext context) async {
    Alert(
      style: alertStyle,
      context: context,
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
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/datos_invalidos.png"),
      ),
    ).show();
  }

  Future<void> sinConexion(context) async {
    Alert(
      style: alertStyle,
      context: context,
      //title: "Error de conexión",
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              // Navigator.of(context).pop();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
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
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Image.asset("assets/errorprinter.png"),
    ).show();
  }

  Future<void> usuarioNoexiste(context) async {
    Alert(
      style: alertStyle,
      context: context,
      buttons: [
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.pop(context);
              cedula.text = '';
              dosfa.text = '';
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/datos_invalidos.png"),
      ),
      //image: Image.asset("img/datos_invalidos.png"),
    ).show();
  }

  Future<void> qrNovalido(context) async {
    Alert(
      style: alertStyle,
      context: context,
      //title: "USUARIO INVÁLIDO",
      buttons: [
        DialogButton(
            onPressed: () {
              spinerState.setAlerta('qrnovalido');
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
              QRViewExampleState.globalController?.resumeCamera();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/qrinvalido.png"),
      ),
      //image: Image.asset("img/qrinvalido.png"),
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
                    fontFamily: 'Capriola',
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

  Future<void> success(context) async {
    List<DialogButton> buttons = [
      DialogButton(
          onPressed: () async {
            try {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const SpinKitDualRing(
                      color: Color.fromRGBO(50, 110, 91, 0.965),
                      size: 60.0, // ajusta el tamaño según tus necesidades
                    );
                  });
              //await FuncionSunmi.print();
            } catch (e) {
              // ignore: avoid_print
              print(e);
              sinConexion(context);
            } finally {
              Navigator.of(context)
                  .pop(); // Cerrar el diálogo en cualquier caso
            }
          },
          // onPressed: () {
          //   try {
          //     FuncionSunmi.print();
          //   } catch (e) {
          //     sinConexion(context);
          //   }
          // },
          color: Colors.white, // Color del botón
          child: const Text("Imprimir                Recibo",
              style: TextStyle(
                  color: Color.fromRGBO(3, 134, 208, 1),
                  fontFamily: 'Capriola',
                  fontSize: 15))),
      DialogButton(
          onPressed: () {
            if (QRViewExampleState.globalController != null) {
              pagar.limpiar_campos();
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              // La cámara está inicializada
              // Puedes realizar acciones adicionales aquí
            } else {
              pagar.limpiar_campos();
              Navigator.of(context, rootNavigator: true).pop();

              // La cámara no está inicializada
              // Puedes mostrar un mensaje de error o realizar acciones correspondientes
            }
          },
          color: Colors.white,
          child: const Text("Aceptar",
              style: TextStyle(
                  color: Color.fromRGBO(3, 134, 208, 1),
                  fontFamily: 'Capriola',
                  fontSize: 20))),
    ];

    if (modelo == 0) {
      buttons = [
        DialogButton(
          onPressed: () {
            if (appState.getCamera()) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
              appState.setCamera(false);
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
            pagar.limpiar_campos();
          },
          color: Colors.white,
          child: const Text("Aceptar",
              style: TextStyle(
                  color: Color.fromRGBO(3, 134, 208, 1),
                  fontFamily: 'Capriola',
                  fontSize: 20)),
        ),
      ];
    }

    DateTime fechaDateTime = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(fecha);
    String fechastr = DateFormat('dd-MM-yyyy').format(fechaDateTime);
    String hora = DateFormat('hh:mm:ss a').format(fechaDateTime);
    hora = hora.replaceAll('AM', 'am.').replaceAll('PM', 'pm.');
    Alert(
      style: alertStyle4,
      context: context,
      desc:
          "Monto: ${monto.text} USDT                                        Txnid: $txid                                  Fecha: $fechastr                           Hora: $hora",
      buttons: buttons,
      image: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/transaccion_exitosa.png"),
      ),
    ).show();
  }

  Future<void> ultimoRecibo(
      context, ultimotxnid, ultimafecha, ultimomontopago, ultimouser) async {
    DateTime fechaDateTime =
        DateFormat('dd-MM-yyyy hh:mm:ss a').parse(ultimafecha);
    String fecha = DateFormat('dd-MM-yyyy').format(fechaDateTime);
    String hora = DateFormat('hh:mm:ss a').format(fechaDateTime);
    hora = hora.replaceAll('AM', 'am.').replaceAll('PM', 'pm.');
    // Separar fecha y hora

    Alert(
      style: alertStyle2,
      context: context,
      desc:
          "USUARIO                             $ultimouser                             Monto: $ultimomontopago usdt                                        Txnid: $ultimotxnid                                 Fecha: $fecha                            Hora: $hora",
      buttons: [
        // DialogButton(
        //     onPressed: () async {
        //       try {
        //         showDialog(
        //             context: context,
        //             builder: (context) {
        //               return const SpinKitDualRing(
        //                 color: Color.fromRGBO(50, 110, 91, 0.965),
        //                 size: 60.0, // ajusta el tamaño según tus necesidades
        //               );
        //               //return const Center(child: CircularProgressIndicator());
        //             });
        //         //await FuncionSunmi.printultimorecibo(
        //         //ultimotxnid, ultimafecha, ultimomontopago, ultimouser);
        //         //Navigator.of(context).pop();
        //       } catch (e) {
        //         // ignore: avoid_print
        //         print(e);
        //         sinArchivo(context);
        //       } finally {
        //         Navigator.of(context)
        //             .pop(); // Cerrar el diálogo en cualquier caso
        //       }
        //     },
        //     // onPressed: () {
        //     //   try {
        //     //     FuncionSunmi.printultimorecibo(
        //     //         ultimotxnid, ultimafecha, ultimomontopago, ultimouser);
        //     //   } catch (e) {
        //     //     sinArchivo(context);
        //     //   }
        //     // },
        //     color: Colors.white,
        //     child: const Text("Imprimir recibo",
        //         style: TextStyle(
        //             color: Color.fromRGBO(3, 134, 208, 1),
        //             fontFamily: 'Capriola',
        //             fontSize: 15))),

        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.pop(context);
              pagar.limpiar_campos();
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 20))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/ultimo_ticket.png"),
      ),
      //image: Image.asset("img/ultimo_ticket.png"),
    ).show();
  }

  void reporteDeldia(BuildContext context, fechaactual) {
    materialAppContext = context; // Usar el contexto pasado

    Alert(
      style: alertStyle3,
      context: context,
      desc: fechaactual,

      buttons: [
        DialogButton(
            onPressed: () async {
              try {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const SpinKitDualRing(
                        color: Color.fromRGBO(19, 107, 79, 0.965),
                        size: 60.0, // ajusta el tamaño según tus necesidades
                      );
                      //return const Center(child: CircularProgressIndicator());
                    });
                // Espera 2 segundos antes de cerrar el diálogo
                //await Future.delayed(const Duration(seconds: 2));
                //Navigator.of(context, rootNavigator: true).pop();
                //Navigator.of(context).pop();
                pagar.limpiar_campos();
                pagar.listadorecibo(context, fechaactual);
              } catch (e) {
                // ignore: avoid_print
                print(e);
                sinConexion(context);
              } finally {
                Navigator.of(context, rootNavigator: true).pop();
                //Navigator.of(context)
                //    .pop(); // Cerrar el diálogo en cualquier caso
              }
            },
            color: Colors.white,
            child: const Text("Lista de recibos",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 12))),
        DialogButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                locale: const Locale("es", "ES"),
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year, 1, 1),
                lastDate: DateTime.now(),
                selectableDayPredicate: disableDate,
                barrierDismissible: false,
              );
              if (newDate != null) {
                //setState(() {
                fechaactual = DateFormat('dd-MM-yyyy').format(newDate);
                Navigator.pop(context);
                reporteDeldia(context, fechaactual);
                //fechaactual = _dateFormat.format(newDate);
                //});
                // Actualiza la descripción de la alerta usando setState
              }
            },
            color: Colors.white,
            child: const Text("Selec. el día",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 15))),
        DialogButton(
            onPressed: () {
              //Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
              pagar.limpiar_campos();
              //pagar.requestFocus(context, pagar.montoFocus);
            },
            color: Colors.white,
            child: const Text("Aceptar",
                style: TextStyle(
                    color: Color.fromRGBO(3, 134, 208, 1),
                    fontFamily: 'Capriola',
                    fontSize: 12))),
      ],
      image: Container(
        padding: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Image.asset("assets/reporte_dia.png"),
      ),
      //image: Image.asset("img/reporte_dia.png"),
    ).show();
  }
}
