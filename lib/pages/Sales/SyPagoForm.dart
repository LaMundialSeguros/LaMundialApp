// ignore_for_file: avoid_print

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
  const SyPagoFormPage(this.policy,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  SyPagoFormPagePageState createState() => SyPagoFormPagePageState();
}

class SyPagoFormPagePageState extends State<SyPagoFormPage> {
    @override
    void initState() {
      super.initState();
      cargarBancos();
      totalBs.text  = widget.policy.basicSumInsured.toString();
      totalUSD.text  = widget.policy.basicSumInsuredUSD.toString();
    }

    bool isLoading = false;

    var typeDoc = null;
    final identityCard = TextEditingController();
    FocusNode identityCardCodeFocus = FocusNode();

    final phone = TextEditingController();
    FocusNode phoneCodeFocus = FocusNode();
    final totalBs = TextEditingController();
    final totalUSD = TextEditingController();


    var codeSelected = null;
    var bancoSelected = null;

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];

    List<Banco> parseBancos(String responseBody) {
      final parsed = json.decode(responseBody)['data'] as List;
      return parsed.map((json) => Banco.fromJson(json)).toList();
    }

  List<String> codePhone = ['0424','0414','0412','0416'];

  List<Banco> bancos = [];

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {
      apiServiceSyPago();
      // Resto del código...
    } catch (e) {
      // Manejar errores si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> apiServiceSyPago() async {
        final url = Uri.parse('https://lmchat.lamundialdeseguros.com/send-payment-request');
        final headers = {'Content-Type': 'application/json'};
        String cedula = typeDoc.id+identityCard.text;
        String codigoBanco = bancoSelected.code;
        String celular = codeSelected+phone.text;
        double amount = double.parse(totalBs.text);
        final body = jsonEncode({
          'userData':{
              'cedula': cedula,
              'codigoBanco': codigoBanco,
              'celular': celular
          },
          'amount': amount,
        });

        try {
          final response = await http.post(url,headers: headers,body: body);

          if (response.statusCode == 200) {
            Policy policy = widget.policy;
            Navigator.push(context,MaterialPageRoute(builder: (context) => otpCodePage(policy,cedula,amount,codigoBanco,celular)));
          } else {
            throw Exception('Error al enviar los datos. Código: ${response.statusCode}');
          }

      } catch (e) {
        print('Excepción: $e');
      }
    }

    // Función para cargar los bancos desde la API
  Future<void> cargarBancos() async {
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
                bancoSelected = bancos[0]; // Seleccionar el primer banco por defecto
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
          isLoading = false; // Ocultar el indicador de carga
        });
      }
    }

    void mostrarError(String mensaje) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }

// Crear una instancia de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales("SYPAGO"),
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

          const SizedBox(height: 50),
          bannerSyPago(),
          const SizedBox(height: 50),
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
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                            ],
                            controller: identityCard,
                            focusNode: identityCardCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
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
                          width: 120,
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
                          child: DropdownButtonFormField(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            iconSize: 0,
                            value: codeSelected,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                codeSelected = newValue;
                              });
                            },
                            items: codePhone.map((code) {
                              return DropdownMenuItem(
                                value: code,
                                child: Text(code,style:TextStyle(fontSize: 12)),
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
                          width: 180,
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
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                            ],
                            controller: phone,
                            focusNode: phoneCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Telefono',
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
                    child: DropdownButtonFormField<Banco>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: bancoSelected,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
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
                          child: Text(banco.name,style:TextStyle(fontSize: 12)),
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
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(98, 162, 232, 0.5),
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
                            ],
                            controller: totalUSD,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '',
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
                            color: Color.fromRGBO(98, 162, 232, 0.5),
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
                            ],
                            controller: totalBs,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '',
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
          const SizedBox(height: 30)
        ]))));
  }
}
