// ignore_for_file: unused_local_variable, avoid_print

import 'dart:async';
//import 'dart:ffi';
import 'dart:io';
//import 'package:lamundialapp/Apis/apispos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class Recibo {
//   String nombre;
//   String descripcion;

//   Recibo(this.nombre, this.descripcion);
// }

class Recibo {
  String txnid;
  String fecha;
  double monto;
  String email;

  Recibo({
    required this.txnid,
    required this.fecha,
    required this.monto,
    required this.email,
  });
}

List<Recibo> listaRecibos = [];

void asignarListaRecibos(List<dynamic> listaReciboDinamica) {
  // Limpiar la lista actual antes de asignar la nueva lista
  listaRecibos.clear();

  // Iterar sobre la lista dinámica y convertirla a objetos Recibo
  for (var item in listaReciboDinamica) {
    Recibo recibo = Recibo(
      txnid: item['txnid'] ?? '',
      fecha: item['fecha'] ?? '',
      monto: item['montopago'],
      //fecha: DateTime.parse(item['fecha'] ?? ''),
      //montopago: double.parse(item['montopago'] ?? '0.0'),
      email: item['email'] ?? '',
    );
    listaRecibos.add(recibo);
  }
}

class Lrecibo extends StatefulWidget {
  final List<dynamic> listaRecibo;
  const Lrecibo({Key? key, required this.listaRecibo}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  LreciboState createState() => LreciboState();
}

class LreciboState extends State<Lrecibo> {
  bool showQrCode = false;
  int countdown = 180; // Inicializar el contador a 180 segundos
  Timer? timer;
  late String encryptedJson = '';
  late String qrEncriptado = '';
  late String errorMensaje = '';
  bool isLoading = false;
  double montototal = 0;
  int trecibos = 0;

  @override
  void initState() {
    super.initState();
    cargarListaRecibos();
  }

  void cargarListaRecibos() {
    // Asegurarse de que widget.listaRecibo no sea nulo antes de intentar cargar
    listaRecibos = [];

    for (var item in widget.listaRecibo) {
      double montorecibo = double.parse(item['montopago'] ?? '0.0');
      Recibo recibo = Recibo(
        txnid: item['txnid'] ?? '',
        fecha: item['fecha'] ?? '',
        monto: double.parse(item['montopago'] ?? '0.0'),
        email: item['email'] ?? '',
      );
      listaRecibos.add(recibo);
      montototal += montorecibo;
      trecibos++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LISTADO DE RECIBOS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Capriola',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
          //child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.99,
            //height: MediaQuery.of(context).size.height * 0.99,
            child: buildForm(context),
          ),
          // ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Usar ListView.builder para mostrar la lista de recibos
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listaRecibos.length,
                  itemBuilder: (context, index) {
                    DateTime fechaDateTime = DateFormat('dd-MM-yyyy hh:mm:ss a')
                        .parse(listaRecibos[index].fecha);
                    String fecha =
                        DateFormat('dd-MM-yyyy').format(fechaDateTime);
                    String hora =
                        DateFormat('hh:mm:ss a').format(fechaDateTime);
                    hora = hora.replaceAll('AM', 'am.').replaceAll('PM', 'pm.');
                    print(fechaDateTime);

                    print('Fecha: $fecha');
                    print('Hora: $hora');
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color.fromRGBO(3, 134, 208, 1),
                      child: ListTile(
                        title: Text('Txnid: ${listaRecibos[index].txnid}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Capriola',
                              color: Colors.white,
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('     Usuario: ${listaRecibos[index].email}',
                                style: const TextStyle(
                                  fontFamily: 'Capriola',
                                  color: Colors.white,
                                )),
                            Text(
                                '     Monto: ${listaRecibos[index].monto} USDT',
                                style: const TextStyle(
                                  fontFamily: 'Capriola',
                                  color: Colors.white,
                                )),
                            Text('     Fecha: $fecha',
                                style: const TextStyle(
                                  fontFamily: 'Capriola',
                                  color: Colors.white,
                                )),
                            Text('     Hora: $hora',
                                style: const TextStyle(
                                  fontFamily: 'Capriola',
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        // Agrega más detalles según sea necesario
                        // onTap: ...
                      ),
                    );
                  },
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color.fromARGB(255, 6, 6, 6),
                child: ListTile(
                  title: Text(
                      'Total USDT: ${montototal.toStringAsFixed(3).substring(0, montototal.toStringAsFixed(3).indexOf('.') + 4)}',
                      //title: Text('Total USDT: $montototal',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Capriola',
                          color: Colors.white,
                          fontSize: 16)),
                  subtitle: Text('Total recibo(s): $trecibos',
                      style: const TextStyle(
                          fontFamily: 'Capriola',
                          color: Colors.white,
                          fontSize: 16)),
                ),
              ),
              SizedBox(
                height: Platform.isIOS ? 10 : 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildForm(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Form(
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Usar ListView.builder para mostrar la lista de recibos
  //             ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: listaRecibos.length,
  //               itemBuilder: (context, index) {
  //                 return Card(
  //                   elevation: 3,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   color: const Color.fromRGBO(3, 134, 208, 1),
  //                   child: ListTile(
  //                     title: Text('Txnid: ${listaRecibos[index].txnid}',
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontFamily: 'Capriola',
  //                           color: Colors.white,
  //                         )),
  //                     subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text('     Usuario: ${listaRecibos[index].email}',
  //                             style: const TextStyle(
  //                               fontFamily: 'Capriola',
  //                               color: Colors.white,
  //                             )),
  //                         Text('     Monto: ${listaRecibos[index].monto} USDT',
  //                             style: const TextStyle(
  //                               fontFamily: 'Capriola',
  //                               color: Colors.white,
  //                             )),
  //                         Text('     Fecha: ${listaRecibos[index].fecha}',
  //                             style: const TextStyle(
  //                               fontFamily: 'Capriola',
  //                               color: Colors.white,
  //                             )),
  //                       ],
  //                     ),
  //                     // Agrega más detalles según sea necesario
  //                     // onTap: ...
  //                   ),
  //                 );

  //                 // return ListTile(
  //                 //   title: Text(listaRecibos[index].txnid),
  //                 //   subtitle: Column(
  //                 //     crossAxisAlignment: CrossAxisAlignment.start,
  //                 //     children: [
  //                 //       Text('Fecha: ${listaRecibos[index].fecha}'),
  //                 //       Text('Montopago: ${listaRecibos[index].montopago}'),
  //                 //       Text('Email: ${listaRecibos[index].email}'),
  //                 //     ],
  //                 //   ),
  //                 //   // Agrega más detalles según sea necesario
  //                 //   // onTap: ...
  //                 // );
  //               },
  //             ),
  //             Card(
  //               elevation: 3,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               color: const Color.fromARGB(255, 6, 6, 6),
  //               child: ListTile(
  //                 title: Text('Total USDT: $montototal',
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'Capriola',
  //                       color: Colors.white,
  //                       fontSize: 16
  //                     )),
  //                 subtitle: Text('Total recibo(s): $trecibos',
  //                     style: const TextStyle(
  //                       fontFamily: 'Capriola',
  //                       color: Colors.white,
  //                       fontSize: 16
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    timer?.cancel();
  }
}

// void main() {
//   runApp(const MaterialApp(home: Lrecibo()));
// }
