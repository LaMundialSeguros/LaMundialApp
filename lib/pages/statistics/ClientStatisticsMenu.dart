// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names

import 'package:flutter/material.dart';

class ClientStatisticsMenu extends StatelessWidget{
  const ClientStatisticsMenu({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {

    return Menu(context);
  }
}


Widget Menu(BuildContext context) {
  return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
            children:
            [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mis Pólizas',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Recibos Pendientes',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Siniestros',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: 340,
                  height: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 79, 81, 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft:  Radius.circular(15.0),
                        topRight:  Radius.circular(15.0),
                        bottomLeft:  Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(232, 79, 81, 1),
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Renovaciones',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]
        )
      )
  );
}