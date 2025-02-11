// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BannerWidgetNotifyPayments extends StatelessWidget {
  const BannerWidgetNotifyPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/bannerNotificarPagos.png',
      //'lib/images/logo.png', // Ruta a la imagen en tu proyecto
      width: 200.0, // Ancho de la imagen (ajusta según tus necesidades)
      height: 200.0, // Altura de la imagen (ajusta según tus necesidades)
      // Puedes ajustar otras propiedades como el ajuste (fit) y el color:
      // fit: BoxFit.contain, // Ajusta la imagen al tamaño del contenedor
      // color: Colors.red,   // Cambia el color de la imagen (opcional)
    );
  }
}
