// ignore_for_file: avoid_print

import 'dart:convert';
//import 'package:device_information/device_information.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:core';
import 'package:lamundialapp/Alertas/alertaspos.dart';
import 'package:lamundialapp/Apis/apispos.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lamundialapp/Utilidades/scanqr.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

//import 'package:unique_identifier/unique_identifier.dart';

AlertaState alertas = AlertaState();

// ignore: camel_case_types
class pagar extends StatefulWidget {
  const pagar({Key? key}) : super(key: key);
  //const MyApp({super.key});

  @override
  State<pagar> createState() => pagarState();
}

// ignore: camel_case_types
class pagarState extends State<pagar> {
  static String serial = '';
  bool isInAsyncCall = false;
  String fechaactual = DateFormat('dd-MM-yyy').format(DateTime.now());
  late FocusNode montoFocus;
  late FocusNode ceduFocus;
  late FocusNode dfaFocus;
  final GlobalKey qrKey = GlobalKey();
  TextEditingController montoController = TextEditingController();
  String selectedCurrency = 'USDT.';
//Fin de definición

//Rutina para pedir permiso al usuario
  Future<void> requestPermission() async {
    // Espera a que se otorgue el permiso
    final status = await Permission.phone.request();

    // Verifica si el permiso se otorgó
    if (status.isGranted) {
      initPlatformState();
    } else {
      dosfa.text = '';
      // ignore: use_build_context_synchronously
      initEstablecimiento();
    }
  }
//Fin de rutina de pedir permiso

// Rutina para captar el serial del dispositivo
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = '608227157116297';
      //platformVersion = await DeviceInformation.deviceIMEINumber;
      dosfa.text = platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get Device IMEI.';
    }
    if (!mounted) return;

    setState(() {
      serial = platformVersion;
    });
    initEstablecimiento();
  }

//Rutina para consumir la API de establecimiento
  Future<void> initSerialIOS() async {
    //String? serialIOS = await UniqueIdentifier.serial;
    // Asignar el valor a la variable global
    setState(() {
      limpiar_campos();
      //serial = serialIOS ?? '';
      dosfa.text = serial;
    });
    initEstablecimiento();
  }

//Fin de Rutina
//Rutina para consumir la API de establecimiento
  Future<void> initEstablecimiento() async {
    // start the modal progress HUD
    // ignore: invalid_use_of_protected_member
    isInAsyncCall = true;
    // Simulate a service call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() async {
        try {
          await apiEstablecimiento(context, serial);
          // stop the modal progress HUD
          setState(() {
            isInAsyncCall = false;
          });
        } catch (e) {
          // ignore: use_build_context_synchronously
          alertas.sinConexion(context);
        }
      });
    });
  }
//Fin de Rutina

//Rutina para consumir la API del ultimo recibo
  Future<void> ultimorecibo() async {
    try {
      await apiUltimorecibo(context, serial, fechaactual);
    } catch (e) {
      // ignore: use_build_context_synchronously
      alertas.sinConexion(context);
    }
  }
//Fin de Rutina

  Future<void> listadorecibo(BuildContext context, fecactual) async {
    try {
      // Llamada a la función sin declarar el parámetro
      //List<dynamic> resultado =
      //await apiListadorecibo(context, serial, fecactual);
      await apiListadorecibo(context, serial, fecactual);
      //print(resultado);
      // Usa 'resultado' según sea necesario
    } catch (e) {
      // ignore: use_build_context_synchronously
      alertas.sinArchivo(context);
    }
  }

  // Future<void> listadorecibo(BuildContext context, fecactual) async {
  //   try {
  //     await apiListadorecibo(context, serial, fecactual, (List<dynamic> listaRecibo));
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     alertas.sinArchivo(context);
  //   }
  // }

  Future<void> procesoPagar(context, tipopago) async {
    //Instrucción para deshabilitar el teclado
    FocusScope.of(context).unfocus();
    //Fin de instrucción de deshabilitar el teclado

    if (cedula.text == "" || monto.text == "0.00" || dosfa.text == "") {
      alertas.usuarioNoexiste(context);
    } else {
      try {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          isInAsyncCall = true;
        });
        // Espera hasta que apiProcesoPagar se complete
        await apiProcesoPagar(serial, context, tipopago);

        setState(() {
          isInAsyncCall = false;
        });
      } catch (e) {
        alertas.sinConexion(context);
      }
    }
  }

  //   Future<void> procesoPagarBs(context) async {
  //   //Instrucción para deshabilitar el teclado
  //   FocusScope.of(context).unfocus();
  //   //Fin de instrucción de deshabilitar el teclado

  //   if (cedula.text == "" || monto.text == "0.00" || dosfa.text == "") {
  //     alertas.usuarioNoexiste(context);
  //   } else {
  //     try {
  //       await Future.delayed(const Duration(seconds: 1));
  //       setState(() {
  //         isInAsyncCall = true;
  //       });
  //       // Espera hasta que apiProcesoPagar se complete
  //       await apiProcesoPagarBs(serial, context);

  //       setState(() {
  //         isInAsyncCall = false;
  //       });
  //     } catch (e) {
  //       alertas.sinConexion(context);
  //     }
  //   }
  // }

  Future<void> procesoPagarQR(
      BuildContext context, String qrCode, tipopago) async {
    //Instrucción para deshabilitar el teclado
    FocusScope.of(context).unfocus();
    //Fin de instrucción de deshabilitar el teclado
    try {
      //final qrCodeMap = json.decode(qrCode) as Map<String, dynamic>;
      // Accede a los campos del JSON
      final qrDesencriptado = utf8.decode(base64.decode(qrCode));
      final qrCodeMap = json.decode(qrDesencriptado) as Map<String, dynamic>;
      print('QR DESEMCRIPTADO: $qrCodeMap');
      final cedularif = qrCodeMap['cedula'];
      final tokens = qrCodeMap['token'];
      await apiProcesoPagarQR(cedularif, tokens, serial, context, tipopago);
    } catch (e) {
      // ignore: use_build_context_synchronously
      alertas.sinConexion(context).then((_) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  @override
  void initState() {
    montoFocus = FocusNode();
    ceduFocus = FocusNode();
    dfaFocus = FocusNode();
    super.initState();
    if (Platform.isAndroid) {
      requestPermission();
    } else {
      initSerialIOS();
    }
  }

  void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  // ignore: non_constant_identifier_names
  limpiar_campos() {
    monto.text = '0.00';
    cedula.text = '';
    dosfa.text = '';
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     body: Center(
  //       child: LoadingIndicator(
  //         indicatorType: Indicator.ballPulse, // Puedes cambiar el tipo aquí
  //         //color: Colors.blue, // Puedes ajustar el color
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ModalProgressHUD(
          inAsyncCall: isInAsyncCall,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(0),
              child: Builder(
                builder: (BuildContext context) {
                  return buildLoginForm(context); // Pasa el contexto obtenido
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: PreferredSize(
  //       preferredSize: const Size.fromHeight(0), // Ajusta la altura deseada
  //       child: AppBar(
  //         backgroundColor: Colors.blue,
  //       ),
  //     ),
  //     // display modal progress HUD (heads-up display, or indicator)
  //     // when in async call
  //     body: Padding(
  //       padding: const EdgeInsets.only(
  //           top: 1), // Ajusta la cantidad de espacio arriba
  //       child: ModalProgressHUD(
  //         inAsyncCall: isInAsyncCall,
  //         // demo of some additional parameters
  //         opacity: 0.0,
  //         //blur: bur,
  //         //progressIndicator: const CircularProgressIndicator(),
  //         progressIndicator: const SpinKitDualRing(
  //           color: Color.fromRGBO(76, 182, 149, 0.965),
  //           size: 60.0, // ajusta el tamaño según tus necesidades
  //         ),

  //         child: SingleChildScrollView(
  //           child: Container(
  //             padding: const EdgeInsets.all(0),
  //             child: buildLoginForm(context),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: PreferredSize(
  //       preferredSize: const Size.fromHeight(2), // Ajusta la altura deseada
  //       child: AppBar(
  //         backgroundColor: Colors.blue,
  //       ),
  //     ),
  //     // display modal progress HUD (heads-up display, or indicator)
  //     // when in async call
  //     body: ModalProgressHUD(
  //       inAsyncCall: isInAsyncCall,
  //       // demo of some additional parameters
  //       opacity: 0.0,
  //       //blur: bur,
  //       //progressIndicator: const CircularProgressIndicator(),
  //       progressIndicator: const CircularProgressIndicator(
  //           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
  //       child: SingleChildScrollView(
  //         child: Container(
  //           padding: const EdgeInsets.all(2),
  //           child: buildLoginForm(context),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildLoginForm(BuildContext context) {
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
        color: Colors.white, // Establece el color de fondo para el formulario
        child: Form(
          child: Center(
            child: Column(
              children: [
                // LOGO
                Container(
                  width: 204,
                  height: 70,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/CRIXTO_NEW.png"),
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
                // FIN DE LOGO
                SizedBox(
                  height: Platform.isIOS ? 10 : 5,
                ),

                // Titulo del establecimiento
                Text(
                  nombrecomercial,
                  style: const TextStyle(
                      fontSize: 20,
                      // ignore: use_full_hex_values_for_flutter_colors
                      color: Color.fromRGBO(185, 182, 182, 1),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Capriola'),
                  textAlign: TextAlign.center,
                ),
                //Fin de titulo

                Text(
                  'Rif: $rif',
                  //'Rif',
                  style: const TextStyle(
                      fontSize: 16,
                      // ignore: use_full_hex_values_for_flutter_colors
                      color: Color.fromRGBO(3, 134, 208, 1),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Capriola'),
                  textAlign: TextAlign.center,
                ),
                //fin de rutina de mostrar el establecimient
                // Caja de texto MONTO

                SizedBox(
                  height: Platform.isIOS ? 10 : 10,
                ),

                Container(
                  width: 290,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                  child: TextField(
                    focusNode: montoFocus,
                    //inputFormatters: [montoFormatter],
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.grey,

                    style: TextStyle(
                      color: monto.text == '0.00'
                          ? const Color.fromRGBO(215, 217, 228, 1)
                          : Colors.black,
                      //color:Color.fromRGBO(215, 217, 228, 1),
                    ),
                    controller: monto,
                    onChanged: (value) {
                      setState(() {
                        // Cambiar el color del texto según el valor en la caja de texto
                        if (value == '0.00') {
                          montoHintController.text = "0.00";
                        } else {
                          montoHintController.text = "";
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(215, 217, 228, 1),
                      ),
                      hintText: montoHintController.text,

                      prefixIcon: Container(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          'assets/dolar.svg', // Ruta de tu archivo SVG
                          colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(105, 111, 140, 1),
                              BlendMode.srcIn),
                          width: 14, // Tamaño deseado en ancho
                          height: 20,
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14.0),

                      // Agrega un efecto de sombra para un aspecto 3D
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors
                              .grey, // Ajusta el color de la sombra según tus necesidades
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // FIN de caja de texto

                // Caja de texto CÉDULA
                SizedBox(
                  height: Platform.isIOS ? 20 : 10,
                ),

                Container(
                  width: 290,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                  child: TextField(
                    focusNode: ceduFocus,
                    inputFormatters: [cedulaFormatter],
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.grey,
                    controller: cedula,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(215, 217, 228, 1),
                        ),
                        hintText: "Cédula ó Rif Ej: 12345678",
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            'assets/cedula.svg', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1),
                                BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 18,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14.0),

                        // Agrega un efecto de sombra para un aspecto 3D
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors
                                .grey, // Ajusta el color de la sombra según tus necesidades
                            width: 3.0,
                          ),
                        )),
                  ),
                ),
                // FIN caja de texto CÉDULA

                // Caja 2FA
                SizedBox(
                  height: Platform.isIOS ? 20 : 10,
                ),

                Container(
                  width: 290,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                  child: TextField(
                    focusNode: dfaFocus,
                    inputFormatters: [dosfaFormatter],
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.grey,
                    controller: dosfa,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(215, 217, 228, 1),
                        ),
                        hintText: "2FA Ej: 000000",
                        //obscureText: true,

                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            'assets/candado.svg', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1),
                                BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 20,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors
                                .grey, // Ajusta el color de la sombra según tus necesidades
                            width: 3.0,
                          ),
                        )),
                  ),
                ),

                SizedBox(
                  height: Platform.isIOS ? 10 : 0,
                ),
                // BOTON DE PAGAR

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        //double.infinity, // O ajusta según tus necesidades
                        constraints: const BoxConstraints(
                            minWidth: 290), // Establece el ancho mínimo
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedCurrency == 'USDT.') {
                              await procesoPagar(context, selectedCurrency);
                            } else {
                              //await procesoPagar(context,selectedCurrency);
                              //await procesoPagarBs(context,'BS');
                              //alertas.sinArchivo(context);
                            }

                            montoController.text = '0.00';
                            FocusNode montoFocus = FocusNode();
                            // ignore: use_build_context_synchronously
                            FocusScope.of(context).requestFocus(montoFocus);
                            montoFocus.unfocus();
                          },
                          //onPressed: () => procesoPagar(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            textStyle: const TextStyle(
                                fontSize: 18, fontFamily: 'Capriola'),
                            minimumSize: const Size(290, 0),
                            backgroundColor:
                                //const Color.fromARGB(255, 1, 167, 42),
                                const Color.fromRGBO(3, 134, 208, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: const Text(
                            'Pagar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Platform.isIOS ? 0 : 0,
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: Platform.isIOS ? 40 : 10),
                        child: Visibility(
                          visible: modelo == 0,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/reporte.png"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      0), // Ajustar el espaciado entre el reporte y las opciones

                              // Utilizar DropdownButton para mostrar opciones de "Reportes"
                              DropdownButton<String>(
                                value: 'Reportes',
                                onChanged: (String? value) async {
                                  if (value != null) {
                                    switch (value) {
                                      case 'UR':
                                        setState(() {
                                          isInAsyncCall = true;
                                        });
                                        await ultimorecibo();
                                        setState(() {
                                          isInAsyncCall = false;
                                        });
                                        break;
                                      case 'RD':
                                        alertas.reporteDeldia(
                                          context,
                                          DateFormat('dd-MM-yyyy')
                                              .format(DateTime.now()),
                                        );
                                        break;
                                    }
                                  }
                                },
                                items: [
                                  const DropdownMenuItem(
                                    value: 'Reportes',
                                    child: Text(
                                      'Reportes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ReadexPro',
                                        color: Color.fromRGBO(17, 24, 60, 1),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'UR',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: const Text(
                                        '1.-Último Recibo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'ReadexPro',
                                          color: Color.fromRGBO(17, 24, 60, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'RD',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(180.0),
                                      ),
                                      child: const Text(
                                        '2.-Reporte del Día',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'ReadexPro',
                                          color: Color.fromRGBO(17, 24, 60, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                underline: Container(),
                                icon: const SizedBox.shrink(),
                                dropdownColor: Colors.white,
                              ),

                              const SizedBox(width: 10),

                              // Ajustar el espaciado entre las opciones y los RadioButtons
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/recibir.png"),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 5),
                              // const Text(
                              //   'Moneda: ',
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     fontFamily: 'ReadexPro',
                              //     color: Color.fromRGBO(17, 24, 60, 1),
                              //   ),
                              // ), // ComboBox para seleccionar la moneda
                              DropdownButton<String>(
                                //value: 'USDT.',
                                value: selectedCurrency,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedCurrency = value;
                                    });
                                    // Handle selection for different currencies here
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'USDT.',
                                    child: Text(
                                      'USDT.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ReadexPro',
                                        color: Color.fromRGBO(17, 24, 60, 1),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Bs.',
                                    child: Text(
                                      'Bs.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ReadexPro',
                                        color: Color.fromRGBO(17, 24, 60, 1),
                                      ),
                                    ),
                                  ),
                                ],
                                //underline:
                                //Container(), // Ocultar la línea debajo del ComboBox
                                //icon: const SizedBox
                                //    .shrink(), // Ocultar el icono de flecha del ComboBox
                                //dropdownColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //           Container(
                      //             alignment: Alignment.centerLeft,
                      //             margin:  EdgeInsets.only(left: Platform.isIOS ? 40 : 10),
                      //             child: Visibility(
                      //               visible: modelo == 0,
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   Row(
                      //                     children: [
                      //                       Container(
                      //                         width: 50,
                      //                         height: 50,
                      //                         decoration: const BoxDecoration(
                      //                           image: DecorationImage(
                      //                             image: AssetImage("assets/reporte.png"),
                      //                             //fit: BoxFit.cover,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       // SvgPicture.asset(
                      //                       //   'assets/print.svg',
                      //                       //   height: 18,
                      //                       // ),
                      //                       const SizedBox(width: 0),
                      //                       // Utilizar DropdownButton para mostrar opciones
                      //                       DropdownButton<String>(
                      //                         // Valor por defecto
                      //                         value: 'Reportes',
                      //                         // Manejar la opción seleccionada
                      //                         onChanged: (String? value) async {
                      //                           if (value != null) {
                      //                             switch (value) {
                      //                               case 'UR':
                      //                                 setState(() {
                      //                                   isInAsyncCall = true;
                      //                                 });
                      //                                 await ultimorecibo();
                      //                                 setState(() {
                      //                                   isInAsyncCall = false;
                      //                                 });
                      //                                 break;
                      //                               case 'RD':
                      //                               //await alertas.sinArchivo(context);
                      //                                 alertas.reporteDeldia(
                      //                                     context,
                      //                                     DateFormat('dd-MM-yyyy')
                      //                                         .format(DateTime.now()));
                      //                                 break;
                      //                             }
                      //                           }
                      //                         },
                      //                         // Lista de elementos desplegables
                      //                         items: [
                      //                           const DropdownMenuItem(
                      //                             value: 'Reportes',
                      //                             child: Text(
                      //                               'Reportes',
                      //                               style: TextStyle(
                      //                                 fontSize: 16,
                      //                                 fontFamily: 'ReadexPro',
                      //                                 color:
                      //                                     Color.fromRGBO(17, 24, 60, 1),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           DropdownMenuItem(
                      //                             value: 'UR',
                      //                             child: Container(
                      //                               decoration: BoxDecoration(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(8.0),
                      //                               ),
                      //                               child: const Text(
                      //                                 '     1.-Último Recibo',
                      //                                 style: TextStyle(
                      //                                   fontSize: 16,
                      //                                   fontFamily: 'ReadexPro',
                      //                                   color:
                      //                                       Color.fromRGBO(17, 24, 60, 1),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           DropdownMenuItem(
                      //                             value: 'RD',
                      //                             child: Container(
                      //                               decoration: BoxDecoration(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(180.0),
                      //                               ),
                      //                               child: const Text(
                      //                                 '     2.-Reporte del Día',
                      //                                 style: TextStyle(
                      //                                   fontSize: 16,
                      //                                   fontFamily: 'ReadexPro',
                      //                                   color:
                      //                                       Color.fromRGBO(17, 24, 60, 1),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                         underline: Container(),
                      //                         icon: const SizedBox.shrink(),
                      //                         dropdownColor: Colors.white,
                      //                       ),

                      // const SizedBox(width: 0),  // Add some spacing

                      // // // Row for "Moneda" with Radio options
                      // // Row(
                      // //   children: [
                      //     // const Text(
                      //     //   'Moneda:',
                      //     //   style: TextStyle(
                      //     //     fontSize: 10,
                      //     //     fontFamily: 'ReadexPro',
                      //     //     color: Color.fromRGBO(17, 24, 60, 1),
                      //     //   ),
                      //     // ),
                      //     // const SizedBox(width: 0),
                      //     Row(
                      //       children: [
                      //         Radio<String>(
                      //           value: 'USDT',
                      //           groupValue: selectedCurrency,
                      //           onChanged: (String? value) {
                      //             if (value != null) {
                      //               setState(() {
                      //                 selectedCurrency = value;
                      //               });
                      //               // Handle selection for USDT
                      //             }
                      //           },
                      //         ),
                      //         const Text(
                      //           'USDT',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontFamily: 'ReadexPro',
                      //             color: Color.fromRGBO(17, 24, 60, 1),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Radio<String>(
                      //           value: 'Bs.',
                      //           groupValue: selectedCurrency,
                      //           onChanged: (String? value) {
                      //             if (value != null) {
                      //               setState(() {
                      //                 selectedCurrency = value;
                      //               });
                      //               // Handle selection for Bs.
                      //             }
                      //           },
                      //         ),
                      //         const Text(
                      //           'Bs.',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontFamily: 'ReadexPro',
                      //             color: Color.fromRGBO(17, 24, 60, 1),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   //],
                      // //),

                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),

                      const SizedBox(height: 0),

                      // BOTONES DE PAGAR Y ESCANEAR QR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // BOTON PARA ESCANEAR QR
                          ElevatedButton(
                            onPressed: () {
                              if (monto.text == "0.00") {
                                alertas.montoErrado(context);
                              } else {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => QRViewExample(
                                        selectedCurrency: selectedCurrency),
                                  ),
                                )
                                    .then((_) {
                                  montoController.text = '0.00';
                                  FocusNode montoFocus = FocusNode();
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context)
                                      .requestFocus(montoFocus);
                                  montoFocus.unfocus();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              textStyle: const TextStyle(fontSize: 10),
                              minimumSize: const Size(5, 0),
                              backgroundColor:
                                  const Color.fromRGBO(3, 134, 208, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              shadowColor: Colors.black87,
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/qr.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Color.fromRGBO(255, 255, 255, 1),
                                      BlendMode.srcIn),
                                  width: 60,
                                  height: 62,
                                  //color: Colors.white, // Puedes ajustar el color del icono
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Platform.isIOS ? 0 : 0,
                      ),
                      const Text('Escanear QR',
                          style: TextStyle(
                              color: Color.fromRGBO(185, 182, 182, 1),
                              fontSize: 16,
                              fontFamily: 'Capriola')),

                      // OTROS BOTONES Y ELEMENTOS
                      const SizedBox(height: 0),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment
                      //       .spaceEvenly, // Puedes ajustar el alineamiento según tus preferencias
                      //   children: [
                      //     Visibility(
                      //       visible: modelo != 0,
                      //       child: ElevatedButton(
                      //         onPressed: () => ultimorecibo(),
                      //         style: ElevatedButton.styleFrom(
                      //           padding: const EdgeInsets.all(8),
                      //           textStyle: const TextStyle(
                      //               fontSize: 15, fontFamily: 'Capriola'),
                      //           minimumSize: const Size(0,
                      //               0), // Ajusta el ancho mínimo según tus necesidades
                      //           backgroundColor:
                      //               const Color.fromRGBO(3, 134, 208, 1),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10.0)),
                      //         ),
                      //         child: const Text(
                      //           'Último recibo',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //     Visibility(
                      //       visible: modelo != 0,
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           alertas.reporteDeldia(
                      //               context,
                      //               DateFormat('dd-MM-yyyy')
                      //                   .format(DateTime.now()));
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           padding: const EdgeInsets.all(8),
                      //           textStyle: const TextStyle(
                      //             fontSize: 15,
                      //             fontFamily: 'Capriola',
                      //             color: Colors.white,
                      //           ),
                      //           minimumSize: const Size(0,
                      //               0), // Ajusta el ancho mínimo según tus necesidades
                      //           backgroundColor:
                      //               const Color.fromRGBO(3, 134, 208, 1),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10.0)),
                      //         ),
                      //         child: const Text(
                      //           'Reporte del día',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // Visibility(
                      //   visible: modelo != 0,
                      //   child: ElevatedButton(
                      //     onPressed: () => ultimorecibo(),
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.all(10),
                      //       textStyle: const TextStyle(
                      //           fontSize: 18, fontFamily: 'Capriola'),
                      //       minimumSize: const Size(290, 0),
                      //       backgroundColor:
                      //           const Color.fromRGBO(3, 134, 208, 1),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0)),
                      //     ),
                      //     child: const Text(
                      //       'Imprimir último recibo',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),

                      //const SizedBox(height: 5),

                      // Visibility(
                      //   visible: modelo != 0,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       //alertareportedeldia.reporteDeldia(context,DateFormat('dd-MM-yyyy').format(DateTime.now()));
                      //       //fechaactual = _dateFormat.format(newDate);

                      //       alertas.reporteDeldia(
                      //           context,
                      //           DateFormat('dd-MM-yyyy')
                      //               .format(DateTime.now()));
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       padding: const EdgeInsets.all(10),
                      //       textStyle: const TextStyle(
                      //         fontSize: 18,
                      //         fontFamily: 'Capriola',
                      //         color: Colors.white,
                      //       ),
                      //       minimumSize: const Size(290, 0),
                      //       backgroundColor:
                      //           const Color.fromRGBO(3, 134, 208, 1),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0)),
                      //     ),
                      //     child: const Text(
                      //       'Imprimir reporte del día',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),

                      // LOGO CRIXTO
                      SizedBox(
                        height: Platform.isIOS ? 10 : 0,
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/pie_portada.svg',
                            width: 190,
                            height: 250,
                          ),
                          Positioned(
                            top: 2,
                            right: 63,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/tether.png"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
