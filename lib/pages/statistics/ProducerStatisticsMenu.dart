import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/Client/ServicesClient.dart';
import 'package:lamundialapp/pages/Sales/MenuProducts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Apis/apis.dart';
import '../../Utilidades/Class/User.dart';

class ProducerStatisticsMenu extends StatelessWidget{
  const ProducerStatisticsMenu({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Menu(context);
  }
}
Widget Menu(BuildContext context) {
  return Container(
      color: Colors.transparent,
      child: Center(
          child: Column(
              children:
              [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
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
                                  'Mi Cartera (Pólizas y Primas)',
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
                                  'Mis Comisiones',
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
                                  'Cobranzas',
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
                                  'Renovación de Cartera',
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
                                  'Siniestralidad',
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
              ]
          )
      )
  );
}