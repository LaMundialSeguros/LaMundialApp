// ignore_for_file: unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBarWelcome.dart';
import 'package:lamundialapp/pages/Productor/MenuProductor.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Apis/apis.dart';



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
      appBar: const CustomAppBarWelcome(),
      body: Menu(context),
    );
  }

  // Function to show the Yes/No dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Póliza'),
          content: const Text('¿Desea descargar su póliza?'),
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
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
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
            child: const Row(
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
                  style: const TextStyle(
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
            child: const Row(
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuProductor(0)));
            },
            child: Container(
              width: 320,
              height: 150,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(232, 79, 81, 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                border: Border.all(
                  color: const Color.fromRGBO(232, 79, 81, 1),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Image.asset('assets/comprar.png', height: 60),
                    Container(
                      child: const Row(
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
