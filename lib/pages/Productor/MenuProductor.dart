// ignore_for_file: override_on_non_overriding_member, no_leading_underscores_for_local_identifiers, unused_local_variable, avoid_print, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/pages/Notifications/notifyPaymentsForm.dart';
import 'package:lamundialapp/pages/Sales/MenuProducts.dart';



class MenuProductor extends StatefulWidget {
  final int index;
  const MenuProductor(this.index,{Key? key}) : super(key: key);
  @override
  MenuProductorState createState() => MenuProductorState();
}

class MenuProductorState extends State<MenuProductor>{
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
      const MenuProducts(),
      const NotifyPaymentsForm(),
    ];

    if(_selectedIndex == -1){
      _selectedIndex = widget.index;
    }
    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();
    return Scaffold(
      appBar:const CustomAppBar(),
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
              backgroundColor: const Color.fromRGBO(232, 79, 81, 0.85), // Establecemos el color a rojo
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
                child: Image.asset('assets/compra.png'),
              ),
              label: 'Venta',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/informePago.png'),
              ),
              label: 'Notificar Pagar',
            ),
          ],
          selectedLabelStyle: const TextStyle(
              color: Color.fromRGBO(15, 26, 90, 1),
              fontSize: 12,
              fontFamily: "Poppins"
          ),
          unselectedLabelStyle: const TextStyle(
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