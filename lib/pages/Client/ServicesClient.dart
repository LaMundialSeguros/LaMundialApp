import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBar.dart';
import '../../Utilidades/Class/User.dart';

class ServicesClient extends StatelessWidget{
  final User user;
  const ServicesClient(this.user,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(),
      body: Menu(context,user),
    );
  }
}


Widget Menu(BuildContext context,user) {
  return Container(
      color: Colors.transparent,
      child: Center(
        child: Row(
            children:
            [ const SizedBox(width: 30),
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(232, 79, 81, 0.05),
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(30.0),
                          topRight:  Radius.circular(30.0),
                          bottomLeft:  Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                        border: Border.all(
                          color: Color.fromRGBO(232, 79, 81, 1),
                        )),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Image.asset('assets/Salud.png',height: 60,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Salud',
                                  style: TextStyle(
                                      fontSize: 16,
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
                ],
              ),
              const SizedBox(width: 30),
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(232, 79, 81, 0.05),
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(30.0),
                          topRight:  Radius.circular(30.0),
                          bottomLeft:  Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                        border: Border.all(
                          color: Color.fromRGBO(232, 79, 81, 1),
                        )),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Image.asset('assets/SaludFamily.png',height: 60,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Salud Familiar',
                                  style: TextStyle(
                                      fontSize: 16,
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
                ],
              ),
            ]
        )
      )
  );
}