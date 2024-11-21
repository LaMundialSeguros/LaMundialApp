// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
//import 'package:lamundialapp/components/square_tile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/Utilidades/Class/Relative.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/rolBanner.dart';
import 'package:lamundialapp/pages/ForgotPassword.dart';
import 'package:lamundialapp/pages/Sales/RiskStatement.dart';
import 'package:lamundialapp/pages/loginPageClient.dart';
import 'package:lamundialapp/pages/login_page.dart';
import 'package:lamundialapp/pages/secretCode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utilidades/Class/Gender.dart';
import '../../Utilidades/Class/Method.dart';
import '../../Utilidades/Class/TypeDoc.dart';
import '../../Utilidades/Class/Vehicle.dart';
import '../../components/logo.dart';


final localAuth = LocalAuthentication();

class RelativesFormPage extends StatefulWidget {
  final Policy policy;
  const RelativesFormPage(this.policy,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  RelativesFormPageState createState() => RelativesFormPageState();
}

class RelativesFormPageState extends State<RelativesFormPage> {
  final List<TextEditingController> _identityCard = [];
  final List<TextEditingController> _dateBirth = [];
  final List<TextEditingController> _age = [];

  final List<FocusNode> _identityCardCodeFocus = [];
  final List<FocusNode> _dateBirthCodeFocus = [];
  final List<FocusNode> _ageCodeFocus = [];


  final List _selectedRelationship = [null,null,null,null,null];
  final List _selectedTypeDocs = [null,null,null,null,null];
  int relatives = 0;

  bool isLoading = false;

  List<Relationship> Relationships = [
    Relationship(1,'Madre'),
    Relationship(2,'Padre'),
    Relationship(3,'Hijo/a'),
    Relationship(4,'Esposa/o'),
    Relationship(5,'Hermano/a'),
  ];

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];


  // Poliza a gestionar
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int monthDifference = currentDate.month - birthDate.month;

    if (monthDifference < 0 || (monthDifference == 0 && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }


  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {

      Policy policy = widget.policy;

      for (int i = 0; i < widget.policy.familyQuantity; i++) {
        var relative = Relative(_selectedTypeDocs[i],_identityCard[i].text,_dateBirth[i].text,_selectedRelationship[i]);
        policy.relatives.add(relative);
      }

      Navigator.push(context,MaterialPageRoute(builder: (context) => RiskStatementPage(policy)));
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
  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales("Familiares"),
      body:Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
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
    );
  }

  Widget buildForm(BuildContext context) {

    DateTime? selectedDate = DateTime.now();

    relatives = widget.policy.familyQuantity;
    _identityCard.addAll(List.generate(relatives, (_) => TextEditingController()));
    _dateBirth.addAll(List.generate(relatives, (_) => TextEditingController()));
    _age.addAll(List.generate(relatives, (_) => TextEditingController()));
    _identityCardCodeFocus.addAll(List.generate(relatives, (_) => FocusNode()));
    _dateBirthCodeFocus.addAll(List.generate(relatives, (_) => FocusNode()));
    _ageCodeFocus.addAll(List.generate(relatives, (_) => FocusNode()));

    int i=0;


    Future<void> _selectDate(BuildContext context,int index) async {
      final DateTime? picked = await
      showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),

      );
        setState(() {
          selectedDate = picked;
          _dateBirth[index] = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(selectedDate!)}");
          _age[index] = TextEditingController(text: "${selectedDate != null ? calculateAge(selectedDate!) : 'N/A'}");
        });

    }

    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: ListView.builder(
                itemCount: relatives, //// CAMBIAR POR LA CANTIDAD DE BENEFICIARIOS
                itemBuilder: (context, index) {
                  i++;
                  return Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Familiar",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(15, 26, 90, 1),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(// Color de fondo gris
                                    borderRadius: BorderRadius.only(
                                      topLeft:  Radius.zero,
                                      topRight:  Radius.circular(30.0),
                                      bottomLeft:  Radius.circular(30.0),
                                      bottomRight: Radius.zero,
                                    ),
                                    border: Border.all(
                                      color: Color.fromRGBO(79, 127, 198, 1),
                                    )),
                                child: DropdownButtonFormField<TypeDoc>(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                  iconSize: 0,
                                  value: _selectedTypeDocs[index],
                                  borderRadius: BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(30.0),
                                    bottomLeft:  Radius.circular(30.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  onChanged: (TypeDoc? newValue) {
                                    setState(() {
                                      _selectedTypeDocs[index] = newValue;
                                    });
                                  },
                                  items: TypeDocs.map((TypeDoc tipoDoc) {
                                    return DropdownMenuItem<TypeDoc>(
                                      value: tipoDoc,
                                      child: Text(tipoDoc.name),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 35),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)),
                                    suffixIcon: Container(
                                      padding: EdgeInsets.only(right: 0),
                                      child: Icon(Icons.keyboard_arrow_down_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                height: 40,
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
                                  controller: _identityCard[index],
                                  focusNode: _identityCardCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Cédula de Identidad',
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 0),
                          child: Row(
                            children: [
                              Container(
                                width: 200,
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: _dateBirth[index],
                                        focusNode: _dateBirthCodeFocus[index],
                                        style: const TextStyle(
                                          color: Colors.black, // Color del texto
                                          fontFamily: 'Poppins',
                                          // Otros estilos de texto que desees aplicar
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Fecha de Nacimiento',
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(top: 0,bottom: 8,right: 0,left: 20),
                                          hintStyle: TextStyle(
                                              color: Color.fromRGBO(121, 116, 126, 1),
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Image.asset("assets/calendar.png",width: 20,height: 20,),
                                      onPressed: () => _selectDate(context,index),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 40,
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
                                  readOnly: true,
                                  controller: _age[index],
                                  focusNode: _ageCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Edad',
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 0),
                          child: Row(
                            children: [
                              Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(// Color de fondo gris
                                    borderRadius: BorderRadius.only(
                                      topLeft:  Radius.zero,
                                      topRight:  Radius.circular(30.0),
                                      bottomLeft:  Radius.circular(30.0),
                                      bottomRight: Radius.zero,
                                    ),
                                    border: Border.all(
                                      color: Color.fromRGBO(79, 127, 198, 1),
                                    )),
                                child: DropdownButtonFormField<Relationship>(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                  iconSize: 0,
                                  value: _selectedRelationship[index],
                                  borderRadius: BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(30.0),
                                    bottomLeft:  Radius.circular(30.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  onChanged: (Relationship? newValue) {
                                    setState(() {
                                      _selectedRelationship[index] = newValue;
                                    });
                                  },
                                  items: Relationships.map((Relationship relationship) {
                                    return DropdownMenuItem<Relationship>(
                                      value: relationship,
                                      child: Text(relationship.name),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: 'Parentesco',
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
                            ],
                          ),
                        ),
                        // Boton
                        if(relatives==i)const SizedBox(height: 50),
                        if(relatives==i)Container(
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
                        if(relatives==i)const SizedBox(height: 30)
                      ]
                  );
                },
                                      ))));
  }
}
