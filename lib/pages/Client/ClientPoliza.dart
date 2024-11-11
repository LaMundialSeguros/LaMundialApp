import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/AppBarVehiculos.dart';

import '../../Apis/apis.dart';
import '../../Utilidades/AppBarServices.dart';

class ClientPoliza extends StatelessWidget{
  final dynamic datos;
  const ClientPoliza(this.datos,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBarServices(),
      body: Menu(context,datos),
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 35,bottom: 80),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 150,
              height: 35,
              child: FloatingActionButton(
                onPressed: () {
                  // Acción a realizar al presionar el botón
                  print('Botón presionado');
                },
                child:  Text(
                          "Pagar Póliza",
                          style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1), // Color del texto
                          fontFamily: 'Poppins',
                        ),
                ),
                backgroundColor: Color.fromRGBO(232, 79, 81, 0.85), // Establecemos el color a rojo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(12.0),
                    topRight:  Radius.circular(12.0),
                    bottomLeft:  Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ), // Hacemos el botón redondo
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Widget Menu(BuildContext context,datos) {
  return Center(
    child: SizedBox(
      width: 340,
      height: 600,
      child: Container(
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
        child: ListView.builder(
          itemCount:
          datos.length,
          itemBuilder: (context, index) {
            final producto = datos[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {

                },
                child: Container(
                  width: 315,
                  height: 70,
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
                        const SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                producto['servicio'],
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
            );
          },
        ),
      ),
    ),
  );
}