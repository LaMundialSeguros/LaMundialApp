// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:lamundialapp/Utilidades/scanqr.dart';
import 'package:lamundialapp/pages/lista_recibo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:lamundialapp/Alertas/alertaspos.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

//Definición de variables
var cedulaFormatter =
    MaskTextInputFormatter(mask: '#########', filter: {"#": RegExp(r'[0-9]')});

var dosfaFormatter =
    MaskTextInputFormatter(mask: '######', filter: {"#": RegExp(r'[0-9]')});
var balances = 0;
final cedula = TextEditingController();
final monto =
    MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
final montoHintController = TextEditingController();
final dosfa = TextEditingController();
String cadena = '';
String ced = '';
var txid = 0;
var fecha = '';
var mon = '';
var displayBalance = '';
bool isButtonActive = true;
bool isButtonActiveultimo = true;
bool isButtonActivedia = true;
bool isInAsyncCall = false;
var nombrecomercial = '';
var marca = '';
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

//Instancia de pagar
//pagarState pagar = pagarState();
AlertaState alertas = AlertaState();
//Fin de Instancia

// Función para desencriptar la marca con Base64
String desencriptarMarca(String marcaEncriptada) {
  List<int> marcaBytes = base64.decode(marcaEncriptada);
  String marcaDesencriptada = utf8.decode(marcaBytes);
  return marcaDesencriptada;
}

String desencriptarCampo(String codigoCifrado, String clave, String iv) {
  final key = encrypt.Key.fromUtf8(clave);
  final ivParameter = encrypt.IV.fromBase64(iv);

  // Decodificar el código cifrado desde base64
  final codigoCifradoBytes = base64.decode(codigoCifrado);

  // Crear un cifrador con el algoritmo AES y el modo CBC
  final encrypter = encrypt.Encrypter(
    encrypt.AES(
      key,
      mode: encrypt.AESMode.cbc,
    ),
  );

  // Desencriptar los datos
  final codigoDesencriptadoBytes = encrypter.decryptBytes(
    encrypt.Encrypted(codigoCifradoBytes),
    iv: ivParameter,
  );

  // Devolver el resultado como una cadena UTF-8
  return utf8.decode(codigoDesencriptadoBytes);
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const SpinKitDualRing(
        color: Color.fromRGBO(19, 107, 79, 0.965),
        size: 60.0,
      );
    },
  );
}

void closeLoadingDialog(BuildContext context) {
  // Cierra el diálogo después de 2 segundos
  Navigator.of(context, rootNavigator: true).pop();
}

Future<void> apiEstablecimiento(context, String serial) async {
  try {
    // Encriptar el serial usando Base64
    final encryptedSerial = base64.encode(utf8.encode(serial));

    final response = await http.post(
      Uri.parse('https://test-pos.crixto.org/funcion-establecimiento'),
      //Uri.parse('https://node-pos.crixto.org/funcion-establecimiento'),
      //Uri.parse('https://pos.crixto.io/funcion-establecimiento'),

      //Uri.parse('https://pos.crixto.io/funcion-establecimiento'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Enviar el valor encriptado en lugar del original
      body: jsonEncode(<String, String>{'serial': encryptedSerial}),
    );

    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    nombrecomercial = decoded['nombrecomercial'];
    rif = decoded['rif'];
    pagar.limpiar_campos();
    modelo = decoded['modelo'];
  } catch (e) {
    print(e);
    alertas.sinConexion(context);
  }
}

Future<void> apiUltimorecibo(context, String serial, String fechaactual) async {
  try {
    final responsesecret = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-secretaes'),
      Uri.parse('https://node-pos.crixto.org/funcion-secretaes'),
      //Uri.parse('https://pos.crixto.io/funcion-secretaes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final decodedsecret =
        json.decode(responsesecret.body) as Map<Object, dynamic>;

    marca = desencriptarMarca(decodedsecret['marca']);
    final key = encrypt.Key.fromUtf8(marca);

    final iv = encrypt.IV.fromLength(16);
    // Convierte el IV a una lista de enteros
    final ivList = iv.bytes;

    // Crea el cifrador AES
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    // Cifrado de variables
    final encryptedSerial = encrypter.encrypt(serial, iv: iv);
    // Fin de cifrado

    final response = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-ultimorecibo'),
      Uri.parse('https://node-pos.crixto.org/funcion-ultimorecibo'),
      //Uri.parse('https://pos.crixto.io/funcion-ultimorecibo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'serial': encryptedSerial.base64, 'iv': ivList}),
    );

    if (response.body != '[]') {
      final decoded = json.decode(response.body) as Map<Object, dynamic>;
      ultimotxnid = decoded['txnid'];
      ultimafecha = decoded['fecha'];
      //ultimafecha = DateFormat('dd-MM-yyyy hh:mm:ss a')
      //    .format(DateTime.parse(decoded['fecha']));
      ultimomontopago = decoded['montopago'];
      ultimouser = decoded['email'];
      // ignore: use_build_context_synchronously
      alertas.ultimoRecibo(
          context, ultimotxnid, ultimafecha, ultimomontopago, ultimouser);
    } else {
      // ignore: use_build_context_synchronously
      alertas.noVer(context);
    }
  } catch (e) {
    print(e);
    // ignore: use_build_context_synchronously
    alertas.sinConexion(context);
  }
}

Future<void> apiListadorecibo(
    context, String serial, String fechaactual) async {
  try {
    final completer = Completer<void>();
    final responsesecret = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-secretaes'),
      Uri.parse('https://node-pos.crixto.org/funcion-secretaes'),
      //Uri.parse('https://pos.crixto.io/funcion-secretaes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final decodedsecret =
        json.decode(responsesecret.body) as Map<Object, dynamic>;
    marca = desencriptarMarca(decodedsecret['marca']);

    final key = encrypt.Key.fromUtf8(marca);

    final iv = encrypt.IV.fromLength(16);
    // Convierte el IV a una lista de enteros
    final ivList = iv.bytes;

    // Crea el cifrador AES
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    // Cifrado de variables
    final encryptedSerial = encrypter.encrypt(serial, iv: iv);
    // Fin de cifrado

    showLoadingDialog(context);

    final response = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-listadorecibomovil'),
      Uri.parse('https://node-pos.crixto.org/funcion-listadorecibo'),
      //Uri.parse('https://pos.crixto.io/funcion-listadorecibo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'serial': encryptedSerial.base64,
        'fechaactual': fechaactual,
        'iv': ivList
      }),
    );

    closeLoadingDialog(context);

    if (response.body != '[]') {
      print(response);
      final decoded = json.decode(response.body) as List<dynamic>;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Lrecibo(listaRecibo: decoded),
          // Pasa la lista de datos
        ),
      );

      print(decoded);
      completer.complete();
    } else {
      //Navigator.of(context, rootNavigator: true).pop();
      await alertas.noVer(context);
      //return List<dynamic>.empty();
    }
  } catch (e) {
    //Navigator.of(context, rootNavigator: true).pop();
    await alertas.sinConexion(context);
    //return List<dynamic>.empty();
  }
}

Future<void> apiProcesoPagarQR(
    cedularif, tokens, serial, context, tipopago) async {
  try {
    final responsesecret = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-secretaes'),
      Uri.parse('https://node-pos.crixto.org/funcion-secretaes'),
      //Uri.parse('https://pos.crixto.io/funcion-secretaes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final decodedsecret =
        json.decode(responsesecret.body) as Map<Object, dynamic>;
    marca = desencriptarMarca(decodedsecret['marca']);

    final key = encrypt.Key.fromUtf8(marca);
    final iv = encrypt.IV.fromLength(16);

    // Convierte el IV a una lista de enteros
    final ivList = iv.bytes;

    // Crea el cifrador AES
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // Cifrado de variables
    final encryptedSerial = encrypter.encrypt(serial, iv: iv);
    final encryptedCedula = encrypter.encrypt(cedularif, iv: iv);
    final encryptedMonto = encrypter.encrypt(monto.text, iv: iv);
    final encryptedTokens = encrypter.encrypt(tokens, iv: iv);
    // Fin de cifrado

    final response = await http.post(
      Uri.parse('https://test-pos.crixto.org/funcion-pagoqr'),
      //Uri.parse('https://node-pos.crixto.org/funcion-pagoqr'),
      //Uri.parse('https://pos.crixto.io/funcion-pagoqr'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cedula': encryptedCedula.base64,
        'monto': encryptedMonto.base64,
        'tokens': encryptedTokens.base64,
        'serial': encryptedSerial.base64,
        'iv': ivList,
        'tipopago': tipopago
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    // ignore: invalid_use_of_protected_member
    //pagar.setState(() {
    switch (decoded['msg']) {
      case 'El usuario no existe':
      case '2fa_errado':
        //alertas.qrNovalido(context);
        spinerState.setAlerta('qrnovalido');
        //Alertas.qrnovalido(context);
        break;
      case -9000:
      case 200001054:
      case 225022:
      case 'Monto_errado':
        alertas.montoErrado(context);
        break;
      case 'Sin_saldo':
        spinerState.setAlerta('sinsaldo');
        //alertas.sinsaldo(context);
        break;
      case 'Sesion Vencida':
        spinerState.setAlerta('sesionvencida');
        //alertas.sinsaldo(context);
        break;
    }
    if (decoded['txnId'] != null) {
      //fecha = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
      fecha = decoded['fecha'];
      txid = decoded['txnId'];
      //alertas.success(context);
      spinerState.setAlerta('exitoso');
    }
    //});
  } catch (e) {
    // ignore: use_build_context_synchronously
    spinerState.setAlerta('sesionvencida');
  }
}

Future<void> apiProcesoPagar(serial, context, tipopago) async {
  try {
    final responsesecret = await http.post(
      //Uri.parse('https://test-pos.crixto.org/funcion-secretaes'),
      Uri.parse('https://node-pos.crixto.org/funcion-secretaes'),
      //Uri.parse('https://pos.crixto.io/funcion-secretaes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final decodedsecret =
        json.decode(responsesecret.body) as Map<Object, dynamic>;
    marca = desencriptarMarca(decodedsecret['marca']);

    final key = encrypt.Key.fromUtf8(marca);
    final iv = encrypt.IV.fromLength(16);

    // Convierte el IV a una lista de enteros
    final ivList = iv.bytes;

    // Crea el cifrador AES
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // Cifrado de varables
    final encryptedSerial = encrypter.encrypt(serial, iv: iv);
    final encryptedCedula = encrypter.encrypt(cedula.text, iv: iv);
    final encryptedMonto = encrypter.encrypt(monto.text, iv: iv);
    final encryptedDosfa = encrypter.encrypt(dosfa.text, iv: iv);
    // Fin de cifrado
    final response = await http.post(
      Uri.parse('https://test-pos.crixto.org/funcion-pago'),
      //Uri.parse('https://node-pos.crixto.org/funcion-pago'),
      //Uri.parse('https://pos.crixto.io/funcion-pago'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cedula': encryptedCedula.base64,
        'monto': encryptedMonto.base64,
        'dosfa': encryptedDosfa.base64,
        'serial': encryptedSerial.base64,
        'iv': ivList,
        'tipopago': tipopago
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    // ignore: invalid_use_of_protected_member
    //pagar.setState(() {
    switch (decoded['msg']) {
      case 'El usuario no existe':
      case '2fa_errado':
        alertas.usuarioNoexiste(context);
        break;
      case -9000:
      case 200001054:
      case 225022:
      case 'Monto_errado':
        alertas.montoErrado(context);
        break;
      case 'Sin_saldo':
        //print('pase');
        alertas.sinsaldo(context);
        break;
    }
    if (decoded['txnId'] != null) {
      //fecha = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
      fecha = decoded['fecha'];
      txid = decoded['txnId'];
      alertas.success(context);
    }
    //});
  } catch (e) {
    print(e);
    // ignore: use_build_context_synchronously
    alertas.sinConexion(context);
  }
}
