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
  late String texto = GlobalVariables().message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
          child: AppBar(
            //toolbarHeight: 50,
            title: Text(texto),
          ),
        ),
        preferredSize: Size.fromHeight(150),
      ),
    );
  }
}
