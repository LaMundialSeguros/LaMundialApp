// ignore_for_file: avoid_print, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, unused_field


import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/SyPagoForm.dart';
import 'package:lamundialapp/pages/Sales/TermsAndConditions.dart';

final localAuth = LocalAuthentication();

class LegitimationPage extends StatefulWidget {
  final Policy policy;
  const LegitimationPage(this.policy,{Key? key}) : super(key: key);
  @override
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

      Navigator.push(context,MaterialPageRoute(builder: (context) => SyPagoFormPage(policy)));

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
      appBar: const CustomAppBarSales("Legitimación"),
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
              const Text(
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
                      title: const Text("Si"),
                      value: _isCheckedSi,
                        onChanged: (value) => _onCheckboxChanged(value, true),
                    )),
                    Expanded( child:
                    CheckboxListTile(
                      title: const Text("No"),
                      value: _isCheckedNo,
                      onChanged: (value) => _onCheckboxChanged(value, false),
                    )),
                  ],
                ),
              ),
              const Divider(),
              const Text(
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
                child: const Text(
                  "Ver términos y condiciones",
                  //textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins"
                  ),
                ),
              ),
              const Divider(),
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
