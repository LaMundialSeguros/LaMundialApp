import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/components/bannerPaymentMethod.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/Client/ServicesClient.dart';
import 'package:lamundialapp/pages/Sales/BancoPlazaForm.dart';
import 'package:lamundialapp/pages/Sales/MenuProducts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Apis/apis.dart';
import '../../Utilidades/Class/User.dart';

class PaymentMethod extends StatelessWidget{
  final Policy policy;
  const PaymentMethod(this.policy,{Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarSales("MÉTODO DE PAGO"),
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
                      color: Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: Row(
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
                      color: Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: Row(
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
                      color: Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: Row(
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