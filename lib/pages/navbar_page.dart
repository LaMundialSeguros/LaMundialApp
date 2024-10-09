import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Negocio/pagar.dart';
import 'package:lamundialapp/pages/login_page.dart';
//import 'package:lamundialapp/pages/menu_page.dart' as menu;
//import 'package:lamundialapp/pages/menu_page.dart' as menup;
import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/qrscreen_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(GlobalVariables().nombreUser,
                style: const TextStyle(
                  color: Color.fromARGB(255, 9, 10, 10),
                  fontSize: 18.0, // Ajusta el tamaño del texto aquí
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Capriola',
                  // Pone el texto en negrita
                )),
            accountEmail: Text(GlobalVariables().emailUser,
                style: const TextStyle(
                  color: Color.fromARGB(255, 9, 10, 10),
                  fontSize: 14.0, // Ajusta el tamaño del texto aquí
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Capriola',
                )),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  "https://crixto.io/uploads/${GlobalVariables().avatarUser}",
                  fit: BoxFit.cover, // Ajusta la imagen al ClipOval
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage("assets/fondo2.png"),
                fit: BoxFit.none,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text(
              'QR de PAGO',
              style: TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
                fontFamily: 'Capriola',
              ),
            ),
            // ignore: avoid_print
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QrScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text(
              'POS de VENTA',
              style: TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
                fontFamily: 'Capriola',
              ),
            ),
            // ignore: avoid_print
            onTap: () {
              //menup.MenuAppState().disconnectSocket();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const pagar(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'Capriola',
                ),
              ),
              // ignore: avoid_print
              onTap: () {
                //menup.MenuAppState().disconnectSocket();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) =>
                      false, // Elimina todas las rutas existentes en la pila
                );
                //Navigator.of(context).popUntil((route) => route.isFirst);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const LoginPage(),
                //   ),
                // );
              }),
          const Divider(),
        ],
      ),
    );
  }
}
