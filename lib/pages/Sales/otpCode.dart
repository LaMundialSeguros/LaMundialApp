// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Banco.dart';
import 'package:lamundialapp/Utilidades/Class/Currency.dart';
import 'package:lamundialapp/Utilidades/Class/Default.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/TypePayment.dart';
import 'package:lamundialapp/Utilidades/Class/notifyPayment.dart';
import 'package:lamundialapp/components/bannerSyPago.dart';
import 'package:lamundialapp/pages/Productor/WelcomeProducer.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utilidades/Class/TypeDoc.dart';
import 'package:http/http.dart' as http;


final localAuth = LocalAuthentication();

class otpCodePage extends StatefulWidget {
  final Policy policy;
  final String cedula;
  final double amount;
  final String banco;
  final String celular;
  const otpCodePage(this.policy,this.cedula,this.amount,this.banco,this.celular,{Key? key}) : super(key: key);

  @override

  otpCodePageState createState() => otpCodePageState();
}

class otpCodePageState extends State<otpCodePage> {
    @override
    void initState() {
      super.initState();
    }

    bool isLoading = false;

    var typeDoc = null;
    final code = TextEditingController();
    FocusNode codeCodeFocus = FocusNode();

  Future<void> apiServiceOTP() async {
      final url = Uri.parse('https://lmchat.lamundialdeseguros.com/send-otp');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'userData':{
          'nombre': widget.policy.taker.name+' '+widget.policy.taker.lastName,
          'cedula': widget.cedula,
          'codigoBanco': widget.banco,
          'celular': widget.celular
        },
        'amount': widget.amount,
        'otp': code.text,
      });

      try {
        final response = await http.post(url,headers: headers,body: body);

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body) as Map<Object, dynamic>;
          if(decoded['success'] == true){
            switch (widget.policy.product.id) {
              case 24:
                apiServiceAuto();
                break;
            }
          }

        } else {
          throw Exception('Error al enviar los datos. Código: ${response.statusCode}');
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al validar el codigo , por favor volver a intentar.')),
        );
        print('Excepción: $e');
      }
    }

  String formatearFecha(String fechaString, String formatoSalida) {
      List<String> partesFecha = fechaString.split("/");
      int dia = int.parse(partesFecha[0]);
      int mes = int.parse(partesFecha[1]);
      int anio = int.parse(partesFecha[2]);

      DateTime fecha = DateTime(anio, mes, dia);
      DateFormat formatter = DateFormat(formatoSalida);
      String fechaFormateada = formatter.format(fecha);

      return fechaFormateada;
  }



  Future<void> apiServiceAuto() async {
      final url = Uri.parse('https://qaapisys2000.lamundialdeseguros.com/api/v1/emissions/auto');
      final headers = {
                        'Content-Type': 'application/json',
                        'apikey':'2baed164561a8073ba1d3b45bc923e3785517b5dc0668eda178b0c87b7c3598c'
                      };

      var productor = "0";

      DateTime dateTime = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedDate = formatter.format(dateTime);


      final body = jsonEncode({
          'plan': widget.policy.plan,
          'tipo_cedula_tomador': widget.policy.taker.typeDoc.id,
          'rif_tomador': widget.policy.taker.iDcard,
          'nombre_tomador': widget.policy.taker.name,
          'apellido_tomador':widget.policy.taker.lastName,
          'fnac_tomador':formatearFecha(widget.policy.taker.Birthdate,'yyyy-MM-dd'),
          'tipo_cedula_titular':widget.policy.detailsOwner.typeDoc.id,
          'rif_titular':widget.policy.detailsOwner.idCard,
          'nombre_titular':widget.policy.detailsOwner.name,
          'apellido_titular':widget.policy.detailsOwner.lastName,
          'fnac_titular':formatearFecha(widget.policy.detailsOwner.birthDate,'yyyy-MM-dd'),
          'telefono_titular':widget.policy.detailsOwner.phone,
          'correo_titular':widget.policy.detailsOwner.email,
          'marca':widget.policy.vehicle!.brand.id,
          'modelo':widget.policy.vehicle!.modelId,
          'version':widget.policy.vehicle!.versionId,
          'año':widget.policy.vehicle!.year,
          'color':widget.policy.vehicle!.color,
          'placa':widget.policy.vehicle!.placa,
          'serial_carroceria':widget.policy.vehicle!.serial,
          'dec_persona_politica':widget.policy.PoliticianExposed,
          'dec_term_y_cod':widget.policy.currentHealth,
          'productor':productor,
          'frecuencia':widget.policy.paymentFrequency,
          'fecha_emision':formattedDate
      });

      try {
        final response = await http.post(url,headers: headers,body: body);
        final decoded = json.decode(response.body) as Map<Object, dynamic>;
        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La poliza fue emitida con exito')),
          );

          if(widget.policy.id != null){
            await sendImageToApi(context,widget.policy.id!,widget.policy.detailsOwner.idCard);
          }
          if(widget.policy.rif != null){
            await sendImageToApi(context,widget.policy.rif!,widget.policy.detailsOwner.idCard);
          }
          if(widget.policy.auto != null){
            await sendImageToApi(context,widget.policy.auto!,widget.policy.detailsOwner.idCard);
          }

          NotifyPayment notifyPayment = NotifyPayment(
              1,
              widget.policy.taker.typeDoc,
              widget.policy.taker.iDcard,
              widget.amount.toString(),
              formattedDate,
              decoded['transaction_id'],
              TypePayment(2,'Transferencia'),
              Currency(2,'Bs','Bs'),
              Default(2,"Banca Amiga"),
              Banco(code: 'widget.banco', name: 'Banco emisor')
          );

          await apiRegisterPayment(context,notifyPayment);

        } else if(decoded['status'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decoded['message'])),
          );

        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de conexion con el serivdor.')),
          );
          throw Exception('Error al enviar los datos. Código: ${response.statusCode}');
        }

      } catch (e) {
        print('Excepción: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excepción: $e')),
        );
      }
    }

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });
    try {
      apiServiceOTP();
    } catch (e) {
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
      appBar: CustomAppBarSales("SYPAGO OTP"),
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
          const SizedBox(height: 300),
          Container(
                    child: Text(
                      "Introduzca el código OTP",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          Container(
                    child: Text(
                      "enviado a su celular.",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          const SizedBox(height: 50),
          Padding(
                    padding: const EdgeInsets.only(left: 50,right: 0),
                    child: Row(
                      children: [
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
                            maxLength: 10,
                            inputFormatters: [
                              //FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                            ],
                            controller: code,
                            focusNode: codeCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Codigo OTP',
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
          const SizedBox(height: 50),
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
                    //apiServiceAuto();
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
