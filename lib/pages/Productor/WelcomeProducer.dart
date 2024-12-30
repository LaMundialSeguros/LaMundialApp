import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/AppBarWelcome.dart';
import 'package:lamundialapp/pages/Productor/MenuProductor.dart';
import 'package:lamundialapp/pages/statistics/ProducerStatisticsMenu.dart';

import '../../Apis/apis.dart';
import '../../Utilidades/Class/User.dart';

class WelcomeProducer extends StatelessWidget{
  const WelcomeProducer({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar:CustomAppBarWelcome(),
      body: Menu(context),
    );
  }
}


Widget Menu(BuildContext context) {
  return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
            children:
            [
              const SizedBox(height: 100),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido/a',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(15, 26, 90, 1),
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
                          GlobalVariables().user.name,
                          style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Qué desea realizar?',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              /*GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MenuProductor(2)));
                },
                child: Container(
                  width: 320,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(30.0),
                        topRight:  Radius.circular(30.0),
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset('assets/statistics.png',height: 60,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Estadisticas',
                                style: TextStyle(
                                    fontSize: 16,
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
              ),*/ // Estadisticas comentado
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => MenuProductor(0)));
                },
                child: Container(
                  width: 320,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.circular(30.0),
                        topRight:  Radius.circular(30.0),
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset('assets/comprar.png',height: 60,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Vender Poliza',
                                style: TextStyle(
                                    fontSize: 16,
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