import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';

//import 'package:encrypt/encrypt.dart' as encrypt;

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  bool showQrCode = false;
  int countdown = 180; // Inicializar el contador a 180 segundos
  Timer? timer;
  late String encryptedJson = '';
  late String qrEncriptado = '';
  late String errorMensaje = '';
  bool isLoading = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'QR DE PAGO',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'Capriola',
  //         ),
  //       ),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.only(top: 1),
  //       child: ModalProgressHUD(
  //         inAsyncCall: isLoading,
  //         opacity: 0.0,
  //         progressIndicator: const SpinKitDualRing(
  //           color: Color.fromRGBO(76, 182, 149, 0.965),
  //           size: 60.0,
  //         ),
  //         child: SingleChildScrollView(
  //           child: Container(
  //             margin: const EdgeInsets.only(top: 400),
  //             padding: const EdgeInsets.all(0),
  //             child: buildForm(context),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR DE PAGO',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Capriola',
          ),
        ),
      ),
      body: Padding(
        //padding: const EdgeInsets.only(top: 0),
        padding: const EdgeInsets.all(8.0),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;
    return Container(
        color: Colors.white,
        child: Form(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (showQrCode && qrEncriptado.isNotEmpty)
                    QrImageView(
                      data: qrEncriptado,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  if (showQrCode && qrEncriptado.isNotEmpty)
                    Image.asset(
                      'lib/images/x.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                ],
              ),

              if (showQrCode && qrEncriptado.isNotEmpty)
                Text(
                  'Tiempo restante: ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: countdown <= 10 ? Colors.red : Colors.black,
                    fontFamily: 'Capriola',
                  ),
                ),

              // isLoading
              //     ? const CircularProgressIndicator(
              //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              //       );
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cancelTimer();
                    showQrCode = !showQrCode;
                    countdown = 180;
                    if (showQrCode) {
                      // Limpiar el mensaje de error al intentar generar un nuevo QR
                      qrEncriptado = '';
                      errorMensaje = '';
                      // Mostrar el indicador de carga
                      isLoading = true;

                      generarQr(1);
                      timer =
                          Timer.periodic(const Duration(seconds: 1), (Timer t) {
                        if (mounted) {
                          setState(() {
                            if (countdown > 0) {
                              countdown--;
                            } else {
                              //Rutina para quemar el token
                              generarQr(0);
                              // FIN de RUTINA
                              _cancelTimer();
                              showQrCode = false;
                            }
                          });
                        } else {
                          _cancelTimer();
                        }
                      });
                    } else {
                      generarQr(0);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  showQrCode ? 'Salir' : 'Generar QR de PAGO',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Capriola',
                  ),
                ),
              ),

              // Mostrar el mensaje de error
              if (errorMensaje.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMensaje,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold, // Hace el texto negrita
                        fontSize: 14.0,
                        fontFamily: 'Capriola',
                      ),
                    )),
              const SizedBox(height: 10.0),
            ]))));
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    timer?.cancel();
  }

  String generarTokenAleatorio() {
    final random = Random();
    return List.generate(10, (_) => random.nextInt(10)).join();
  }

  Future<void> generarQr(status) async {
    try {
      setState(() {
        isLoading = true; // Muestra el indicador de carga
      });
      if (status == 1) {
        final token = generarTokenAleatorio();
        // ignore: unnecessary_string_interpolations
        final codQr = {'cedula': GlobalVariables().user.cedula, 'token': token};
        final codQrString = json.encode(codQr);
        // Encriptar el serial usando Base64
        final encryptedQR = base64.encode(utf8.encode(codQrString));
        await apiGuardarToken(context, encryptedQR);
        qrEncriptado = encryptedQR;
      } else {
        // ignore: unnecessary_string_interpolations
        final codQr = {'cedula': '${GlobalVariables().user.cedula}', 'token': 0};
        final codQrString = json.encode(codQr);
        // Encriptar el serial usando Base64
        final encryptedQR = base64.encode(utf8.encode(codQrString));
        await apiGuardarToken(context, encryptedQR);
        qrEncriptado = encryptedQR;
      }
    } catch (error) {
      // Mostrar el mensaje de error al usuario
      setState(() {
        qrEncriptado = '';
        showQrCode = false;
        errorMensaje = 'Error al Generar QR, Por Favor Intente Nuevamente';
      });
    } finally {
      // Detener el indicador de carga, independientemente de si fue un éxito o un error
      setState(() {
        isLoading = false;
      });
    }
  }
}
