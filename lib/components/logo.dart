import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/lamundial.png',
      //'lib/images/logo.png', // Ruta a la imagen en tu proyecto
      width: 300.0, // Ancho de la imagen (ajusta según tus necesidades)
      height: 275.0, // Altura de la imagen (ajusta según tus necesidades)
      // Puedes ajustar otras propiedades como el ajuste (fit) y el color:
      // fit: BoxFit.contain, // Ajusta la imagen al tamaño del contenedor
      // color: Colors.red,   // Cambia el color de la imagen (opcional)
    );
  }
}
