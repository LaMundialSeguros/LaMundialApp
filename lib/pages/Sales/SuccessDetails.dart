// ignore_for_file: avoid_print, unnecessary_string_interpolations, sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/SuccessAppBarSales.dart';
import 'package:lamundialapp/pages/Productor/WelcomeProducer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SuccessDetails extends StatelessWidget {
  
  bool isLoading = false;
 final String policyType;
 final String cnpoliza;
 final String transactionId;

  SuccessDetails({
    Key? key,
    required this.policyType,
    required this.cnpoliza,
    required this.transactionId,
  }) : super(key: key);



  @override

Widget build(BuildContext context) {
  return Scaffold(
    appBar: const SuccessCustomAppBarSales("PAGO EXITOSO"), // Custom header
    body: Padding(
      padding: const EdgeInsets.only(top: 1),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.0,
        progressIndicator: const SpinKitDualRing(
          color: Color.fromRGBO(76, 182, 149, 0.965), // Green spinner
          size: 60.0,
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '\nEstimado Cliente,\nGracias por preferir a\nLa Mundial de Seguros\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: Color.fromRGBO(15, 26, 90, 1), // Navy text
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Su Póliza de ',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      color: Color.fromRGBO(15, 26, 90, 1), 
                      fontWeight: FontWeight.w400
                    ),
                    children: [
                      TextSpan(
                        text: '$policyType',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold, // Update the font weight for $policyType
                          color: Color.fromRGBO(15, 26, 90, 1), 
                        ),
                      ),
                      const TextSpan(
                        text: ', Número ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1), 
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      TextSpan(
                        text: '$cnpoliza',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold, // Update the font weight for $cnpoliza
                          color: Color.fromRGBO(15, 26, 90, 1), 
                        ),
                      ),
                      const TextSpan(
                        text: '\nFue emitida exitosamente.\n',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1), 
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text:  TextSpan(
                    text: 'El número de referencia de su pago es ',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      color: Color.fromRGBO(15, 26, 90, 1), 
                      fontWeight: FontWeight.w400
                    ),
                    children: [
                      TextSpan(
                        text: transactionId,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(15, 26, 90, 1), 
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/CanastaSuccess.png',
                  width: 100,  // Adjust the width
                  height: 100, // Adjust the height
                ),

                Container(
                  width: 300,
                   // set the desired width
                  child: const Text(
                    'Fue enviado a su correo electrónico toda la documentación de su póliza.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(15, 26, 90, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡Muchas Gracias!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(15, 26, 90, 1), // (232, 79, 81, 1),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeProducer(url: '')),
                    (Route<dynamic> route) => false, // This clears all previous routes
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(232, 79, 81, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Menú Principal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
