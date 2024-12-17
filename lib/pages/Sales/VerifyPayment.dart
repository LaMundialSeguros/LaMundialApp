// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Amount.dart';
import 'package:lamundialapp/Utilidades/Class/ApiResponse.dart';
import 'package:lamundialapp/Utilidades/Class/Frecuencia.dart';
import 'package:lamundialapp/Utilidades/Class/Maplan.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/Legitimation.dart';
import 'package:lamundialapp/pages/Sales/VerifyDetails.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


final localAuth = LocalAuthentication();

class VerifyPaymentPage extends StatefulWidget {
  final Policy policy;
  const VerifyPaymentPage(this.policy,{Key? key}) : super(key: key);
  //const VerifyPaymentPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  VerifyPaymentPageState createState() => VerifyPaymentPageState();
}

class VerifyPaymentPageState extends State<VerifyPaymentPage> {

  final hematologicalDiseasesPolicyDetails = TextEditingController();
  final endocrineDiseasesPolicyDetails = TextEditingController();
  final cardiovascularDiseasesPolicyDetails = TextEditingController();

  FocusNode hematologicalDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode endocrineDiseasesPolicyDetailsFocus = FocusNode();
  FocusNode cardiovascularDiseasesPolicyDetailsFocus = FocusNode();

  bool isLoading = false;

  var selectedFrequency = null;
  var selectedPlan = null;
  var planes = null;
  List<Maplan> maplans = [];
  List<Frecuencia> frecuencias = [];

  double totalBs   = 0;
  double totalUSD  = 0;

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {

      Policy policy = widget.policy;
      policy.plan  = selectedPlan.plan[0].cplan;
      policy.basicSumInsured  = totalBs;
      policy.basicSumInsuredUSD  = totalUSD;
      policy.paymentFrequency = selectedFrequency.ifrecuencia;

      Navigator.push(context,MaterialPageRoute(builder: (context) => VerifyDetails(policy)));
      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int monthDifference = currentDate.month - birthDate.month;

    if (monthDifference < 0 || (monthDifference == 0 && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> apiServiceGetPlanesAuto() async {
    final url = Uri.parse('https://qaapisys2000.lamundialdeseguros.com/api/v1/app/getPlanesAuto');
    final headers = {'Content-Type': 'application/json'};
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(widget.policy.detailsOwner.birthDate);
    final body = jsonEncode({
      'id_insurance': widget.policy.product.id,
      'xcorreo': GlobalVariables().user.email,
      'asegurados': [
        {
          'cparen': 1,
          'nedad_asegurado': calculateAge(dateTime),
        }
      ],
    });

    try {
      final response = await http.post(url,headers: headers,body: body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(jsonData);
        setState(() {
          maplans = apiResponse.result.maplanes;
        });

      } else {
        throw Exception('Error al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }
  @override
  void initState() {

    super.initState();
    switch (widget.policy.product.id) {
      case 24:
        apiServiceGetPlanesAuto();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;
    return Scaffold(
      appBar: CustomAppBarSales("Verificar Pago"),
      body: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(0),
              child: Builder(
                builder: (BuildContext context) {
                  return buildForm(context); // Pasa el contexto obtenido
                },
              ),
              //buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {

    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Center(
            child: Column(children: [
              const SizedBox(height: 25),
              Container(
                child: Text(
                  "Suma asegurada básica",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(// Color de fondo gris
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.zero,
                      topRight:  Radius.circular(40.0),
                      bottomLeft:  Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    )),
                child: DropdownButtonFormField<Maplan>(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                  iconSize: 0,
                  value: selectedPlan,
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.zero,
                    topRight:  Radius.circular(40.0),
                    bottomLeft:  Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  onChanged: (Maplan? newValue) {
                    setState(() {
                      selectedPlan = newValue;
                      totalBs   = selectedPlan.plan[0].sumaAseguradaPlanBs;
                      totalUSD  = selectedPlan.plan[0].sumaAseguradaPlanExt;
                      frecuencias = selectedPlan.frecuencias;
                    });
                  },
                  items: maplans.map((maplan) {
                    return DropdownMenuItem<Maplan>(
                      value: maplan,
                      child: Text(maplan.plan[0].xplan,style:TextStyle(fontSize: 10)),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Planes',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    suffixIcon: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Text(
                  "Frecuencia de pago",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(// Color de fondo gris
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.zero,
                      topRight:  Radius.circular(40.0),
                      bottomLeft:  Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    )),
                child: DropdownButtonFormField<Frecuencia>(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                  iconSize: 0,
                  value: selectedFrequency,
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.zero,
                    topRight:  Radius.circular(40.0),
                    bottomLeft:  Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  onChanged: (Frecuencia? newValue) {
                    setState(() {
                      selectedFrequency = newValue;
                    });
                  },
                  items: frecuencias.map((Frecuencia PaymentF) {
                    return DropdownMenuItem<Frecuencia>(
                      value: PaymentF,
                      child: Text(PaymentF.xdescripcion),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Frecuencia de pago',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    suffixIcon: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if(widget.policy.product.id == 2)Container(
                child: Text(
                  "Extensión Familiar",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
              if(widget.policy.product.id == 2)Expanded(
                child:ListView.builder(
                  itemCount: widget.policy.relatives.length,
                  itemBuilder: (context, index) {
                    return  Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(widget.policy.relatives[index].relationship.name+" "+"UDS 999.99",
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins'),
                          )
              ],
              ),
              );
              },
              )),
              const SizedBox(height: 20),
              Container(
                child: Text(
                  "TOTAL",
                  style: TextStyle(
                      fontSize: 32,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
              Container(
                child: Text(
                  "usd $totalUSD",
                  style: TextStyle(
                      fontSize: 26,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontFamily: 'Poppins'),
                ),
              ),
              Container(
                child: Text(
                  "Bs $totalBs",
                  style: TextStyle(
                      fontSize: 26,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontFamily: 'Poppins'),
                ),
              ),
              // Boton
              const SizedBox(height: 20),
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
              const SizedBox(height: 50),
            ])));
  }
}
