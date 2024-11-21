// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Amount.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/Legitimation.dart';
import 'package:local_auth/local_auth.dart';
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

  var _paymentFrequency = null;

  late List<Amount> amounts = [
    Amount(1,'USD','1.500,00',3,false),
    Amount(2,'USD','3.000,00',3,false),
    Amount(3,'USD','5.000,00',3,false),
    Amount(4,'USD','10.000,00',2,false),
    Amount(5,'USD','20.000,00',2,false),
    Amount(6,'USD','50.000,00',2,false),
    Amount(6,'USD','100.000,00',2,false)
  ];

  List<PaymentFrequency> paymentFrequencys = [
    PaymentFrequency(1,'Anual'),
    PaymentFrequency(2,'Semestral'),
    PaymentFrequency(3,'Trimestral'),
    PaymentFrequency(4,'Mensual'),
    PaymentFrequency(5,'Semanal')
  ];

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {

      Policy policy = widget.policy;
      for (Amount amount in amounts) {
        if(amount.active){
          policy.basicSumInsured.add(amount);
        }
      }

      policy.paymentFrequency = _paymentFrequency;

      Navigator.push(context,MaterialPageRoute(builder: (context) => LegitimationPage(policy)));
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
      appBar: CustomAppBarSales("Verificar Pago"),
      body:Builder(
        builder: (BuildContext context) {
          return buildForm(context); // Pasa el contexto obtenido
        },
      )
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
              Expanded(
                    child:ListView.builder(
                        itemCount: amounts.length,
                        itemBuilder: (context, index) {
                            return  Container(
                                child: Column(
                                  children: [
                                    if(widget.policy.product.id == amounts[index].productId)Container(
                                      height: 40,
                                      width: 300,
                                      child: CheckboxListTile(
                                        title: Text(amounts[index].currency+" "+amounts[index].amount,
                                          style: TextStyle(
                                          fontSize: 26,
                                          color: Color.fromRGBO(121, 116, 126, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                        ),
                                        value: amounts[index].active,
                                          onChanged: (bool? value) {
                                              setState(() {
                                                  amounts[index].active = value!;
                                              });
                                         },
                                      ),
                                    ),
                      ],
                    ),
                  );
                },
              )),
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
                child: DropdownButtonFormField<PaymentFrequency>(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                  iconSize: 0,
                  value: _paymentFrequency,
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.zero,
                    topRight:  Radius.circular(40.0),
                    bottomLeft:  Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  onChanged: (PaymentFrequency? newValue) {
                    setState(() {
                      _paymentFrequency = newValue;
                    });
                  },
                  items: paymentFrequencys.map((PaymentFrequency PaymentF) {
                    return DropdownMenuItem<PaymentFrequency>(
                      value: PaymentF,
                      child: Text(PaymentF.name),
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
                  "usd 999.99",
                  style: TextStyle(
                      fontSize: 26,
                      color: Color.fromRGBO(15, 26, 90, 1),
                      fontFamily: 'Poppins'),
                ),
              ),
              Container(
                child: Text(
                  "Bs 9999.99",
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
