import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/pages/Client/test.dart';
import 'package:lamundialapp/pages/Sales/TakerDetails.dart';
import 'package:lamundialapp/pages/rolPage.dart';

import '../../Apis/apis.dart';


class MenuProducts extends StatelessWidget{
    const MenuProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Product> products = [
      Product('Salud Individual', 1),
      Product('Salud Familiar', 2),
      Product('Seguro Funerario', 3),
      Product('4 en 1', 4),
      Product('Póliza de Vida', 5),
      Product('R.C.V. Autos', 6),
      Product('R.C.V. Motos', 7),
    ];

    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();

    return GridView.count(
      crossAxisCount: 2,
      children: [
        for (var product in products)
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TakerDetailsPage(product),
                ),
                    (route) =>
                false, // Elimina todas las rutas existentes en la pila
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(254, 246, 246, 1),
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(30.0),
                    topRight:  Radius.circular(30.0),
                    bottomLeft:  Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(232, 79, 81, 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(232, 79, 81, 0.35), // Color de la sombra
                      spreadRadius: 2, // Distancia de la sombra
                      blurRadius: 4, // Difuminado de la sombra
                      offset: Offset(0, 3), // Posición de la sombra
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/'+product.id.toString()+'_icon.png',height: 60,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.name,
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
          ),
      ],
    );
  }
}