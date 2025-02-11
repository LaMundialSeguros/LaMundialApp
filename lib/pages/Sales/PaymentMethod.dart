// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/components/bannerPaymentMethod.dart';
import 'package:lamundialapp/pages/Sales/BancoPlazaForm.dart';


class PaymentMethod extends StatelessWidget{
  final Policy policy;
  const PaymentMethod(this.policy,{Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBarSales("MÉTODO DE PAGO"),
      body: Menu(context,policy),
    );
  }
}


Widget Menu(BuildContext context,policy) {
  return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
            children:
            [
              const SizedBox(height: 100),
              const BannerPaymentMethod(),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MenuClient(0),
                    ),
                        (route) =>
                    false, // Elimina todas las rutas existentes en la pila
                  );*/
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'UBIIPAGO',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => BancoPlazaFormPage(policy)));
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'BANCO PLAZA',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MenuClient(1),
                    ),
                        (route) =>
                    false, // Elimina todas las rutas existentes en la pila
                  );*/
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SYPAGO',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
        )
      )
  );
}