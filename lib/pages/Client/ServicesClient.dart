import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/pages/rolPage.dart';

import '../../Apis/apis.dart';

class ServicesClient extends StatelessWidget{
  const ServicesClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();
    return Menu(context,datos,search,searchCodeFocus);
  }
}

Widget Menu(BuildContext context,datos,search,searchCodeFocus) {

  return Center(
    child: Column(
      children: [
        const SizedBox(height: 30),
        Container(
          width: 340,
          height: 40,
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft:  Radius.zero,
                topRight:  Radius.circular(40.0),
                bottomLeft:  Radius.circular(40.0),
                bottomRight: Radius.zero,
              ),
              border: Border.all(
                color: Color.fromRGBO(79, 127, 198, 1),
              )),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  focusNode: searchCodeFocus,
                  style: const TextStyle(
                    color: Colors.black, // Color del texto
                    fontFamily: 'Poppins',
                    // Otros estilos de texto que desees aplicar
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ingrese su búsqueda...',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        '', // Ruta de tu archivo SVG
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(121, 116, 126, 1),
                            BlendMode.srcIn),
                        width: 20, // Tamaño deseado en ancho
                        height: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(121, 116, 126, 1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 340,
          height: 500,
            child: ListView.builder(
              itemCount:
              GlobalVariables().polizas.length,
              itemBuilder: (context, index) {
                final producto = GlobalVariables().polizas[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        if (producto.codigo == 4) {
                          apiServiceManagerRCV(context,GlobalVariables().user.cedula,producto.codigo);
                        }else {
                          apiServiceOptions(context,producto.codigo);
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
                                              producto.xproducto,
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
                  ),
                );
              },
            )
        ),
      ],
    ),
  );
}