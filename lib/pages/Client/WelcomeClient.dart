// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import '../../Apis/apis.dart';

class WelcomeClient extends StatelessWidget{
  const WelcomeClient({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar:const CustomAppBar(),
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
                child: const Row(
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
                          style: const TextStyle(
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
                child: const Row(
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MenuClient(0),
                    ),
                        (route) =>
                    false, // Elimina todas las rutas existentes en la pila
                  );
                },
                child: Container(
                  width: 320,
                  height: 150,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(30.0),
                        topRight:  Radius.circular(30.0),
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset('assets/gestionar.png',height: 60,),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Gestionar Servicios',
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MenuClient(1),
                    ),
                        (route) =>
                    false, // Elimina todas las rutas existentes en la pila
                  );
                },
                child: Container(
                  width: 320,
                  height: 150,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(30.0),
                        topRight:  Radius.circular(30.0),
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset('assets/comprar.png',height: 60,),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Comprar Poliza',
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