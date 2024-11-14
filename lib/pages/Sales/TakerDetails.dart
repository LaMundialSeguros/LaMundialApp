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
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/components/rolBanner.dart';
import 'package:lamundialapp/pages/ForgotPassword.dart';
import 'package:lamundialapp/pages/Sales/BeneficiariesForm.dart';
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

class TakerDetailsPage extends StatefulWidget {
  final Product product;
  const TakerDetailsPage(this.product,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  TakerdetailsPageState createState() => TakerdetailsPageState();
}

class TakerdetailsPageState extends State<TakerDetailsPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  // Taker

    final rol = TextEditingController();
    final identityCard = TextEditingController();
    final name = TextEditingController();
    final lastName = TextEditingController();
    var age = TextEditingController();
    var dateBirth = TextEditingController();



  //Owner

    final idCard = TextEditingController();
    var dateBirthOwner = TextEditingController();
    var ageOwner = TextEditingController();
    final nameOwner = TextEditingController();
    final lastNameOwner = TextEditingController();
    final email = TextEditingController();
    final phone = TextEditingController();
//vehicle

    final brand = TextEditingController();
    var model = TextEditingController();
    var year = TextEditingController();
    final serial = TextEditingController();
    final color = TextEditingController();
    final placa = TextEditingController();

// Taker
  FocusNode rolCodeFocus = FocusNode();
  FocusNode identityCardCodeFocus = FocusNode();
  FocusNode nameCodeFocus = FocusNode();
  FocusNode lastNameCodeFocus = FocusNode();
  FocusNode dateBirthCodeFocus = FocusNode();
  FocusNode ageCodeFocus = FocusNode();
//Owner
  FocusNode idCardCodeFocus = FocusNode();
  FocusNode dateBirthOwnerCodeFocus = FocusNode();
  FocusNode lastNameOwnerCodeFocus = FocusNode();
  FocusNode nameOwnerCodeFocus = FocusNode();
  FocusNode ageOwnerCodeFocus = FocusNode();
  FocusNode emailCodeFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();
//vehicle
  FocusNode brandCodeFocus = FocusNode();
  FocusNode modelCodeFocus = FocusNode();
  FocusNode yearCodeFocus = FocusNode();
  FocusNode serialCodeFocus = FocusNode();
  FocusNode colorCodeFocus = FocusNode();
  FocusNode placaCodeFocus = FocusNode();
  //FocusNode phoneCodeFocus = FocusNode();


  bool isLoading = false;

  var typeDoc = null;
  var country = null;
  var smoker = null;
  var typeDocOwner = null;
  var selectedGender = null;
  var selectedbeneficiary = null;
  var selectedProducer = null;
  var selectedTypeVehicle = null;
  bool individual  =false;
  bool familiar = false;
  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];

  List<Gender> Genders = [
    Gender('Femenino',1),
    Gender('Masculino', 2)
  ];

  List<TypeVehicle> TypeVehicles = [
    TypeVehicle(1,'sedán'),
    TypeVehicle(2,'SUV')
  ];

  List<Producer> Producers = [
    Producer(1,'test 1'),
    Producer(2,'test 2')
  ];

  List<bool> smoke = [false,true];

  List<int> beneficiaries = [0,1,2,3,4,5];

  List<Country> Paises = [
    Country("Venezuela", 1)
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
      // Validar campos nulos
      if (identityCard == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }
      Taker taker = Taker(
                            typeDoc,
                            idCard.text,
                            name.text,
                            lastName.text,
                            dateBirth.text
                          );

      DetailsOwner owner = DetailsOwner(
          typeDocOwner,
          identityCard.text,
          nameOwner.text,
          lastNameOwner.text,
          selectedGender,
          dateBirthOwner.text,
          smoker,
          country,
          phone.text,
          email.text,
          selectedbeneficiary
      );
      var vehicle = null;
      if(widget.product.id == 6 || widget.product.id == 7){
            vehicle = Vehicle(
            brand.text,
            model.text,
            year.text,
            color.text,
            placa.text,
            serial.text,
            selectedTypeVehicle
        );
      }


      List <Beneficiary> beneficiaries = [];
      PaymentFrequency paymentFrequency = PaymentFrequency(0,"");

      Policy policy = Policy(
                              taker,
                              owner,
                              selectedProducer,
                              beneficiaries,
                              vehicle,
                              individual,
                              familiar,
                              false,
                              false,
                              false,
                              false,
                              false,
                              false,
                              0.00,
                              "cupon",
                              paymentFrequency,
                              false,
                              false,
                              "");


      Navigator.push(context,MaterialPageRoute(builder: (context) => BeneficiariesFormPage(policy)));
      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Crear una instancia de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales(widget.product.name),
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
    DateTime? selectedDate = DateTime.now();


    Future<void> _selectDate(BuildContext context,int type) async {
      final DateTime? picked = await
      showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),

      );
      if (picked != null && type == 1) {
        setState(() {
          selectedDate = picked;
          dateBirth = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(selectedDate!)}");
          age = TextEditingController(text: "${selectedDate != null ? calculateAge(selectedDate!) : 'N/A'}");
        });
      }else{
        setState(() {
          selectedDate = picked;
          dateBirthOwner = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(selectedDate!)}");
          ageOwner = TextEditingController(text: "${selectedDate != null ? calculateAge(selectedDate!) : 'N/A'}");
        });
      }

    }



    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 25),
          //Detalles del Tomador
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Detalles del Tomador",
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
                            value: typeDoc,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (TypeDoc? newValue) {
                              setState(() {
                                typeDoc = newValue;
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
                            controller: identityCard,
                            focusNode: identityCardCodeFocus,
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
                          width: 150,
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
                            controller: name,
                            focusNode: nameCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nombre',
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
                        Container(
                          width: 150,
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
                            controller: lastName,
                            focusNode: lastNameCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Apellido',
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
                                  controller: dateBirth,
                                  focusNode: dateBirthCodeFocus,
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
                                onPressed: () => _selectDate(context,1),
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
                            controller: age,
                            focusNode: ageCodeFocus,
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
          const SizedBox(height: 25),
          //Detalles del Titular y Beneficiarios
          Container(
                    child: Text(
                      "Detalles del Titular",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          Container(
                    child: Text(
                      "y Beneficiarios",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
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
                            value: typeDocOwner,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (TypeDoc? newValue) {
                              setState(() {
                                typeDocOwner = newValue;
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
                            controller: idCard,
                            focusNode: idCardCodeFocus,
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
                          width: 150,
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
                            controller: nameOwner,
                            focusNode: nameOwnerCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nombre',
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
                        Container(
                          width: 150,
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
                            controller: lastNameOwner,
                            focusNode: lastNameOwnerCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Apellido',
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
                    child: DropdownButtonFormField<Gender>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedGender,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (Gender? newValue) {
                        setState(() {
                          selectedGender = newValue;
                        });
                      },
                      items: Genders.map((Gender gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(gender.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Sexo',
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
                                  controller: dateBirthOwner,
                                  focusNode: dateBirthOwnerCodeFocus,
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
                                onPressed: () => _selectDate(context,2),
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
                            controller: ageOwner,
                            focusNode: ageOwnerCodeFocus,
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
                          width: 150,
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
                          child: DropdownButtonFormField<bool>(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            iconSize: 0,
                            value: smoker,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (bool? newValue) {
                              setState(() {
                                smoker = newValue;
                              });
                            },
                            items: smoke.map((bool s) {
                              return DropdownMenuItem<bool>(
                                value: s,
                                child: Text("${s == true ? "SI" :"NO"}"),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: '¿Fuma?',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
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
                          width: 150,
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
                          child: DropdownButtonFormField<Country>(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            iconSize: 0,
                            value: country,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (Country? newValue) {
                              setState(() {
                                country = newValue;
                              });
                            },
                            items: Paises.map((Country pais) {
                              return DropdownMenuItem<Country>(
                                value: pais,
                                child: Text(pais.name),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: 'País Residencia',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                              contentPadding: EdgeInsets.only(top:6,left: 16),
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
                      ],
                    ),
                  ),
          const SizedBox(height: 20),
          Container(
                    width: 300,
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
                      controller: email,
                      focusNode: emailCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ingrese su correo',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            '', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1), BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 18,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12.0,
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
          const SizedBox(height: 20),
          Container(
                    width: 300,
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
                      controller: phone,
                      focusNode: phoneCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ingrese su teléfono',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            '', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1), BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 18,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12.0,
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
          const SizedBox(height: 30),
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
                    child: DropdownButtonFormField<int>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedbeneficiary,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedbeneficiary = newValue;
                        });
                      },
                      items: beneficiaries.map((int b) {
                        return DropdownMenuItem<int>(
                          value: b,
                          child: Text(b.toString()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Beneficiarios',
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
          //RCV
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 30),
          if(widget.product.id == 6 || widget.product.id == 7)Container(
                    child: Text(
                      "Datos del Vehículo",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 20),
          if(widget.product.id == 6 || widget.product.id == 7)Container(
                    width: 300,
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
                      controller: brand,
                      focusNode: brandCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        hintText: 'Marca',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            '', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1), BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 18,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12.0,
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
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 20),
          if(widget.product.id == 6 || widget.product.id == 7)Container(
                    width: 300,
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
                      controller: model,
                      focusNode: modelCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        hintText: 'Modelo',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            '', // Ruta de tu archivo SVG
                            colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(105, 111, 140, 1), BlendMode.srcIn),
                            width: 20, // Tamaño deseado en ancho
                            height: 18,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12.0,
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
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 20),
          if(widget.product.id == 6 || widget.product.id == 7)Padding(
                    padding: const EdgeInsets.only(left: 50,right: 0),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
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
                            controller: year,
                            focusNode: yearCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Año',
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
                        Container(
                          width: 150,
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
                            controller: color,
                            focusNode: colorCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Color',
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
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 20),
          if(widget.product.id == 6 || widget.product.id == 7)Padding(
                    padding: const EdgeInsets.only(left: 50,right: 0),
                    child: Row(
                      children: [
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
                            controller: placa,
                            focusNode: placaCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Placa',
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
                            controller: serial,
                            focusNode: serialCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Serial',
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
          if(widget.product.id == 6 || widget.product.id == 7)const SizedBox(height: 20),
          if(widget.product.id == 6 || widget.product.id == 7)Container(
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
                    child: DropdownButtonFormField<TypeVehicle>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedTypeVehicle,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (TypeVehicle? newValue) {
                        setState(() {
                          selectedTypeVehicle = newValue;
                        });
                      },
                      items: TypeVehicles.map((TypeVehicle typeVehicle) {
                        return DropdownMenuItem<TypeVehicle>(
                          value: typeVehicle,
                          child: Text(typeVehicle.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Tipo de Vehículo',
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
          const SizedBox(height: 30),
          if(GlobalVariables().user.rol==3)Container(
                    child: Text(
                      "Productor",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          if(GlobalVariables().user.rol==3)const SizedBox(height: 20),
          if(GlobalVariables().user.rol==3)Container(
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
                    child: DropdownButtonFormField<Producer>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedProducer,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (Producer? newValue) {
                        setState(() {
                          selectedProducer = newValue;
                        });
                      },
                      items: Producers.map((Producer producer) {
                        return DropdownMenuItem<Producer>(
                          value: producer,
                          child: Text(producer.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Seleccionar Productor',
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
          // Funerario
          if(widget.product.id == 3 || widget.product.id == 4)const SizedBox(height: 30),
          if(widget.product.id == 3 || widget.product.id == 4)Container(
                    child: Text(
                      "Tipo de Póliza",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          if(widget.product.id == 3 || widget.product.id == 4)const SizedBox(height: 20),
          if(widget.product.id == 3 || widget.product.id == 4)Padding(
                    padding: const EdgeInsets.only(left: 50,right: 0),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 40,
                          child: CheckboxListTile(
                            title: Text(
                                          'Individual',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color.fromRGBO(0, 0, 0, 1),
                                                            fontFamily: 'Poppins')
                                                          ),
                            value: individual,
                            onChanged: (value) {
                              setState(() {
                                individual = value!;
                                familiar = !value;
                              });
                            },
                          )
                        ),
                        Container(
                            width: 150,
                            height: 40,
                            child: CheckboxListTile(
                              title: Text(
                                  'Familiar',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Poppins')
                              ),
                              value: familiar,
                              onChanged: (value) {
                                setState(() {
                                  familiar = value!;
                                  individual = !value;
                                });
                              },
                            )
                        ),
                      ],
                    ),
                  ),
          // Boton
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
          Container(

                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'La Mundial de Seguros C.A. RIF: J-00084644-8',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Inscrita en la Superintendencia de la Actividad Aseguradora bajo el No. 73 ',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Todos los derechos reservados.',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromRGBO(121, 116, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
        ]))));
  }
}
