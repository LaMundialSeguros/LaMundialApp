import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';

import '../../Apis/apis.dart';

class ServicesClient extends StatelessWidget{
  final dynamic datos;
  const ServicesClient(this.datos,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(),
      body: Menu(context,datos),
    );
  }
}


Widget Menu(BuildContext context,datos) {
  return Center(
    child: SizedBox(
      width: 340,
      height: 130,
      child: ListView.builder(
        itemCount:
        datos.length,
        itemBuilder: (context, index) {
          final producto = datos[index];
          return GestureDetector(
                  onTap: () {
                    if (producto['nopcion'] == 4) {
                      apiServiceManagerRCV(context,GlobalVariables().cedulaUser,4);
                    }else {
                      apiServiceManagerRCV(context,GlobalVariables().cedulaUser,4);
                    }
                  },
                  child: Container(
            height: 120,
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(15.0),
                  topRight:  Radius.circular(15.0),
                  bottomLeft:  Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                border: Border.all(
                  color: Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(98, 162, 232, 0.5), // Color de la sombra
                    spreadRadius: 2, // Distancia de la sombra
                    blurRadius: 4, // Difuminado de la sombra
                    offset: Offset(0, 3), // Posición de la sombra
                  ),
                ],
            ),
            child: Column(
              children: [
                Container(
                  height: 45,
                  /*decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  )),*/
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  producto['xproducto'],
                                  style: TextStyle(
                                      color: Color.fromRGBO(15, 26, 90, 1),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:  Align(
                                      alignment: Alignment.topRight,
                                child: Text(
                                  "/m",
                                  style: TextStyle(
                                      color: Color.fromRGBO(15, 26, 90, 1),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold// Tamaño del texto en puntos lógicos
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  /*decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      )),*/
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Activo",
                                  style: TextStyle(
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child:Row(
                              children: [
                                Text(
                                  "Servicios e información ",
                                  style: TextStyle(
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ImageIcon(AssetImage('assets/circleArrow.png'), size: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          );
        },
      ),
    ),
  );
}