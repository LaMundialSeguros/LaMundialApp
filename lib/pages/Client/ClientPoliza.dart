// ignore_for_file: avoid_print, sort_child_properties_last, non_constant_identifier_names, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import '../../Utilidades/AppBarServices.dart';

class ClientPoliza extends StatelessWidget{
  final dynamic datos;
  const ClientPoliza(this.datos,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBarServices(),
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
                child:  const Text(
                          "Pagar Póliza",
                          style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1), // Color del texto
                          fontFamily: 'Poppins',
                        ),
                ),
                backgroundColor: const Color.fromRGBO(232, 79, 81, 0.85), // Establecemos el color a rojo
                shape: const RoundedRectangleBorder(
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
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: const BorderRadius.only(
            topLeft:  Radius.circular(15.0),
            topRight:  Radius.circular(15.0),
            bottomLeft:  Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          border: Border.all(
            color: Colors.transparent,
          ),
          boxShadow: const [
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
                        const SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                producto['servicio'],
                                style: const TextStyle(
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