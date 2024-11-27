// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
//import 'package:lamundialapp/components/square_tile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/rolBanner.dart';
import 'package:lamundialapp/pages/loginPageClient.dart';
import 'package:lamundialapp/pages/login_page.dart';
import 'package:lamundialapp/pages/secretCode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:unique_identifier/unique_identifier.dart';

import '../components/banner.dart';
import '../components/logo.dart';

final localAuth = LocalAuthentication();

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final rol = TextEditingController();
  bool isLoading = false;
  FocusNode rolCodeFocus = FocusNode();
  var selectedMethod = null;


  List<Method> methods = [
    Method('Correo', 1),
    Method('Teléfono', 2)
  ];


  Future<void> ForgotPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar campos nulos
      if (selectedMethod == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      print("Enviar condigo al metodo indicado...");
      Navigator.push(context,MaterialPageRoute(builder: (context) => SecretCodePage()));
      // Resto del código...
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
        child: AppBar(
          //toolbarHeight: 50,
          backgroundColor: Color.fromRGBO(15, 26, 90, 1),
          title: LogoWidget(),
        ),
        ),
        preferredSize: Size.fromHeight(150),
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
            height: 40,
            decoration: BoxDecoration(// Color de fondo gris
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.zero,
                  topRight:  Radius.circular(40.0),
                  bottomLeft:  Radius.circular(40.0),
                  bottomRight: Radius.zero,
            ),
            border: Border.all(
                color: Color.fromRGBO(79, 127, 198, 1),
            )),
            child: DropdownButtonFormField<Method>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedMethod,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (Method? newValue) {
                        setState(() {
                          selectedMethod = newValue;
                        });
                      },
                      items: methods.map((Method method) {
                        return DropdownMenuItem<Method>(
                          value: method,
                          child: Text(method.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          hintText: 'Método de Autenticación',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                          suffixIcon: Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                      ),
                    ),
          ),
          Center(
            child: Text(
              'Luego de seleccionar un método le será enviado \n'
                  '          un código para verificar su identidad.',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(121, 116, 126, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins')
              ),
          ),
          const SizedBox(height: 150),
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
                    ForgotPassword();
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
                    'Enviar Código',
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
          const SizedBox(height: 150),
          Container(

                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
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
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
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
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
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

class Method {
  final String name;
  final int id;

  Method(this.name, this.id);
}
