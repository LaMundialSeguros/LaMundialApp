// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

class bannerSyPago extends StatelessWidget {
  const bannerSyPago({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/SyPago.png',
      //'lib/images/logo.png', // Ruta a la imagen en tu proyecto
      width: 225.0, // Ancho de la imagen (ajusta según tus necesidades)
      height: 225.0, // Altura de la imagen (ajusta según tus necesidades)
      // Puedes ajustar otras propiedades como el ajuste (fit) y el color:
      // fit: BoxFit.contain, // Ajusta la imagen al tamaño del contenedor
      // color: Colors.red,   // Cambia el color de la imagen (opcional)
    );
  }
}
