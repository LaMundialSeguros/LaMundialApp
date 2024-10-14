import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';

import '../components/logo.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String cedula = GlobalVariables().cedulaUser;
  late String email = GlobalVariables().emailUser;
  late int rol = GlobalVariables().rolUser;
  late int id = GlobalVariables().idUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
          child: AppBar(
            //toolbarHeight: 50,
            backgroundColor: Color.fromRGBO(15, 26, 90, 1),
            title: Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white, // Cambia el color del texto aquí
                          )
                        ),
          ),
        ),
        preferredSize: Size.fromHeight(150),
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
