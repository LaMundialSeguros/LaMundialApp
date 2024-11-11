import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Poliza.dart';
import 'package:lamundialapp/pages/Client/ClientPoliza.dart';
import 'package:lamundialapp/pages/Client/ClientVehiculosRCV.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
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


  late User user;
  late List<Poliza> polizas = [];

  // Agrega más variables según sea necesario

  // Métodos relacionados con las variables globales
  void resetVariables() {
    polizas = [];
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
bool isButtonActive = true;
bool isButtonActiveultimo = true;
bool isButtonActivedia = true;
bool isInAsyncCall = false;
var mensaje;
var datos;
int modelo = 0;
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


        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );


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
    GlobalVariables().resetVariables();
    final decoded = json.decode(response.body) as Map<Object, dynamic>;

    // ignore: avoid_print
    mensaje = decoded['message'];
    switch (mensaje) {
      case 'Login successful':

      User user = User(
          decoded['user']['id'],
          decoded['user']['username'],
          decoded['user']['cedula'],
          decoded['user']['rol']
      );

      GlobalVariables().user = user;

      for(var poliza in decoded['polizas']) {
        Poliza producto = Poliza(
            poliza['ctenedor'],
            poliza['nombre'],
            poliza['apellido'],
            poliza['xproducto'],
            poliza['nopcion'],
            poliza['xplan'],
            poliza['cramo'],
            poliza['diasMora'],
            poliza['primaExt'],
            poliza['primaLocal'],
            poliza['cnrecibo'],
            poliza['codigo']
        );
        GlobalVariables().polizas.add(producto);
      }


        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeClient(),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );


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
    return datos;
    /*Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ServicesClient(datos),
      ),
          (route) =>
      false, // Elimina todas las rutas existentes en la pila
    );*/

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
      true, // Elimina todas las rutas existentes en la pila
    );

  } catch (e) {
    // ignore: avoid_print
    print(e);
    //alertas.sinConexion(context);
  }
}

Future<dynamic> apiServiceOptions(context,int codigo) async {
  try {
    final response = await http.post(
      Uri.parse('https://lmchat.lamundialdeseguros.com/services-options'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "codigo": codigo
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;

    datos = decoded['Servicios'];

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ClientPoliza(datos),
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


