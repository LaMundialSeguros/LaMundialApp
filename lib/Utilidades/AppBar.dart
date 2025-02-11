// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Image.asset(
                'assets/iconAppBar.png',
                height: 90,
              )
          ),
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