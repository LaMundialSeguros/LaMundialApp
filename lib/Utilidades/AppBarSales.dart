// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomAppBarSales extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  const CustomAppBarSales(this.name,{super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),textAlign: TextAlign.center,),
            IconButton(
              icon: Image.asset(
                'assets/helpAppBar.png', // Reemplaza con la ruta de tu imagen
                height: 40,
              ),
              onPressed: () {
                // Lógica para el nuevo botón
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor:const Color.fromRGBO(15, 26, 90, 1),
        leading: IconButton(
          icon: Image.asset(
            'assets/return.png', // Reemplaza con la ruta de tu imagen
            height: 40,
          ), // Reemplaza con tu icono deseado
          onPressed: () {
            Navigator.pop(context);
          },
        ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}