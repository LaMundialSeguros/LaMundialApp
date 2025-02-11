// ignore_for_file: avoid_print, camel_case_types, unused_field, avoid_init_to_null, non_constant_identifier_names, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/segmentedInput.dart';
import 'package:lamundialapp/pages/newPassword.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Utilidades/Class/Method.dart';

final localAuth = LocalAuthentication();

class SecretCodePage extends StatefulWidget {
  const SecretCodePage({Key? key}) : super(key: key);

  @override
  secretCodePageState createState() => secretCodePageState();
}

class secretCodePageState extends State<SecretCodePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final rol = TextEditingController();
  bool isLoading = false;
  FocusNode rolCodeFocus = FocusNode();
  var selectedMethod = null;


  List<Method> methods = [
    Method('Correo', 1),
    Method('Telefono', 2)
  ];


  Future<void> ConfirmCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar campos nulos
      Navigator.push(context,MaterialPageRoute(builder: (context) => const NewPasswordPage()));
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Crear una instancia de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 50,
        backgroundColor: const Color.fromRGBO(15, 26, 90, 1),
        title: const Text(
                  "CAMBIAR CONTRASEÑA",
                  style: TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'
                          )
                  ),
        leading: IconButton(
          icon: Image.asset(
            'assets/return.png', // Reemplaza con la ruta de tu imagen
            height: 40,
          ), // Reemplaza con tu icono deseado
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),/*AppBar(

      )*/
      body: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(0),
              child: Builder(
                  builder: (BuildContext context) {
                  return buildForm(context); // Pasa el contexto obtenido
                },
              ),
              //buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 200),
          Container(
            width: 300,
            height: 100,
            child: SegmentedInput(
                      numberOfSegments: 6, // Por ejemplo, para un código de 6 dígitos
                      controller: codeController,
                    ),
          ),
          const Center(
            child: Text(
              '  Introduzca el código enviado \na su [método de autentificación]',
              style: TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(121, 116, 126, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins')
              ),
          ),
          const SizedBox(height: 100),
          Container(
            width: 380,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    rolCodeFocus.unfocus();
                    //print(selectedRol.name);
                    ConfirmCode();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color.fromRGBO(232, 79, 81, 1),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          Container(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'La Mundial de Seguros C.A. RIF: J-00084644-8',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          Container(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Inscrita en la Superintendencia de la Actividad Aseguradora bajo el No. 73 ',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          Container(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Todos los derechos reservados.',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
        ]))));
  }
}