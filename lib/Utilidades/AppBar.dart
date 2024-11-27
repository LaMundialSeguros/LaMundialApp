import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/rolPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

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
                        builder: (context) => WelcomeClient(),
                      ),
                          (route) =>
                      false, // Elimina todas las rutas existentes en la pila
                    );
                  },
                ),
                Image.asset(
                  'assets/iconAppBar.png',
                  height: 90,
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
        ),
        backgroundColor:Color.fromRGBO(15, 26, 90, 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}