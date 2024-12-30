import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/Client/WelcomeClient.dart';
import 'package:lamundialapp/pages/rolPage.dart';

class CustomAppBarWelcome extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBarWelcome({super.key});

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
        backgroundColor:Color.fromRGBO(15, 26, 90, 1),
        leading: IconButton(
          icon: Image.asset(
            'assets/logoutblanco.png', // Reemplaza con la ruta de tu imagen
            height: 40,
          ), // Reemplaza con tu icono deseado
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RolPage(),
              ),
                  (route) =>
              false, // Elimina todas las rutas existentes en la pila
            );
          },
        ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}