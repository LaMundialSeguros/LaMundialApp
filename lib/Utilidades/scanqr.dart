// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:lamundialapp/Negocio/pagar.dart';

class AppState {
  bool showPayButton = false;
  bool isCameraInitialized = false;

  void setShowPayButton(bool value) {
    showPayButton = value;
  }

  bool getShowPayButton() {
    return showPayButton;
  }

  void setCamera(bool value) {
    isCameraInitialized = value;
  }

  bool getCamera() {
    return isCameraInitialized;
  }
}

class SpinerState {
  late String alertaValue;

  void setAlerta(String value) {
    alertaValue = value;
  }

  String getAlerta() {
    return alertaValue;
  }
}

final appState = AppState();
final spinerState = SpinerState();

class QRViewExample extends StatefulWidget {
  final String selectedCurrency;
  const QRViewExample({Key? key, required this.selectedCurrency})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => QRViewExampleState();
}

class QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  bool isInAsyncCall = false;
  static QRViewController? globalController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showPayButton = false;

  void disposeCamera() {
    globalController?.dispose();
    setState(() {
      appState.setCamera(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isInAsyncCall,
        opacity: 0.0,

        // progressIndicator: const CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),

        progressIndicator: const SpinKitDualRing(
          color: Color.fromRGBO(50, 110, 91, 0.965),
          size: 60.0, // ajusta el tamaño según tus necesidades
        ),

        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Colors.black, // Establece el color de fondo a negro
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Visibility(
                        visible: appState.getShowPayButton(),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () {
                              _handleScanButtonPress();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              textStyle: const TextStyle(fontSize: 10),
                              minimumSize: const Size(30, 0),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Escanear',
                                style: TextStyle(
                                    color: Color.fromRGBO(3, 134, 208, 1),
                                    fontFamily: 'Capriola',
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: appState.getShowPayButton(),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () {
                              _handlePayButtonPress();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              backgroundColor: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(3, 134, 208, 1)),
                              minimumSize: const Size(30, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Pagar',
                                style: TextStyle(
                                    color: Color.fromRGBO(3, 134, 208, 1),
                                    fontFamily: 'Capriola',
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            appState.setShowPayButton(false);
                            appState.setCamera(false);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            textStyle: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            minimumSize: const Size(30, 0),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Aceptar',
                              style: TextStyle(
                                  color: Color.fromRGBO(3, 134, 208, 1),
                                  fontFamily: 'Capriola',
                                  fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Nueva función para manejar el clic en el botón de escanear
  void _handleScanButtonPress() {
    globalController?.resumeCamera();
    setState(() {
      appState.setShowPayButton(false);
    });
  }

  // Nueva función para manejar el clic en el botón de pagar
  Future<void> _handlePayButtonPress() async {
    final qrCode = result?.code ?? "";
    final pagarQR = pagarState();

    setState(() {
      // Muestra el spinner al hacer clic en pagar
      isInAsyncCall = true;
      appState.setShowPayButton(false);
    });

    //Future.delayed(const Duration(seconds: 2),() async {
    //setState(() async {
    try {
      //if (widget.selectedCurrency == 'USDT.') {
      await pagarQR
          .procesoPagarQR(context, qrCode, widget.selectedCurrency)
          .then((_) {
        var alerta = spinerState.getAlerta();
        switch (alerta) {
          case 'qrnovalido':
            alertas.qrNovalido(context).then((_) {
              setState(() {
                isInAsyncCall = false;
              });
            });
            break;
          case 'exitoso':
            alertas.success(context).then((_) {
              setState(() {
                isInAsyncCall = false;
              });
            });
            break;
          case 'sinconexion':
            alertas.sinConexion(context).then((_) {
              setState(() {
                isInAsyncCall = false;
                //Navigator.of(context).popUntil((route) => route.isFirst);
              });
            });
            break;
          case 'sinsaldo':
            alertas.sinsaldo(context).then((_) {
              setState(() {
                isInAsyncCall = false;
              });
            });
            break;
          case 'sesionvencida':
            alertas.sesionvencida(context).then((_) {
              setState(() {
                isInAsyncCall = false;
              });
            });
            break;
        }
      });
      // } else {
      //   alertas.sinArchivo(context);
      // }
    } catch (e) {
      // ignore: use_build_context_synchronously
      alertas.sinConexion(context).then((_) {
        setState(() {
          isInAsyncCall = false;
        });
      });
    }
    //});
    //  },
    //);
  }

  @override
  void initState() {
    super.initState();

    result = null;
    appState.setShowPayButton(false);
  }

  setGlobalController(QRViewController controller) {
    globalController = controller;
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    print('onQRViewCreated called');
    setState(() {
      globalController = controller;
      appState.setCamera(true);
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        globalController?.pauseCamera();
        appState.setShowPayButton(true);
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    globalController?.dispose();
    super.dispose();
  }
}
