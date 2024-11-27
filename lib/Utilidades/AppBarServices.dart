import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/rolPage.dart';

class CustomAppBarServices extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBarServices({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              "   SERVICIOS ",
              style: TextStyle(
                fontSize: 26,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),),
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
      centerTitle: true,
      backgroundColor:Color.fromRGBO(15, 26, 90, 1),
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