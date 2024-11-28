import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/pages/Client/ServicesClient.dart';
import 'package:lamundialapp/pages/Client/test.dart';
import 'package:lamundialapp/pages/Notifications/notifyPaymentsForm.dart';
import 'package:lamundialapp/pages/Sales/MenuProducts.dart';
import 'package:lamundialapp/pages/rolPage.dart';
import 'package:lamundialapp/pages/statistics/ClientStatisticsMenu.dart';

import '../../Apis/apis.dart';


class MenuClient extends StatefulWidget {
  final int index;
  MenuClient(this.index,{Key? key}) : super(key: key);
  @override
  MenuClientState createState() => MenuClientState();
}

class MenuClientState extends State<MenuClient>{
  @override
  int _selectedIndex = -1;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override

  Widget build(BuildContext context) {

    List<Widget> _widgetOptions = <Widget>[
      ServicesClient(),
      MenuProducts(),
      NotifyPaymentsForm(),
      ClientStatisticsMenu(),
    ];

    if(_selectedIndex == -1){
      _selectedIndex = widget.index;
    }
    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();
    return Scaffold(
      appBar:CustomAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: () {
                // Acción a realizar al presionar el botón
                print('Botón presionado');
              },
              child: Image.asset(
                'assets/sos.png', // Reemplaza con la ruta de tu imagen
                width: 24, // Ajusta el ancho de la imagen
                height: 24, // Ajusta la altura de la imagen
              ),
              backgroundColor: Color.fromRGBO(232, 79, 81, 0.85), // Establecemos el color a rojo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Hacemos el botón redondo
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/polizas.png'),
              ),
              label: 'Polizas',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/compra.png'),
              ),
              label: 'Compra',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/informePago.png'),
              ),
              label: 'Notificar Pagar',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/estadisticas.png'),
              ),
              label: 'Estadisticas',
            ),
          ],
          selectedLabelStyle: TextStyle(
              color: Color.fromRGBO(15, 26, 90, 1),
              fontSize: 12,
              fontFamily: "Poppins"
          ),
          unselectedLabelStyle: TextStyle(
              color: Color.fromRGBO(15, 26, 90, 1),
              fontSize: 12,
              fontFamily: "Poppins"
          ), // Color del label no seleccionado
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}