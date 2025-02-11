// ignore_for_file: avoid_print, non_constant_identifier_names, unused_field, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Banco.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/components/bannerSyPago.dart';
import 'package:lamundialapp/pages/Sales/otpCode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utilidades/Class/TypeDoc.dart';
import 'package:http/http.dart' as http;

final localAuth = LocalAuthentication();

class SyPagoFormPage extends StatefulWidget {
  final Policy policy;
  const SyPagoFormPage(this.policy, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  SyPagoFormPagePageState createState() => SyPagoFormPagePageState();
}

class SyPagoFormPagePageState extends State<SyPagoFormPage> {
  bool isLoading = false;

  // Dropdown/field selections
  TypeDoc? typeDoc;
  String? codeSelected;
  Banco? bancoSelected;

  // Text controllers
  final identityCard = TextEditingController();
  final phone = TextEditingController();
  final totalBs = TextEditingController();
  final totalUSD = TextEditingController();

  // Focus nodes
  FocusNode identityCardCodeFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();

  // Data sets
  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E'),
  ];
  List<String> codePhone = ['0424', '0414', '0412', '0416'];
  List<Banco> bancos = [];

  // Secure storage instance
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // Load the banks from the API
    cargarBancos();

    // Preload total amounts
    totalBs.text = widget.policy.basicSumInsured.toString();
    totalUSD.text = widget.policy.basicSumInsuredUSD.toString();

    // Preload Taker data (typeDoc and idCard)
    try {
      typeDoc = TypeDocs.firstWhere(
        (td) => td.id == widget.policy.taker.typeDoc,
        orElse: () => TypeDocs[0],
      );
      identityCard.text = widget.policy.taker.iDcard;
    } catch (e) {
      print('Error setting typeDoc/idCard from policy.taker: $e');
    }
  }

  Future<void> cargarBancos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse('https://lmchat.lamundialdeseguros.com/fetch-debit-otp-banks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          setState(() {
            bancos = (responseBody['data'] as List)
                .map((json) => Banco.fromJson(json))
                .toList();
            if (bancos.isNotEmpty) {
              // Set default selection to first bank
              bancoSelected = bancos[0];
            }
          });
        } else {
          mostrarError('No se pudieron cargar los bancos.');
        }
      } else {
        mostrarError('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      mostrarError('Ocurrió un error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> Save() async {
  // Validate required fields: typeDoc, identityCard, phone, and codeSelected
  if (typeDoc == null ||
      identityCard.text.trim().isEmpty ||
      phone.text.trim().isEmpty ||
      codeSelected == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Por favor, complete todos los campos obligatorios: Tipo de documento, Cédula, Teléfono y Código telefónico.',
        ),
        duration: Duration(seconds: 3),
      ),
    );
    return; // Stop execution if validation fails
  }
  
  setState(() {
    isLoading = true;
  });

  try {
    await apiServiceSyPago();
  } catch (e) {
    print('Save error: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> apiServiceSyPago() async {
    final url = Uri.parse('https://lmchat.lamundialdeseguros.com/send-payment-request');
    final headers = {'Content-Type': 'application/json'};

    final docId = (typeDoc != null) ? typeDoc!.id : 'V';
    final cedula = docId + identityCard.text;
    final codigoBanco = (bancoSelected != null) ? bancoSelected!.code : '0101';
    final celular = (codeSelected ?? '0414') + phone.text;
    final amount = double.tryParse(totalBs.text) ?? 0.0;

    final body = jsonEncode({
      'userData': {
        'cedula': cedula,
        'codigoBanco': codigoBanco,
        'celular': celular,
      },
      'amount': amount,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final policy = widget.policy;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otpCodePage(policy, cedula, amount, codigoBanco, celular),
          ),
        );
      } else {
        throw Exception('Error al enviar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSales("SYPAGO"),
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
                  return buildForm(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Form(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const bannerSyPago(),
              const SizedBox(height: 50),

              // Row for disabled typeDoc and disabled identityCard
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 0),
                child: Row(
                  children: [
                    // Disabled typeDoc dropdown in same color as amount, but black text
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.zero,
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(79, 127, 198, 1),
                        ),
                      ),
                      child: DropdownButtonFormField<TypeDoc>(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        iconSize: 0,
                        value: typeDoc,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 35,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Container(
                            padding: const EdgeInsets.only(right: 0),
                            child: const Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                        ),
                      ),
                    ),

                    // Disabled identityCard text field in same color as amount
                    Container(
                      width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.zero,
                          ),
                          border: Border.all(
                            color: const Color.fromRGBO(79, 127, 198, 1),
                          ),
                        ),
                        child: TextField(
                          // Removed readOnly to allow editing
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: identityCard,
                          focusNode: identityCardCodeFocus,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Row for phone code and phone
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 0),
                child: Row(
                  children: [
                    // Phone code dropdown with placeholder "Código Tlf."
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.zero,
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(79, 127, 198, 1),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        iconSize: 0,
                        // Make sure codeSelected is null by default so it shows the hint
                        value: codeSelected,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.zero,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            codeSelected = newValue;
                          });
                        },
                        items: codePhone.map((code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(
                              code,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        // "Código Tlf." placeholder
                        decoration: InputDecoration(
                          hintText: 'Cód.',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 35,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          suffixIcon: Container(
                            padding: const EdgeInsets.only(right: 0),
                            child: const Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                        ),
                      ),
                    ),

                    // Phone text field
                    Container(
                      width: 180,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.zero,
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(79, 127, 198, 1),
                        ),
                      ),
                      child: TextField(
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // only numbers
                        ],
                        controller: phone,
                        focusNode: phoneCodeFocus,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: 'Telefono',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20.0,
                          ),
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(121, 116, 126, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bank dropdown
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(79, 127, 198, 1),
                  ),
                ),
                child: DropdownButtonFormField<Banco>(
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  iconSize: 0,
                  value: bancoSelected,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  onChanged: (Banco? newValue) {
                    setState(() {
                      bancoSelected = newValue;
                    });
                  },
                  items: bancos.map((Banco banco) {
                    return DropdownMenuItem<Banco>(
                      value: banco,
                      child: Text(banco.name, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Sexo',
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Row for total USD and total Bs (both readOnly and colored)
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 0),
                child: Row(
                  children: [
                    // totalUSD
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
                        ),
                      ),
                      child: TextField(
                        readOnly: true,
                        maxLength: 50,
                        inputFormatters: [
                          // Only letters/spaces (though not needed for read-only)
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),
                        ],
                        controller: totalUSD,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // totalBs
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
                        ),
                      ),
                      child: TextField(
                        readOnly: true,
                        maxLength: 50,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),
                        ],
                        controller: totalBs,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Pay button
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
                        'Pagar',
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
          ),
        ),
      ),
    );
  }
}
