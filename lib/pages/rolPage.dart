// ignore_for_file: avoid_print, unused_field, avoid_init_to_null, non_constant_identifier_names, sort_child_properties_last, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/rolBanner.dart';
import 'package:lamundialapp/pages/loginPageClient.dart';
import 'package:lamundialapp/pages/login_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/logo.dart';

final localAuth = LocalAuthentication();

class RolPage extends StatefulWidget {
  const RolPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  RolPageState createState() => RolPageState();
}

class RolPageState extends State<RolPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final rol = TextEditingController();
  bool isLoading = false;
  FocusNode rolCodeFocus = FocusNode();
  var selectedRol = null;


  List<Rol> Roles = [
    //Rol('Ejecutivo', 1),
    Rol('Productor', 2),
    //Rol('Asegurado', 3),
  ];


  Future<void> signUserIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar campos nulos
      if (selectedRol == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      if(selectedRol.id == 3){
        Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPageClient(selectedRol)));
      }else{
        Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage(selectedRol)));
      }

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
          backgroundColor: const Color.fromRGBO(15, 26, 90, 1),
          title: const LogoWidget(),
        ),
        ),
        preferredSize: const Size.fromHeight(150),
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
          const RolBannerWidget(),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(// Color de fondo gris
                borderRadius: const BorderRadius.only(
                  topLeft:  Radius.zero,
                  topRight:  Radius.circular(40.0),
                  bottomLeft:  Radius.circular(40.0),
                  bottomRight: Radius.zero,
            ),
            border: Border.all(
                color: const Color.fromRGBO(79, 127, 198, 1),
            )),
            child: DropdownButtonFormField<Rol>(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedRol,
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (Rol? newValue) {
                        setState(() {
                          selectedRol = newValue;
                        });
                      },
                      items: Roles.map((Rol rol) {
                        return DropdownMenuItem<Rol>(
                          value: rol,
                          child: Text(rol.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          hintText: 'Seleccione su Rol',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                          suffixIcon: Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: const Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                      ),
                    ),
          ),
          const SizedBox(height: 30),
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
                    signUserIn();
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
                    'Ingresar',
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
          
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          const SizedBox(height: 150),
          Container(

                    //padding: EdgeInsets.symmetric(horizontal: 0),
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
                    //padding: EdgeInsets.symmetric(horizontal: 0),
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
                    //padding: EdgeInsets.symmetric(horizontal: 0),
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

class Rol {
  final String name;
  final int id;

  Rol(this.name, this.id);
}
