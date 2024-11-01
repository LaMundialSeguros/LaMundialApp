import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/ClientVehiculosRCV.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/dosfa_page.dart';

import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

import 'package:lamundialapp/Alertas/alertaspos.dart';
import 'package:lamundialapp/pages/menu_page.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:win32/win32.dart';

import '../Utilidades/Class/User.dart';
import '../pages/Client/ServicesClient.dart';

class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() {
    return _instance;
  }

  GlobalVariables._internal();

  late String nombreUser;
  late String emailUser;
  late String avatarUser;
  late String cedulaUser;
  late String marcaUser;
  late String keyUser;
  late String secretUser;
  late int idUser;
  late bool success;
  late String message;
  late int rolUser;

  // Agrega más variables según sea necesario

  // Métodos relacionados con las variables globales
  void resetVariables() {
    nombreUser = '';
    emailUser = '';
    avatarUser = '';
    cedulaUser = '';
    marcaUser = '';
    keyUser = '';
    secretUser = '';
    idUser = 0;
    rolUser = 0;
    message = '';
    success;
    // Reinicia otras variables según sea necesario
  }
}

// Para acceder a las variables globales:
// GlobalVariables().nombreUser;
// GlobalVariables().edad;

// Para acceder a los métodos relacionados con las variables globales:
// GlobalVariables().resetVariables();

//Definición de variables
var cedulaFormatter =
    MaskTextInputFormatter(mask: '#########', filter: {"#": RegExp(r'[0-9]')});

var dosfaFormatter =
    MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});
var balances = 0;
final cedula = TextEditingController();

final dosfa = TextEditingController();
String cadena = '';
String ced = '';
var txid = 0;
var fecha = '';
var valordosfa = '';
var mon = '';
var displayBalance = '';
bool isButtonActive = true;
bool isButtonActiveultimo = true;
bool isButtonActivedia = true;
bool isInAsyncCall = false;
var mensaje;
var datos;
int modelo = 0;
var rif = '';
var ultimotxnid = '';
var ultimafecha = '';
var ultimomontopago = '';
var ultimouser = '';
var listadotxnid = '';
var listadofecha = '';
var listadomontopago = '';
var listadouser = '';
double total = 0.00;
double bur = 0;
String fechaactual = DateFormat('dd-MM-yyy').format(DateTime.now());
var coddosfa = '';
//Instancia de pagar
//pagarState pagar = pagarState();
AlertaState alertas = AlertaState();
TwoFactorAuthPageState twofa = TwoFactorAuthPageState();
//Fin de Instancia

//Rutina para consumir la API de establecimiento
Future<void> apiConsultaUsuario(context, String usuario, String clave,int rol) async {
  try {
    final response = await http.post(
      Uri.parse('https://lmchat.lamundialdeseguros.com/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': usuario,
        'password': generateMd5(clave),
        'rol': rol
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    // ignore: avoid_print
    mensaje = decoded['success'];
    switch (mensaje) {
      case 'true':
      case true:
        //var valordosfa = decoded['dosfa'];
        //coddosfa = decoded['coddosfa'];
        //GlobalVariables().message = decoded['message'];
        GlobalVariables().cedulaUser = decoded['user']['cedula'];
        GlobalVariables().emailUser = decoded['user']['username'];
        GlobalVariables().rolUser = decoded['user']['rol'];
        GlobalVariables().idUser = decoded['user']['id'];
        //GlobalVariables().avatarUser = decoded['avatar'] ?? 'No_tiene_Avatar';


        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );

        /*
          if (valordosfa == 'SI') {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TwoFactorAuthPage()),
            );
          } else {
            alertas.usuarioNoexiste(context).then((_) {});
          }
        */

        break;
      case 'clave_invalida':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'usuario_no_existe':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'sin_conexion':
        alertas.sinConexion(context).then((_) {});
        break;
      case 'datos_invalidos':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'error_inesperado':
        alertas.sinConexion(context).then((_) {});
        break;
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
    alertas.sinConexion(context);
  }
}
//Fin de Rutina
Future<void> apiConsultaUsuarioCliente(context, String cedula, String password, int rol) async {
  try {
    final response = await http.post(
      Uri.parse('https://lmchat.lamundialdeseguros.com/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cedula': cedula,
        'rol': rol
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    User user = User(
                      decoded['user']['username'],
                      decoded['user']['id']
                    );
    // ignore: avoid_print
    mensaje = decoded['success'];
    switch (mensaje) {
      case 'true':
      case true:
      //var valordosfa = decoded['dosfa'];
      //coddosfa = decoded['coddosfa'];
      //GlobalVariables().message = decoded['message'];
        GlobalVariables().cedulaUser = decoded['user']['cedula'];
        GlobalVariables().emailUser = decoded['user']['username'];
        GlobalVariables().rolUser = decoded['user']['rol'];
        GlobalVariables().idUser = decoded['user']['id'];
        //GlobalVariables().avatarUser = decoded['avatar'] ?? 'No_tiene_Avatar';



        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MenuClient(user),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );

        /*
          if (valordosfa == 'SI') {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TwoFactorAuthPage()),
            );
          } else {
            alertas.usuarioNoexiste(context).then((_) {});
          }
        */

        break;
      case 'clave_invalida':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'usuario_no_existe':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'sin_conexion':
        alertas.sinConexion(context).then((_) {});
        break;
      case 'datos_invalidos':
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      case 'error_inesperado':
        alertas.sinConexion(context).then((_) {});
        break;
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
    alertas.sinConexion(context);
  }
}
//Rutina para consumir la API del DosFA
Future<void> apiConsultaDosfa(context, String dosfa) async {
  try {
    final response = await http.post(
      Uri.parse('https://test-pos.crixto.org/funcion-consulta-dosfa'),
      //Uri.parse('https://node-pos.crixto.org/funcion-consulta-dosfa'),
      // Uri.parse('https://pos.crixto.io/funcion-consulta-dosfa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'coddosfa': coddosfa,
        'dosfa': dosfa,
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    // ignore: avoid_print
    mensaje = decoded['msg'];
    switch (mensaje) {
      case 'True':
        TwoFactorAuthPageState.twoFactorCodeController.text = '';
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
          ),
        );
        //alertas.usuarioExiste(context).then((_) {});
        break;
      case 'False':
        alertas.usuarioNoexiste(context).then((_) {
          TwoFactorAuthPageState.twoFactorCodeController.text = '';
        });
        break;
    }
  } catch (e) {
    alertas.sinConexion(context);
  }
}

String generateMd5(String input) {
  var bytes = utf8.encode(input);
  return md5.convert(bytes).toString();
}
//Fin de Rutina

//Rutina para consumir la API de Guardar TOKEN
//Future<void> apiGuardarToken(context, String qrEncriptado, marca, iv) async {
Future<void> apiGuardarToken(context, String qrEncriptado) async {
  //try {
  final response = await http.post(
    Uri.parse('https://test-pos.crixto.org/funcion-guardar-token'),
    //Uri.parse('https://node-pos.crixto.org/funcion-guardar-token'),
    //Uri.parse('https://pos.crixto.io/funcion-guardar-token'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'qr': qrEncriptado,
      //'marca': marca,
      //'iv': iv,
    }),
  );
  final decoded = json.decode(response.body) as Map<Object, dynamic>;
  // ignore: avoid_print
  mensaje = decoded['msg'];
  switch (mensaje) {
    case 'exito':
      break;
  }
  // } catch (e) {
  //   // ignore: avoid_print

  //   alertas.errorQR(context);
  // }
}
//Fin de Rutina

//Future<List<dynamic>> apiConsultServices(String cedula) async {
Future<dynamic> apiConsultServices(context,String cedula) async {
  try {
    final response = await http.post(
      Uri.parse('https://lmchat.lamundialdeseguros.com/app-services'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cedula': cedula
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;

    datos = decoded['Polizas'];

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ServicesClient(datos),
      ),
          (route) =>
      false, // Elimina todas las rutas existentes en la pila
    );

  } catch (e) {
    // ignore: avoid_print
    print(e);
    //alertas.sinConexion(context);
  }
}

Future<dynamic> apiServiceManagerRCV(context,String cedula,int codigo) async {
  try {
    final response = await http.post(
      Uri.parse('https://lmchat.lamundialdeseguros.com/services-manager'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cedula': cedula,
        "codigo": codigo
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;

    datos = decoded['Vehiculos'];

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ClientVehiculosRCV(datos),
      ),
          (route) =>
      false, // Elimina todas las rutas existentes en la pila
    );

  } catch (e) {
    // ignore: avoid_print
    print(e);
    //alertas.sinConexion(context);
  }
}


