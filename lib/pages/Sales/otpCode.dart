// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:lamundialapp/Utilidades/Class/User.dart';

import 'package:flutter/gestures.dart'; // for TapGestureRecognizer
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
import 'package:lamundialapp/pages/Sales/SuccessDetails.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

import '../../Utilidades/Class/TypeDoc.dart';

final localAuth = LocalAuthentication();

bool isButtonDisabled = false;
int countdown = 0;
Timer? _timer;

class otpCodePage extends StatefulWidget {
  final Policy policy;

  /// From SyPagoFormPage, we also pass these 4 fields:
  final String cedula;      // e.g., "V14209140"
  final double amount;      // total in Bs
  final String banco;       // e.g., "0105"
  final String celular;     // e.g., "04144412141"

  const otpCodePage(
    this.policy,
    this.cedula,
    this.amount,
    this.banco,
    this.celular, {
    Key? key,
  }) : super(key: key);

  @override
  otpCodePageState createState() => otpCodePageState();
}

class otpCodePageState extends State<otpCodePage> {
  bool isLoading = false;
  bool otpRequested = false; // Tracks if the user has attempted validation once

  // For typed OTP code
  final code = TextEditingController();
  FocusNode codeCodeFocus = FocusNode();

  // For "re-send" cooldown
  DateTime? lastResentTime;
  final Duration resendCooldown = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();

    // Reset countdown and button state every time this page is created,
    // ensuring a fresh start if user left and returned.
    isButtonDisabled = false;
    countdown = 0;
  }

  /// Dispose method cancels any active timers to avoid memory leaks if user leaves.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 1) Re-sends a new OTP code by calling the same endpoint used in SyPagoFormPage: /send-payment-request
  ///    This does NOT validate the typed code; it simply instructs the server to send a fresh OTP via SMS.
  Future<void> apiServiceSyPagoResend() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse('https://lmchat.lamundialdeseguros.com/send-payment-request');
      final headers = {'Content-Type': 'application/json'};

      // For demonstration we hard-code the userData.
      // In a real scenario, you'd pass widget.cedula, widget.banco, widget.celular:
      final body = jsonEncode({
        'userData': {
          'cedula': widget.cedula,
          'codigoBanco': widget.banco,
          'celular': widget.celular,
        },
        'amount': widget.amount,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        if (decoded['success'] == true) {
          // The server re-sent the code
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nuevo código enviado')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decoded['message'] ?? 'Error reenviando el código.')),
          );
        }
      } else {
        throw Exception('Error reenviando. Código HTTP: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo reenviar el código. Error: $e'),
        ),
      );
      print('Excepción re-enviando OTP: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 2) Validates the typed OTP code by calling /send-otp,
  ///    if success => proceed with final emission (auto or otherwise).
  Future<void> apiServiceValidateOTP() async {
    setState(() {
      isLoading = true;
      otpRequested = true;
    });

    final url = Uri.parse('https://lmchat.lamundialdeseguros.com/send-otp');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'userData': {
        'nombre': '${widget.policy.taker.name} ${widget.policy.taker.lastName}',
        'cedula': widget.cedula,
        'codigoBanco': widget.banco,
        'celular': widget.celular,
      },
      'amount': widget.amount,
      'otp': code.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        if (decoded['status'] == 'ACCP') {
          // The OTP is correct => proceed with final emission
          switch (widget.policy.product.id) {
            case 56:
              // If product = 24 is auto
              apiServiceAuto(decoded['transaction_id']);
              break;
            case 57:
              // If product = 25 is moto
              apiServiceAuto(decoded['transaction_id']);
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("OTP validado correctamente.")),
              );
              setState(() => isLoading = false);
              break;
          }
          } else if (decoded['status'] == 'RJCT') {
        // Failure: Show rejection message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded['message'] ?? 'OTP rechazado.')),
        );
        setState(() => isLoading = false);
      
        } else {
          // success == false => invalid code or error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decoded['message'] ?? 'OTP inválido.')),
          );
           setState(() => isLoading = false);
        }
      } else {
        throw Exception('Error al validar OTP. Código: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al validar el código, Excepción: $e',
          ),
        ),
      );
      print('Excepción validando OTP: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 3) If product = 24 => Emission flow for auto
  Future<void> apiServiceAuto(String transactionId) async {
    setState(() => isLoading = true);

    final url = Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/emissions/auto');
    final headers = {
      'Content-Type': 'application/json',
      'apikey': '2baed164561a8073ba1d3b45bc923e3785517b5dc0668eda178b0c87b7c3598c',
    };

    final dateTime = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final formattedDate = formatter.format(dateTime);

    final body = jsonEncode({
      'plan': widget.policy.plan,
      'tipo_cedula_tomador': widget.policy.taker.typeDoc.id,
      'rif_tomador': widget.policy.taker.iDcard,
      'nombre_tomador': widget.policy.taker.name,
      'apellido_tomador': widget.policy.taker.lastName,
      'fnac_tomador': formatearFecha(widget.policy.taker.Birthdate, 'yyyy-MM-dd'),
      'tipo_cedula_titular': widget.policy.detailsOwner.typeDoc.id,
      'rif_titular': widget.policy.detailsOwner.idCard,
      'nombre_titular': widget.policy.detailsOwner.name,
      'apellido_titular': widget.policy.detailsOwner.lastName,
      'fnac_titular': formatearFecha(widget.policy.detailsOwner.birthDate, 'yyyy-MM-dd'),
      'telefono_titular': widget.policy.detailsOwner.phone,
      'correo_titular': widget.policy.detailsOwner.email,
      'marca': widget.policy.vehicle!.brand.id,
      'modelo': widget.policy.vehicle!.modelId,
      'version': widget.policy.vehicle!.versionId,
      'año': widget.policy.vehicle!.year,
      'color': widget.policy.vehicle!.color,
      'placa': widget.policy.vehicle!.placa,
      'serial_carroceria': widget.policy.vehicle!.serial,
      'dec_persona_politica': widget.policy.PoliticianExposed,
      'dec_term_y_cod': true,
      'productor': GlobalVariables().user.cedula,
      'frecuencia': widget.policy.paymentFrequency,
      'fecha_emision': formattedDate,
    });


String getPolicyType(int productId) {
  switch (productId) {
    case 56:
      return "R.C.V. Auto";
    case 57:
      return "R.C.V. Moto";
    default:
      return "Producto Desconocido"; // Default for other product IDs
  }
}



    try {
      final response = await http.post(url, headers: headers, body: body);
      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && decoded['status'] == true) {
        final cnrecibo = decoded['data']['cnrecibo'];
        final cnpoliza = decoded['data']['cnpoliza']; // Policy number
        final urlpoliza = decoded['data']['urlpoliza']; // Extract the policy URL



        // Upload images (Taker's ID, Owner's ID, RIF, etc.) if exist
        if (widget.policy.id != null) {
          await sendImageToApi(context, widget.policy.id!, widget.policy.detailsOwner.idCard);
        }
        if (widget.policy.ownerId != null) {
          await sendImageToApi(context, widget.policy.ownerId!, widget.policy.detailsOwner.idCard);
        }
        if (widget.policy.rif != null) {
          await sendImageToApi(context, widget.policy.rif!, widget.policy.detailsOwner.idCard);
        }
        if (widget.policy.auto != null) {
          await sendImageToApi(context, widget.policy.auto!, widget.policy.detailsOwner.idCard);
        }

        // Register payment
        final notifyPayment = NotifyPayment(
          1,
          widget.policy.taker.typeDoc,
          widget.policy.taker.iDcard,
          widget.amount.toString(),
          formattedDate,
          transactionId,
          TypePayment(2, 'Transferencia'),
          Currency(2, 'Bs', 'Bs'),
          Default(31, "Sypago"),
          Default(31, "Sypago"),
        );
        await apiRegisterPayment(context, notifyPayment, cnrecibo);


        setState(() => isLoading = false);


        // Navigate to some success page (SuccessDetails)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessDetails(
              policyType: getPolicyType(widget.policy.product.id),
              cnpoliza: cnpoliza,
              transactionId: transactionId,
            ),
          ),
          (Route<dynamic> route) => false, // This clears all previous routes
        );


      } else if (decoded['status'] == false) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded['message'] ?? 'Error desconocido')),
        );
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexion con el servidor.')),
        );
        throw Exception('Error al enviar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción: $e')),
      );
    }
  }

  /// Utility to convert 'dd/MM/yyyy' to 'yyyy-MM-dd'
  String formatearFecha(String fechaString, String formatoSalida) {
    final partesFecha = fechaString.split("/");
    final dia = int.parse(partesFecha[0]);
    final mes = int.parse(partesFecha[1]);
    final anio = int.parse(partesFecha[2]);

    final fecha = DateTime(anio, mes, dia);
    final formatter = DateFormat(formatoSalida);
    return formatter.format(fecha);
  }


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
              child: buildForm(context),
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
              const SizedBox(height: 300),
              // Title
              const Text(
                "Introduzca el código OTP",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(15, 26, 90, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              // Subtitle
              const Text(
                "enviado a su celular.",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(15, 26, 90, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 50),

              // OTP code TextField
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 0),
                child: Row(
                  children: [
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
                      child: TextField(
                        maxLength: 10,
                        controller: code,
                        focusNode: codeCodeFocus,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: 'Codigo OTP',
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
              const SizedBox(height: 50),
              const SizedBox(height: 50),

              // "Pagar" button
              Container(
                width: 380,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: isButtonDisabled
                          ? null
                          : () {
                              setState(() {
                                isButtonDisabled = true;
                                countdown = 30;
                                isLoading = true;
                              });

                              // Start countdown for "Pagar ($countdown)" ONLY after pressing the button
                              _timer = Timer.periodic(
                                const Duration(seconds: 1),
                                (timer) {
                                  setState(() {
                                    if (countdown > 0) {
                                      countdown--;
                                    } else {
                                      isButtonDisabled = false;
                                      timer.cancel();
                                    }
                                  });
                                },
                              );
                             // const transactionId = '1234567890';
                             // apiServiceAuto(transactionId);  
                              // This calls the validation method
                              apiServiceValidateOTP();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: isButtonDisabled
                            ? Colors.grey
                            : const Color.fromRGBO(232, 79, 81, 1),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: Text(
                        isButtonDisabled ? 'Pagar ($countdown)' : 'Pagar',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
    
                    // "¿No recibió su código?" -> Reintentar link
                    // Only show after user first attempts OTP (otpRequested = true) & if the button isn't disabled
                    if (!isButtonDisabled && otpRequested)
                      RichText(
                        text: TextSpan(
                          text: "¿No recibió su código? ",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: "Reinténtelo aquí",
                              style: const TextStyle(
                                color: Color.fromRGBO(15, 26, 90, 1),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final now = DateTime.now();
                                  if (lastResentTime == null ||
                                      now.difference(lastResentTime!) >= resendCooldown) {
                                    setState(() => isLoading = true);
                                    lastResentTime = now;

                                    // We call the new re-send method
                                    await apiServiceSyPagoResend();

                                    setState(() => isLoading = false);
                                  } else {
                                    // Still in cooldown
                                    final remaining = resendCooldown - now.difference(lastResentTime!);
                                    final minutes = remaining.inMinutes;
                                    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Por favor, espere $minutes:$seconds antes de solicitar un nuevo código.",
                                        ),
                                      ),
                                    );
                                  }
                                },
                            ),
                          ],
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
