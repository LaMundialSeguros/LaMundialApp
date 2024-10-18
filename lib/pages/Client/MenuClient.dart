import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/pages/Client/ServicesClient.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utilidades/Class/User.dart';

class MenuClient extends StatelessWidget{
  final User user;
  const MenuClient(this.user,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(),
      body: Menu(context,user),
    );
  }
}


Widget Menu(BuildContext context,user) {
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
                      user.name,
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ServicesClient(user),
                    ),
                        (route) =>
                    false, // Elimina todas las rutas existentes en la pila
                  );
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
                        Image.asset('assets/gestionar.png',height: 60,),
                        Container(
                          child: Row(
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
              Container(
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
                              'Comprar Servicios',
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
            ]
        )
      )
  );
}