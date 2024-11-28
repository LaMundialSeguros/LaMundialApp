// ignore_for_file: avoid_print

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

class RiskStatementPage extends StatefulWidget {
  final Policy policy;
  const RiskStatementPage(this.policy,{Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  RiskStatementPageState createState() => RiskStatementPageState();
}

class RiskStatementPageState extends State<RiskStatementPage> {


  final hematologicalDiseasesPolicyDetails = TextEditingController();
  final endocrineDiseasesPolicyDetails = TextEditingController();
  final cardiovascularDiseasesPolicyDetails = TextEditingController();

  FocusNode hematologicalDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode endocrineDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode cardiovascularDiseasesPolicyDetailsFocus = FocusNode();

  bool isLoading = false;

  bool _dataPolicy = false;
  bool _moneyPolitic = false;
  bool _healthPolicy = false;
  bool _extremeSportsPolicy = false;
  bool _cardiovascularDiseasesPolicy = false;
  bool _endocrineDiseasesPolicy = false;
  bool _hematologicalDiseasesPolicy = false;
  bool _drugsPolicy = false;

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {
      Policy policy = widget.policy;

      policy.dataPolicy = _dataPolicy;
      policy.healthPolicy = _healthPolicy;
      policy.extremeSportsPolicy = _extremeSportsPolicy;
      policy.cardiovascularDiseasesPolicy = _cardiovascularDiseasesPolicy;
      policy.cardiovascularDiseasesPolicyDetails = cardiovascularDiseasesPolicyDetails.text;
      policy.EndocrineDiseasesPolicy = _endocrineDiseasesPolicy;
      policy.EndocrineDiseasesPolicyDetails = endocrineDiseasesPolicyDetails.text;
      policy.hematologicalDiseasesPolicy  = _hematologicalDiseasesPolicy;
      policy.hematologicalDiseasesPolicyDetails = hematologicalDiseasesPolicyDetails.text;
      policy.drugsPolicy  = _drugsPolicy;

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
      appBar: CustomAppBarSales("Declaración de Riesgo"),
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
                  Expanded(
                    child: Text(
                      "Declaro que todos los datos proporcionados son ciertos, completos, libres de falsificación, "
                          "reticencia y omisión. y Autorizo a cualquier institución u organismo público o privado "
                          "para que antes o después de un evento cubierto por la póliza suministre cualquier dato de "
                          "interés para el asegurador.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
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
                  Expanded(
                    child: Text(
                      "Doy fe que el dinero utilizado para el pago de la prima de la Póliza "
                      "cuya suscripción en este acto solicito, proviene de una fuente lícita "
                      "y por lo tanto, no tiene relación alguna con dinero, capitales, bienes, "
                      "haberes, títulos o beneficios derivados de las actividades ilícitas o de los "
                      "delitos de Legitimación de Capitales y Financiamiento del Terrorismo.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _healthPolicy,
                    onChanged: (value) {
                      setState(() {
                        _healthPolicy = !_healthPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Declaro que no conozco, ni he sido diagnosticado con alguna enfermedad o "
                          "condición grave de salud que ponga en riesgo mi integridad física o "
                          "mi vida. Por lo afirmo que me encuentro en buen Estado de Salud.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _extremeSportsPolicy,
                    onChanged: (value) {
                      setState(() {
                        _extremeSportsPolicy = !_extremeSportsPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Declaro que no practico deportes o actividades recreativas o "
                      "profesionales u ocupación de riesgo que pongan en peligro "
                      "mi integridad física o mi vida.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _cardiovascularDiseasesPolicy,
                    onChanged: (value) {
                      setState(() {
                        _cardiovascularDiseasesPolicy = !_cardiovascularDiseasesPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "¿Ha padecido enfermedades cardiovasculares: hipertensión arterial, "
                      "infarto al miocardio, arritmia cardíaca, angina de pecho, fiebre reumática, "
                      "arteriosclerosis, trastornos valvulares, tromboflebitis? En caso de afirmativo, "
                      "indique detalles: Fecha de diagnóstico, Médico tratante, Estado de salud actual.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _cardiovascularDiseasesPolicy,
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
                    controller: cardiovascularDiseasesPolicyDetails,
                    focusNode: cardiovascularDiseasesPolicyDetailsFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      hintText: 'Describa la enfermedad y quién la padece...',
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
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _endocrineDiseasesPolicy,
                    onChanged: (value) {
                      setState(() {
                        _endocrineDiseasesPolicy = !_endocrineDiseasesPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "¿Ha padecido Enfermedades endocrinas: diabetes, obesidad, "
                      "alteraciones del colesterol y triglicéridos? En caso de afirmativo, "
                      "proporcione detalles: Fecha de Diagnóstico, Médico Tratante, estado de salud actual.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _endocrineDiseasesPolicy,
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
                    controller: endocrineDiseasesPolicyDetails,
                    focusNode: endocrineDiseasesPolicyDetailsFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      hintText: 'Describa la enfermedad y quién la padece...',
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
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _hematologicalDiseasesPolicy,
                    onChanged: (value) {
                      setState(() {
                        _hematologicalDiseasesPolicy = !_hematologicalDiseasesPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "¿Ha padecido enfermedades Hematológicas? En caso de afirmativo, "
                      "proporcione detalles: Diagnostico, Fecha de inicio, "
                      "Médico Tratante, Estado de salud actual.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _hematologicalDiseasesPolicy,
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
                    controller: hematologicalDiseasesPolicyDetails,
                    focusNode: hematologicalDiseasesPolicyDetailsFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      hintText: 'Describa la enfermedad y quién la padece...',
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
              ),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _drugsPolicy,
                    onChanged: (value) {
                      setState(() {
                        _drugsPolicy = !_drugsPolicy;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "¿Consume: Tabaco o cigarrillo o cualquier otra droga adictiva? "
                      "En caso de afirmativo, proporcione detalles: "
                      "Fecha de inicio del hábito, Cantidad diaria.",
                      //textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
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
