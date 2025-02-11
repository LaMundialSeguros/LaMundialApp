// ignore: unused_fieldignore: unused_field, ignore_for_file: avoid_print a, unused_field, unused_field, non_constant_identifier_names, avoid_unnecessary_containers, unused_field

// ignore_for_file: unused_field, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/Legitimation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

final localAuth = LocalAuthentication();

class VerifyDetails extends StatefulWidget {
  final Policy policy;
  const VerifyDetails(this.policy, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  VerifyDetailsPageState createState() => VerifyDetailsPageState();
}

class VerifyDetailsPageState extends State<VerifyDetails> {
  @override
  void initState() {
    super.initState();
    identityCard.text = widget.policy.taker.iDcard;
    typeIdentityCard.text = widget.policy.taker.typeDoc.name;
    name.text = widget.policy.taker.name;
    lastName.text = widget.policy.taker.lastName;
    age.text = calculateAge(widget.policy.taker.Birthdate).toString();
    dateBirth.text = widget.policy.taker.Birthdate;

    idCard.text = widget.policy.detailsOwner.idCard;
    typeIdentityCardOwner.text = widget.policy.detailsOwner.typeDoc.name;
    nameOwner.text = widget.policy.detailsOwner.name;
    lastNameOwner.text = widget.policy.detailsOwner.lastName;
    sexo.text = widget.policy.detailsOwner.gender.name;
    dateBirthOwner.text = widget.policy.detailsOwner.birthDate;
    ageOwner.text =
        calculateAge(widget.policy.detailsOwner.birthDate).toString();
    if (widget.policy.detailsOwner.smoker) {
      smoker.text = 'SI';
    } else {
      smoker.text = 'NO';
    }
    country.text = widget.policy.detailsOwner.county.name;
    email.text = widget.policy.detailsOwner.email;
    phone.text = widget.policy.detailsOwner.phone;
    year.text = widget.policy.vehicle!.year.toString();
    color.text = widget.policy.vehicle!.color.toString();
    brand.text = widget.policy.vehicle!.brand.name;
    model.text = widget.policy.vehicle!.model.toString();
    version.text = widget.policy.vehicle!.version.toString();
    placa.text = widget.policy.vehicle!.placa;
    serial.text = widget.policy.vehicle!.serial;
    typeVehicle.text = widget.policy.vehicle!.typeVehicle;
  }
  // Taker

  final rol = TextEditingController();
  final identityCard = TextEditingController();
  final typeIdentityCard = TextEditingController();
  final name = TextEditingController();
  final lastName = TextEditingController();
  var age = TextEditingController();
  var dateBirth = TextEditingController();

  //Owner

  final idCard = TextEditingController();
  final typeIdentityCardOwner = TextEditingController();
  var dateBirthOwner = TextEditingController();
  var ageOwner = TextEditingController();
  final nameOwner = TextEditingController();
  final lastNameOwner = TextEditingController();
  final email = TextEditingController();
  final sexo = TextEditingController();
  final phone = TextEditingController();
  final typeVehicle = TextEditingController();
  final smoker = TextEditingController();
  final country = TextEditingController();

//vehicle

  final brand = TextEditingController();
  var model = TextEditingController();
  var year = TextEditingController();
  final serial = TextEditingController();
  final color = TextEditingController();
  final placa = TextEditingController();
  final version = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  int auto = 24;
  int moto = 22;
  int fourInOne = 5;
  int funeral = -1;
  int family = 7;
  int life = 3;

  // Poliza a gestionar

  int calculateAge(String birthDate) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(birthDate);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dateTime.year;
    int monthDifference = currentDate.month - dateTime.month;

    if (monthDifference < 0 ||
        (monthDifference == 0 && currentDate.day < dateTime.day)) {
      age--;
    }
    return age;
  }

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LegitimationPage(widget.policy)));
      // Resto del código...
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales(widget.policy.product.product),
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
        child: Form(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 20),
          //Detalles del Tomador
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 0),
            child: const Row(
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
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 10,
                    readOnly: true,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
                    ],
                    controller: typeIdentityCard,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 10,
                    readOnly: true,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
                    ],
                    controller: identityCard,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Cédula de Identidad',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: name,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: lastName,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Apellido',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: dateBirth,
                          style: const TextStyle(
                            color: Colors.black, // Color del texto
                            fontFamily: 'Poppins',
                            // Otros estilos de texto que desees aplicar
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Fecha de Nacimiento',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 8, right: 0, left: 20),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: age,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Edad',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          //Detalles del Titular y Beneficiarios
          Container(
            child: const Text(
              "Detalles del Titular",
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(15, 26, 90, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
          ),
          Container(
            child: const Text(
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
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
                    ],
                    controller: typeIdentityCardOwner,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
                    ],
                    controller: idCard,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Cédula de Identidad',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: nameOwner,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: lastNameOwner,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Apellido',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
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
              color: const Color.fromRGBO(98, 162, 232, 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.zero,
              ),
              border: Border.all(
                color: const Color.fromRGBO(79, 127, 198, 1),
              ), // Borde rojo
            ),
            child: TextField(
              readOnly: true,
              controller: sexo,
              style: const TextStyle(
                color: Colors.black, // Color del texto
                fontFamily: 'Poppins',
                // Otros estilos de texto que desees aplicar
              ),
              decoration: InputDecoration(
                hintText: '',
                //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(1),
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
                hintStyle: const TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: dateBirthOwner,
                          style: const TextStyle(
                            color: Colors.black, // Color del texto
                            fontFamily: 'Poppins',
                            // Otros estilos de texto que desees aplicar
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Fecha de Nacimiento',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 8, right: 0, left: 20),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: ageOwner,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Edad',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(98, 162, 232, 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: const Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: country,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12.0,
                      ),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
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
              color: const Color.fromRGBO(98, 162, 232, 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.zero,
              ),
              border: Border.all(
                color: const Color.fromRGBO(79, 127, 198, 1),
              ), // Borde rojo
            ),
            child: TextField(
              readOnly: true,
              controller: email,
              style: const TextStyle(
                color: Colors.black, // Color del texto
                fontFamily: 'Poppins',
                // Otros estilos de texto que desees aplicar
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese su correo',
                //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(1),
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
                hintStyle: const TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(98, 162, 232, 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.zero,
              ),
              border: Border.all(
                color: const Color.fromRGBO(79, 127, 198, 1),
              ), // Borde rojo
            ),
            child: TextField(
              maxLength: 11,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo permite números
              ],
              controller: phone,
              style: const TextStyle(
                color: Colors.black, // Color del texto
                fontFamily: 'Poppins',
                // Otros estilos de texto que desees aplicar
              ),
              decoration: InputDecoration(
                counterText: '',
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
                hintStyle: const TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          //RCV
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 30),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Container(
              child: const Text(
                "Datos del Vehículo",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      readOnly: true,
                      maxLength: 4,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Solo permite números
                      ],
                      controller: year,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Año',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20.0,
                        ),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      readOnly: true,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Solo permite números
                      ],
                      controller: color,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Color',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20.0,
                        ),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(98, 162, 232, 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: const Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
              ),
              child: TextField(
                readOnly: true,
                controller: brand,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontFamily: 'Poppins',
                  // Otros estilos de texto que desees aplicar
                ),
                decoration: InputDecoration(
                  hintText: '',
                  //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(1),
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
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(98, 162, 232, 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: const Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
              ),
              child: TextField(
                readOnly: true,
                controller: model,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontFamily: 'Poppins',
                  // Otros estilos de texto que desees aplicar
                ),
                decoration: InputDecoration(
                  hintText: '',
                  //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(1),
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
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(98, 162, 232, 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: const Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
              ),
              child: TextField(
                readOnly: true,
                controller: version,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontFamily: 'Poppins',
                  // Otros estilos de texto que desees aplicar
                ),
                decoration: InputDecoration(
                  hintText: '',
                  //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(1),
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
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      readOnly: true,
                      maxLength:
                          10, // Limita la longitud del texto (ajusta según tus necesidades)
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]')), // Solo letras y números
                      ],
                      controller: placa,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Placa',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20.0,
                        ),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(98, 162, 232, 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      readOnly: true,
                      maxLength:
                          30, // Limita la longitud del texto (ajusta según tus necesidades)
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]')), // Solo letras y números
                      ],
                      controller: serial,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Serial',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20.0,
                        ),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(98, 162, 232, 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: const Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
              ),
              child: TextField(
                readOnly: true,
                controller: typeVehicle,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontFamily: 'Poppins',
                  // Otros estilos de texto que desees aplicar
                ),
                decoration: InputDecoration(
                  hintText: 'Tipo de Vehiculo',
                  //errorText: _isValidEmail(email.text) ? null : 'Correo inválido',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(1),
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
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (widget.policy.product.id == auto ||
              widget.policy.product.id == moto)
            const SizedBox(height: 20),
          if (GlobalVariables().user.rol == 3)
            Container(
              child: const Text(
                "Productor",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          if (GlobalVariables().user.rol == 3) const SizedBox(height: 20),
          if (GlobalVariables().user.rol == 3) const SizedBox(height: 20),
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
            child: const Row(
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
            child: const Row(
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
            child: const Row(
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
