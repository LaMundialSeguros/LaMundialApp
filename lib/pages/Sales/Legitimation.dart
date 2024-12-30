// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/BancoPlazaForm.dart';
import 'package:lamundialapp/pages/Sales/PaymentMethod.dart';
import 'package:lamundialapp/pages/Sales/SyPagoForm.dart';
import 'package:lamundialapp/pages/Sales/TermsAndConditions.dart';
import 'package:lamundialapp/pages/Sales/VerifyPayment.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


final localAuth = LocalAuthentication();

class LegitimationPage extends StatefulWidget {
  final Policy policy;
  const LegitimationPage(this.policy,{Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  LegitimationPageState createState() => LegitimationPageState();
}

class LegitimationPageState extends State<LegitimationPage> {


  final _currentHealthDetails = TextEditingController();

  FocusNode _currentHealthDetailsFocus = FocusNode();

  bool isLoading = false;

  bool _selected = false;
  bool _isCheckedSi = false;
  bool _isCheckedNo = true;
  bool _currentHealth = false;

  int auto = 24;
  int moto = 22;
  int fourInOne = 5;
  int funeral = -1;
  int family = 7;
  int life = 3;

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {

      Policy policy = widget.policy;

      if(_isCheckedSi){
        policy.PoliticianExposed = true;
      }else{
        policy.PoliticianExposed = false;
      }

      policy.currentHealth = _currentHealth;
      policy.additionalText = _currentHealthDetails.text;

      //Navigator.push(context,MaterialPageRoute(builder: (context) => PaymentMethod(policy)));
      Navigator.push(context,MaterialPageRoute(builder: (context) => SyPagoFormPage(policy)));
      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales("Legitimación"),
      body:SingleChildScrollView(child: Builder(
        builder: (BuildContext context) {
          return buildForm(context); // Pasa el contexto obtenido
        },
      ))
    );
  }

  Widget buildForm(BuildContext context) {
    void _onCheckboxChanged(bool? value, bool isSi) {
      setState(() {
        if (isSi) {
          _isCheckedSi = value!;
          _isCheckedNo = !_isCheckedSi;
        } else {
          _isCheckedNo = value!;
          _isCheckedSi = !_isCheckedNo;
        }
      });
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          color: Colors.transparent,
          //margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Text(
                "Es usted o algún familiar de su círculo íntimo una persona expuesta políticamente.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins"
                ),
              ),
              Container(
                width: 250,
                child: Row(
                  children: [
                    Expanded(child:
                    CheckboxListTile(
                      title: Text("Si"),
                      value: _isCheckedSi,
                        onChanged: (value) => _onCheckboxChanged(value, true),
                    )),
                    Expanded( child:
                    CheckboxListTile(
                      title: Text("No"),
                      value: _isCheckedNo,
                      onChanged: (value) => _onCheckboxChanged(value, false),
                    )),
                  ],
                ),
              ),
              Divider(),
              Text(
                "Declaro que acepto todos los mecanismos electrónicos dispuestos por "
                "La Mundial de Seguros C.A., para la contratación de la presente póliza.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins"
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => TermsAndConditionsPage(widget.policy)));
                },
                child: Text(
                  "Ver términos y condiciones",
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins"
                  ),
                ),
              ),
              Divider(),
              /*if(widget.policy.product.id != auto || widget.policy.id != auto)Row(
                children: [
                  Checkbox(
                    value: _currentHealth,
                    onChanged: (value) {
                      setState(() {
                        _currentHealth = !_currentHealth;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Declaro que no conozco, ni he sido diagnosticado con alguna enfermedad o "
                      "condición grave de salud que ponga en riesgo mi integridad física o "
                      "mi vida. Por lo que afirmo que me encuentro en buen Estado de Salud.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),*/
              /*if(widget.policy.product.id != auto || widget.policy.product.id != moto)const SizedBox(height: 10),*/
              /*if(widget.policy.product.id != auto || widget.policy.product.id != moto)Visibility(
                visible: _currentHealth,
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.zero,
                      topRight:  Radius.circular(40.0),
                      bottomLeft:  Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 50,  // Limita la longitud del texto (ajusta según tus necesidades)
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),  // Solo letras y números
                    ],
                    maxLines: 5,
                    controller: _currentHealthDetails,
                    focusNode: _currentHealthDetailsFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      hintText: 'Descripción...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle:
                      TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),*/
              const SizedBox(height: 50),
              Container(
                width: 380,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //print(selectedRol.name);
                        Save();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: const Color.fromRGBO(232, 79, 81, 1),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          )),
    );
  }
}
