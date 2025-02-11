// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Poliza.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/notifyPayment.dart';
import 'package:lamundialapp/pages/Client/ClientPoliza.dart';
import 'package:lamundialapp/pages/Client/ClientVehiculosRCV.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/Productor/WelcomeProducer.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/pages/rolPage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:lamundialapp/Alertas/alertaspos.dart';
import 'package:lamundialapp/pages/menu_page.dart';
import 'package:crypto/crypto.dart';
import '../Utilidades/Class/User.dart';
import 'package:path/path.dart';

class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() {
    return _instance;
  }

  GlobalVariables._internal();


  late User user;
  late List<Poliza> polizas = [];

  // Métodos relacionados con las variables globales
  void resetVariables() {
    polizas = [];
    // Reinicia otras variables según sea necesario
  }
}

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
//Fin de Instancia

String obtenerFechaActual() {
  final DateTime ahora = DateTime.now();
  final DateFormat formato = DateFormat('yyyy-MM-dd'); // Cambia el formato según lo necesites
  return formato.format(ahora);
}

//Rutina para consumir la API de establecimiento
Future<void> apiConsultaUsuario(context, String usuario, String clave,int rol) async {
  try {
    final response = await http.post(
      Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/app/loginCorredor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'xcorreo': usuario,
        'xcontrasena': clave//generateMd5(clave)
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    mensaje = decoded['status'];
    var result = decoded['result'];
    switch (mensaje) {
      case true:

      // Extrae los registros
        final List<dynamic> records = decoded['result']['records'];
        int cusuario      = -1;
        String xnombre    = '';
        String xapellido  = '';
        String xlogin     = '';
        String ccorredor     = '';
        String correo     = '';
        String istatus    = '';
        for (var record in records) {
          cusuario   = record['cusuario'];
          xnombre    = record['xnombre'] ?? '';
          xapellido  = record['xapellido'] ?? '';
          xlogin     = record['xlogin'] ?? '';
          correo     = usuario;
          ccorredor  = record['ccorredor'].toString();
          istatus    = record['istatus'];
        }

        User user = User(
            cusuario,
            xnombre+""+xapellido,
            correo,
            ccorredor,
            rol
        );

        GlobalVariables().user = user;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomeProducer(url: ''),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );
        break;
      case false:
        alertas.usuarioNoexiste(context).then((_) {});
        break;
      default:
        alertas.sinConexion(context).then((_) {});
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
    }
  } catch (e) {
    const SnackBar(content: Text('Error de conecxion al cargar los datos.'));
    print(e);
    alertas.sinConexion(context);
  }
}

Future<void> apiRegisterProducer(context, Producer productor) async {
  try {
    final response = await http.post(
      Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/app/createCorredor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'xcliente': productor.name,
        'xapellido': productor.lastName,
        'xlogin': productor.email,
        'xcorreo': productor.email,
        'xcontrasena': productor.password,
        'ccorredor':productor.cedula
      }),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    mensaje = decoded['status'];
    switch (mensaje) {
      case true:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RolPage(),
          ),
              (route) =>
          false, // Elimina todas las rutas existentes en la pila
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se creo con exito el usuario')),
        );
        break;
      case false:
        alertas.sinConexion(context).then((_) {});
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        //throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
        break;
    }
  } catch (e) {
    print(e);
    alertas.sinConexion(context);
  }
}

Future<void> apiRegisterPayment(BuildContext context, NotifyPayment notifyPayment, String recibo) async {
  // URL de la API
  final url = Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/collection/receipt/admin');

  // Estructura del body
  final Map<String, dynamic> body = {
    "freporte": notifyPayment.date,//obtenerFechaActual(),
    "cmoneda_pago": notifyPayment.currency.cod,
    "ctenedor": notifyPayment.idCard,
    "mpago": double.parse(notifyPayment.amount),
    "mpagoext": 0,
    "cprog": "cobroAppMovil",
    "recibos": [ recibo ],
    "soporte": [
      {
        "cmoneda": notifyPayment.currency.cod,
        "cbanco": notifyPayment.bank.id,
        "ctipopago": notifyPayment.typePayment.id,
        "cbanco_destino": notifyPayment.bankRec.id,
        "mpago": notifyPayment.amount,
        "mpagoext": 0,
        "mpagoigtf": 0,
        "mpagoigtfext": 0,
        "mtotal": notifyPayment.amount,
        "mtotalext": "0",
        "xreferencia": notifyPayment.reference,
        "ximage": "21-2024-10-28-06545345.png" // Se debe cambiar
      }
    ]
  };

  try {
    // Realizar la solicitud POST
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json',
            'apikey': '2baed164561a8073ba1d3b45bc923e3785517b5dc0668eda178b0c87b7c3598c',
        },
      body: jsonEncode(body),
    );

    // Verificar la respuesta
    if (response.statusCode == 200) {
      
      Navigator.push(context,MaterialPageRoute(builder: (context) => const WelcomeProducer(url: '',)));

    } else {
      print('Error al enviar datos: (Este es el endpoint admin registerpayment) ${response.statusCode}');
    }
  } catch (e) {
    print('Excepción: $e');
  }
}

Future<void> sendImageToApi(context, File imageFile,String id) async {
  try {
    // URL de la API
    final Uri apiUrl = Uri.parse('https://lmchat.lamundialdeseguros.com/ftp-poliza'); // Cambia a tu API

    // Crear la solicitud multipart
    var request = http.MultipartRequest('POST', apiUrl);

    // Adjuntar el archivo de imagen al campo 'prueba'
    var fileStream = await http.MultipartFile.fromPath(
      'imagen',  // Campo esperado para la imagen
      imageFile.path,
      filename: basename(imageFile.path), // Nombre del archivo
    );

    // Agregar la imagen a la solicitud
    request.files.add(fileStream);

    // Agregar el campo 'casegurado' como un campo de texto
    request.fields['casegurado'] = id;  // Cambia por el valor real

    // Enviar la solicitud
    var response = await request.send();

    // Manejar la respuesta
    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
      var responseData = await http.Response.fromStream(response);
      print('Response: ${responseData.body}');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
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
    mensaje = decoded['message'];
    switch (mensaje) {
      case 'Login successful':

      User user = User(
          decoded['user']['id'],
          decoded['user']['username'],
          "",
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
            builder: (context) => const WelcomeClient(),
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
      case 'Server error':
        alertas.sinConexion(context).then((_) {});
        break;
    }
  } catch (e) {
    print(e);
    alertas.sinConexion(context);
  }
}


Future<void> test(context,Policy policy) async {
  try {
    final response = await http.post(
      Uri.parse('http://ncsac.test/api/testing'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(policy),
    );
    final decoded = json.decode(response.body) as Map<Object, dynamic>;
    mensaje = decoded['msg'];
    switch (mensaje) {
      case 'True':
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
          ),
        );
        break;
      case 'False':
        alertas.usuarioNoexiste(context).then((_) {
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

  } catch (e) {
    print(e);
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

    print(e);

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
    print(e);
  }
}





