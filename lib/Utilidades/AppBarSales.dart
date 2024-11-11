import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/MenuClient.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/rolPage.dart';

class CustomAppBarSales extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  const CustomAppBarSales(this.name,{super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        flexibleSpace:
          FlexibleSpaceBar(
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/return.png', // Reemplaza con la ruta de tu imagen
                    height: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MenuClient(0),
                      ),
                          (route) =>
                      false, // Elimina todas las rutas existentes en la pila
                    );
                  },
                ),
                Text(
                      name,
                      style: TextStyle(
                        fontSize: 26,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                ),),
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
        ),
        backgroundColor:Color.fromRGBO(15, 26, 90, 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}