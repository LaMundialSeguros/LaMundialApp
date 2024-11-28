// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
//import 'package:lamundialapp/components/square_tile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/bannerAdmin.dart';
import 'package:lamundialapp/pages/ForgotPassword.dart';
import 'package:lamundialapp/pages/Productor/RegisterProductor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:unique_identifier/unique_identifier.dart';

import '../components/banner.dart';
import '../components/logo.dart';

final localAuth = LocalAuthentication();

class LoginPage extends StatefulWidget {
  final selectedRol;
  const LoginPage(this.selectedRol,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final username = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  FocusNode usernameCodeFocus = FocusNode();
  FocusNode passwordCodeFocus = FocusNode();

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
      if (username.text.isEmpty || password.text.isEmpty) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      // Aquí, además de hacer la consulta del usuario, también almacenas las credenciales
      await apiConsultaUsuario(context, username.text, password.text, widget.selectedRol.id);
      almacenarCredenciales(username.text, password.text);

      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> BannerRol() async {
    try {
        // Validar campos nulos
        if (widget.selectedRol.id == 1) {

        }else{

        }
      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
    }
  }

// Crear una instancia de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
// Función para almacenar las credenciales de manera segura
  Future<void> almacenarCredenciales(String username, String password) async {
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: password);
  }

// Función para recuperar el nombre de usuario almacenado
  Future<String?> obtenerUsuarioAlmacenado() async {
    return await _secureStorage.read(key: 'username');
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
      if (username.text != '' && password.text != '') {
        // Utiliza las credenciales almacenadas para la autenticación
        almacenarCredenciales(username.text, password.text);
        // ignore: use_build_context_synchronously
        await apiConsultaUsuario(context, username.text, password.text, widget.selectedRol.id);
        username.text = '';
        password.text = '';
      } else {
        // Intenta obtener las credenciales almacenadas
        String? storedUsername = await obtenerUsuarioAlmacenado();
        String? storedPassword = await obtenerPasswordAlmacenada();

        if (storedUsername != null && storedPassword != null) {
          // Utiliza las credenciales almacenadas para la autenticación
          // ignore: use_build_context_synchronously
          await apiConsultaUsuario(context, storedUsername, storedPassword, widget.selectedRol.id);
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
          backgroundColor: Color.fromRGBO(15, 26, 90, 1),
          title: LogoWidget(),
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

    // Expresión regular para validar el correo electrónico
    bool _isValidEmail(String email) {
      final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailRegex.hasMatch(email);
    }

    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(children: [
          if (widget.selectedRol.id == 1) const BannerWidgetAdmin(),
          if (widget.selectedRol.id == 2) const BannerWidget(),
          //Text(widget.selectedRol.name),
          const SizedBox(height: 50),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.zero,
                  topRight:  Radius.circular(40.0),
                  bottomLeft:  Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
            ),
            child: TextField(
              controller: username,
              focusNode: usernameCodeFocus,
              style: const TextStyle(
                color: Colors.black, // Color del texto
                fontFamily: 'Poppins',
                // Otros estilos de texto que desees aplicar
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese su usuario',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    '', // Ruta de tu archivo SVG
                    colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(105, 111, 140, 1), BlendMode.srcIn),
                    width: 20, // Tamaño deseado en ancho
                    height: 18,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12.0,
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
          const SizedBox(height: 20),
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
                      hintStyle: TextStyle(
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
          const SizedBox(height: 15),
          Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                          },
                          child: Text(
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
          const SizedBox(height: 30),
          Container(
            width: 380,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    usernameCodeFocus.unfocus();
                    passwordCodeFocus.unfocus();
                    // Realiza la validación cuando el usuario presione el botón
                    if (!_isValidEmail(username.text)) {
                      // Correo inválido
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correo inválido')),
                      );
                    }else{
                      signUserIn();
                    }
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
                // if (isLoading)
                //   Positioned(
                //     left: 100,
                //     child: Container(
                //       margin: const EdgeInsets.only(left: 8),
                //       child: const SpinKitDualRing(
                //         color: Color.fromRGBO(76, 182, 149, 0.965),
                //         size: 60.0,
                //       ),
                //       // const CircularProgressIndicator(
                //       //   valueColor: AlwaysStoppedAnimation<Color?>(
                //       //     Color.fromARGB(179, 255, 255, 255),
                //       //   ),
                //       // ),
                //     ),
                //   ),
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
                            Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterProductorPage()));
                          },
                          child: Text(
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
          const SizedBox(height: 20),
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
