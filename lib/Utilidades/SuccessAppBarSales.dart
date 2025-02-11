// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SuccessCustomAppBarSales extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  const SuccessCustomAppBarSales(this.name,{super.key});

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
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}