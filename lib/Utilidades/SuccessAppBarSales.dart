import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/rolPage.dart';

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
              style: TextStyle(
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
        backgroundColor:Color.fromRGBO(15, 26, 90, 1),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}