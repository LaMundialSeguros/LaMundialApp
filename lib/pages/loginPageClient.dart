// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, avoid_init_to_null, non_constant_identifier_names, sort_child_properties_last, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/bannerClient.dart';
import 'package:lamundialapp/pages/Client/RegisterClient.dart';
import 'package:lamundialapp/pages/ForgotPassword.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Utilidades/Class/TypeDoc.dart';
import '../components/logo.dart';

final localAuth = LocalAuthentication();

class LoginPageClient extends StatefulWidget {
  final selectedRol;
  const LoginPageClient(this.selectedRol,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  LoginPageClientState createState() => LoginPageClientState();
}

class LoginPageClientState extends State<LoginPageClient> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final cedula = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  FocusNode cedulaCodeFocus = FocusNode();
  FocusNode passwordCodeFocus = FocusNode();
  var typeDoc = null;

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];

  Future<Uint8List> _loadImage() async {
    List<BiometricType> availableBiometrics = [];
    availableBiometrics = await _localAuthentication.getAvailableBiometrics();
    bool isFaceIdAvailable = availableBiometrics.contains(BiometricType.face);
    if (isFaceIdAvailable) {
      final ByteData data = await rootBundle.load('lib/images/face.gif');
      //String? uuid = await UniqueIdentifier.serial;
      //print(uuid);
      return data.buffer.asUint8List();
    } else {
      final ByteData data = await rootBundle.load('assets/huella.png');
      return data.buffer.asUint8List();
    }
  }

  Future<void> signUserIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar campos nulos
      if (cedula.text.isEmpty || password.text.isEmpty) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      if (typeDoc == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      // Aquí, además de hacer la consulta del usuario, también almacenas las credenciales
      await apiConsultaUsuarioCliente(context, cedula.text, password.text, widget.selectedRol.id);
      almacenarCredenciales(cedula.text, password.text);

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
// Función para almacenar las credenciales de manera segura
  Future<void> almacenarCredenciales(String cedula, String password) async {
    await _secureStorage.write(key: 'cedula', value: cedula);
    await _secureStorage.write(key: 'password', value: password);
    await _secureStorage.write(key: 'rol', value: widget.selectedRol.id);
  }

// Función para recuperar el nombre de usuario almacenado
  Future<String?> obtenerUsuarioAlmacenado() async {
    return await _secureStorage.read(key: 'cedula');
  }
// Función para recuperar la contraseña almacenada
  Future<String?> obtenerPasswordAlmacenada() async {
    return await _secureStorage.read(key: 'password');
  }

// Método para mostrar el diálogo de confirmación de autenticación biométrica
  Future<void> mostrarDialogoAutenticacionBiometrica() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AUTENTICACIÓN...'),
          content: const Text(
              '¿Deseas utilizar la autenticación biométrica para iniciar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Llamar a la función de autenticación biométrica
                _authenticate();
              },
              child: const Text('SÍ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                // Puedes realizar alguna otra acción o simplemente no hacer nada
              },
              child: const Text('NO'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Coloque su huella para ingresar a LA MUNDIAL',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: false,
          sensitiveTransaction: false,
          biometricOnly: true,
        ),
        // options: const AuthenticationOptions(stickyAuth: true),
      );
    } catch (e) {
      print('Error en la autenticación biométrica: $e');
    }

    if (authenticated) {
      if (cedula.text != '' && password.text != '') {
        // Utiliza las credenciales almacenadas para la autenticación
        almacenarCredenciales(cedula.text, password.text);
        // ignore: use_build_context_synchronously
        await apiConsultaUsuarioCliente(context, cedula.text, password.text, widget.selectedRol.id);
        cedula.text = '';
        password.text = '';
      } else {
        // Intenta obtener las credenciales almacenadas
        String? storedCedula = await obtenerUsuarioAlmacenado();
        String? storedPassword = await obtenerPasswordAlmacenada();

        if (storedCedula != null && storedPassword != null) {
          // Utiliza las credenciales almacenadas para la autenticación
          // ignore: use_build_context_synchronously
          await apiConsultaUsuarioCliente(context, storedCedula, storedPassword, widget.selectedRol.id);
        } else {
          // Si no hay credenciales almacenadas, muestra un mensaje o realiza alguna acción adicional.
          // ignore: use_build_context_synchronously
          await alertas.usuarioNoexiste(context);
          // await alertas.usuarioNoexiste(context);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
        child: AppBar(
          //toolbarHeight: 50,
          backgroundColor: const Color.fromRGBO(15, 26, 90, 1),
          title: const LogoWidget(),
          leading: IconButton(
            icon: Image.asset(
              'assets/return.png', // Reemplaza con la ruta de tu imagen
              height: 40,
            ), // Reemplaza con tu icono deseado
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
          const BannerWidgetClient(),
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ASEGURADO',
                          style: TextStyle(
                              fontSize: 34,
                              color: Color.fromRGBO(15, 26, 90, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          Padding(
            padding: const EdgeInsets.only(left: 50,right: 0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(// Color de fondo gris
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(30.0),
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      )),
                  child: DropdownButtonFormField<TypeDoc>(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    iconSize: 0,
                    value: typeDoc,
                    borderRadius: const BorderRadius.only(
                      topLeft:  Radius.zero,
                      topRight:  Radius.circular(30.0),
                      bottomLeft:  Radius.circular(30.0),
                      bottomRight: Radius.zero,
                    ),
                    onChanged: (TypeDoc? newValue) {
                      setState(() {
                        typeDoc = newValue;
                      });
                    },
                    items: TypeDocs.map((TypeDoc tipoDoc) {
                      return DropdownMenuItem<TypeDoc>(
                        value: tipoDoc,
                        child: Text(tipoDoc.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 35),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      suffixIcon: Container(
                        padding: const EdgeInsets.only(right: 0),
                        child: const Icon(Icons.keyboard_arrow_down_outlined),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                    ],
                    controller: cedula,
                    focusNode: cedulaCodeFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Cédula de Identidad',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle:
                          TextStyle(
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: password,
                            focusNode: passwordCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingrese su contraseña',
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  '', // Ruta de tu archivo SVG
                                  colorFilter: const ColorFilter.mode(
                                      Color.fromRGBO(121, 116, 126, 1),
                                      BlendMode.srcIn),
                                  width: 20, // Tamaño deseado en ancho
                                  height: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(121, 116, 126, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            obscureText: !showPassword,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
          const SizedBox(height: 10),
          Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                          },
                          child: const Text(
                            '¿Olvidó su contraseña? Click aquí.',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ),
          const SizedBox(height: 20),
          const SizedBox(height: 15),
          const SizedBox(height: 20),
          Container(
            width: 380,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cedulaCodeFocus.unfocus();
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
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const RegisterClientPage()));
                          },
                          child: const Text(
                            '¿No tiene una cuenta? Cree una.',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ),
          const SizedBox(height: 20),
          FutureBuilder<Uint8List>(
                    future: _loadImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.blue,width: 2),
                          ),
                          child: IconButton(
                            icon: Image.memory(
                              snapshot.data!,
                              width: 60, // Puedes ajustar el ancho según tus necesidades
                              height:
                              80, // Puedes ajustar la altura según tus necesidades
                            ),
                            onPressed: () async {
                              // Lógica para la autenticación biométrica
                              bool canUseBiometrics = await localAuth.canCheckBiometrics;
                              if (canUseBiometrics) {
                                setState(() {
                                  isLoading = true;
                                });
                                await _authenticate();
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                await mostrarDialogoAutenticacionBiometrica();
                              }
                            },
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
          const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
        ]))));
  }
}