// ignore_for_file: avoid_print, non_constant_identifier_names, unused_local_variable, no_leading_underscores_for_local_identifiers, unnecessary_import, unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/VerifyPayment.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


final localAuth = LocalAuthentication();

class RiskStatementAutoPage extends StatefulWidget {
  final Policy policy;
  const RiskStatementAutoPage(this.policy,{Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  RiskStatementAutoPageState createState() => RiskStatementAutoPageState();
}

class RiskStatementAutoPageState extends State<RiskStatementAutoPage> {


  final hematologicalDiseasesPolicyDetails = TextEditingController();
  final endocrineDiseasesPolicyDetails = TextEditingController();
  final cardiovascularDiseasesPolicyDetails = TextEditingController();

  FocusNode hematologicalDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode endocrineDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode cardiovascularDiseasesPolicyDetailsFocus = FocusNode();

  bool isLoading = false;

  bool _dataPolicy = false;
  bool _moneyPolitic = false;

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {
      Policy policy = widget.policy;

      policy.dataPolicy = _dataPolicy;
      policy.moneyPolitics = _moneyPolitic;

      Navigator.push(context,MaterialPageRoute(builder: (context) => VerifyPaymentPage(policy)));
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
    bool _isChecked = false;
    return Scaffold(
      appBar: const CustomAppBarSales("Declaración de Riesgo"),
      body:SingleChildScrollView(child: Builder(
        builder: (BuildContext context) {
          return buildForm(context); // Pasa el contexto obtenido
        },
      ))
    );
  }

  Widget buildForm(BuildContext context) {
    String? _comment;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          color: Colors.transparent,
          //margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _dataPolicy,
                    onChanged: (value) {
                      setState(() {
                        _dataPolicy = !_dataPolicy;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Declaro que todos los datos proporcionados son ciertos, completos, libres de falsificación, reticencia y omisión. "
                      "y Autorizo a cualquier institución u organismo público o privado para que antes o después de un evento cubierto por la "
                      "póliza suministre cualquier dato de interés para el asegurador.",

                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _moneyPolitic,
                    onChanged: (value) {
                      setState(() {
                        _moneyPolitic = !_moneyPolitic;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Doy fe que el dinero utilizado para el pago de la prima de la Póliza cuya suscripción en este acto solicito, "
                      "proviene de una fuente lícita y por lo tanto, no tiene relación alguna con dinero, capitales, bienes, haberes, "
                      "títulos o beneficios derivados de las actividades ilícitas o de los delitos de Legitimación de Capitales "
                      "y Financiamiento del Terrorismo.",

                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
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
