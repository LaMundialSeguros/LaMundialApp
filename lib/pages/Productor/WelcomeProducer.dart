import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import 'package:lamundialapp/Utilidades/AppBarWelcome.dart';
import 'package:lamundialapp/pages/Productor/MenuProductor.dart';
import 'package:lamundialapp/pages/statistics/ProducerStatisticsMenu.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Apis/apis.dart';
import '../../Utilidades/Class/User.dart';

// ignore_for_file: avoid_print

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/gestures.dart'; // for TapGestureRecognizer

class WelcomeProducer extends StatelessWidget {
  final String url;

  // Constructor now accepts URL as a parameter
  const WelcomeProducer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show dialog if the URL is not empty ..urlisNotEmpty
    if (url == 'nuncasevaamostrar') {
      // After the page is loaded, show the dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showConfirmationDialog(context);
      });
    }

    return Scaffold(
      appBar: CustomAppBarWelcome(),
      body: Menu(context),
    );
  }

  // Function to show the Yes/No dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Póliza'),
          content: Text('¿Desea descargar su póliza?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final Uri uri = Uri.parse(url); // Convert the String to Uri
                if (await canLaunchUrlString(url)) { // Use canLaunchUrl with Uri
                  await launchUrlString(url, mode: LaunchMode.externalApplication); // Use launchUrl with external browser
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No se pudo abrir la póliza. Verifique su conexión.')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

Widget Menu(BuildContext context) {
  return Container(
    color: Colors.transparent,
    child: Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido/a',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  GlobalVariables().user.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Qué desea realizar?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MenuProductor(0)));
            },
            child: Container(
              width: 320,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromRGBO(232, 79, 81, 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                border: Border.all(
                  color: Color.fromRGBO(232, 79, 81, 1),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Image.asset('assets/comprar.png', height: 60),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Comprar Póliza',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(15, 26, 90, 1),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
