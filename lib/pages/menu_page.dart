// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String cedula = GlobalVariables().user.cedula;
  late String email = GlobalVariables().user.name;
  late int rol = GlobalVariables().user.rol;
  late int id = GlobalVariables().user.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
          child: AppBar(
            //toolbarHeight: 50,
            backgroundColor: const Color.fromRGBO(15, 26, 90, 1),
            title: const Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white, // Cambia el color del texto aquí
                          )
                        ),
          ),
        ),
        preferredSize: const Size.fromHeight(150),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('ID: $id'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('EMAIL: '+email),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('CEDULA: '+cedula),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('ROL: $rol'),
              ],
            ),
          ],
        ),
      )
    );
  }
}
