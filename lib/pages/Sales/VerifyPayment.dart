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
import 'package:lamundialapp/pages/Sales/TakerDetails.dart'; // <-- Ensure this path is correct
import 'package:lamundialapp/pages/Sales/VerifyDetails.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final localAuth = LocalAuthentication();

class VerifyPaymentPage extends StatefulWidget {
  final Policy policy;
  const VerifyPaymentPage(this.policy, {Key? key}) : super(key: key);

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

  Maplan? selectedPlan;
  Frecuencia? selectedFrequency;
  List<Maplan> maplans = [];
  List<Frecuencia> frecuencias = [];

  double totalBs = 0;
  double totalUSD = 0;

  @override
  void initState() {
    super.initState();
    // Fetch planes if product.id == 24
    if (widget.policy.product.id == 56 || widget.policy.product.id == 57) {
      apiServiceGetPlanesAuto();
    }
    // Initialize total amounts
    totalBs = widget.policy.basicSumInsured;
    totalUSD = widget.policy.basicSumInsuredUSD;
  }

  Future<void> apiServiceGetPlanesAuto() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/app/getPlanesAuto');
    final headers = {'Content-Type': 'application/json'};

    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime dateTime;
    try {
      dateTime = format.parse(widget.policy.detailsOwner.birthDate);
    } catch (e) {
      print('Error parsing birth date: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha de nacimiento inválida.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final body = jsonEncode({
      'id_insurance': widget.policy.product.id,
      'xcorreo': GlobalVariables().user.email, // Ensure GlobalVariables().user.email is accessible and not null
      'asegurados': [
        {
          'cparen': 1,
          'nedad_asegurado': calculateAge(dateTime),
        }
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(jsonData);
        setState(() {
          maplans = apiResponse.result.maplanes;
          if (maplans.isNotEmpty) {
            selectedPlan = maplans[0];
            totalBs = selectedPlan!.plan[0].primaPlanBs; //sumaAseguradaPlanBs
            totalUSD = selectedPlan!.plan[0].primaPlanExt; //sumaAseguradaPlanExt
            frecuencias = selectedPlan!.frecuencias;
            // Set the first frequency as default if available
            if (frecuencias.isNotEmpty) {
              selectedFrequency = frecuencias[0];
            }
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión al cargar datos. Código: ${response.statusCode}'),
          ),
        );
        throw Exception('Error al cargar datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 1) Validate logic with dynamic JSON
  Future<bool> apiServiceValidateAuto() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/external/validateEmissionAuto');
    final headers = {
      'Content-Type': 'application/json',
      'apikey': '2baed164561a8073ba1d3b45bc923e3785517b5dc0668eda178b0c87b7c3598c', // Replace with your actual API key
    };
    var productor = "0";

    DateTime dateTime = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(dateTime);

    // Dynamic JSON based on Policy data
    final body = jsonEncode({
      'plan': widget.policy.plan, // Ensure this is set before validation
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
      'fecha_emision': formattedDate
    });

    // Print the entire request body for debugging
    print('Validation Request Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);
      
      // Print the entire response for debugging
      print('Validation Response Status: ${response.statusCode}');
      print('Validation Response Body: ${response.body}');

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        if (decoded['status'] == false) {
          // Extract error message
          String errorMessage = decoded['result']?['error'] ?? 'Validación fallida.';
          
          // Show SnackBar with the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 3),
            ),
          ).closed.then((reason) {
            // Navigate to TakerDetailsPage after the SnackBar is closed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakerDetailsPage(widget.policy.product),
              ),
            );
          });
          return false;
        } else {
          // If validated => return true
          return true;
        }
      } else {
        // Non-200 => show error
        String error = decoded['message'] ?? 'Error desconocido durante la validación.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${response.statusCode}: $error')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción: $e')),
      );
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 2) If validate => proceed with normal logic
  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Only validate if product is 24
      if (widget.policy.product.id == 56 || widget.policy.product.id == 57) {
        // Ensure a plan is selected
        if (selectedPlan == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, seleccione un plan.')),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }

        // Ensure a frequency is selected
        if (selectedFrequency == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, seleccione una frecuencia de pago.')),
          );

          
          setState(() {
            isLoading = false;
          });
          return;
        }

         // Ensure totalBs and totalUSD are not 0
      if (totalBs == 0 || totalUSD == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El monto total no puede ser 0.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

        // Assign selectedPlan and selectedFrequency to policy before validation
        widget.policy.plan = selectedPlan!.plan[0].cplan;
        widget.policy.basicSumInsured = totalBs;
        widget.policy.basicSumInsuredUSD = totalUSD;
        widget.policy.paymentFrequency = selectedFrequency!.ifrecuencia;

        // Perform validation
        final bool isValid = await apiServiceValidateAuto();
        if (!isValid) {
          // If validation fails, navigation is handled in apiServiceValidateAuto()
          return;
        }
      }

      // If we get here => validation passed or different product
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyDetails(widget.policy)),
      );
    } catch (e) {
      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
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

    if (monthDifference < 0 ||
        (monthDifference == 0 && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String formatearFecha(String fechaString, String formatoSalida) {
    List<String> partesFecha = fechaString.split("/");
    if (partesFecha.length != 3) {
      // Handle invalid date format
      return '0000-00-00';
    }
    int dia = int.parse(partesFecha[0]);
    int mes = int.parse(partesFecha[1]);
    int anio = int.parse(partesFecha[2]);

    DateTime fecha = DateTime(anio, mes, dia);
    DateFormat formatter = DateFormat(formatoSalida);
    String fechaFormateada = formatter.format(fecha);

    return fechaFormateada;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              "Suma asegurada básica",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(15, 26, 90, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
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
              child: DropdownButtonFormField<Maplan>(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                iconSize: 0,
                value: selectedPlan,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (Maplan? newValue) {
                  setState(() {
                    selectedPlan = newValue;
                    if (selectedPlan != null) {
                      totalBs = selectedPlan!.plan[0].primaPlanBs;
                      totalUSD = selectedPlan!.plan[0].primaPlanExt;
                      frecuencias = selectedPlan!.frecuencias;
                      // Optionally reset selectedFrequency if it doesn't exist in new frecuencias
                      if (!frecuencias.contains(selectedFrequency)) {
                        selectedFrequency = null;
                      }
                    }
                  });
                },
                items: maplans.map((maplan) {
                  return DropdownMenuItem<Maplan>(
                    value: maplan,
                    child: Text(
                      maplan.plan[0].xplan,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
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
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Frecuencia de pago",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(15, 26, 90, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
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
              child: DropdownButtonFormField<Frecuencia>(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                iconSize: 0,
                value: selectedFrequency,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (Frecuencia? newValue) {
                  setState(() {
                    selectedFrequency = newValue;
                  });
                },
                items: frecuencias.map((Frecuencia f) {
                  return DropdownMenuItem<Frecuencia>(
                    value: f,
                    child: Text(f.xdescripcion),
                  );
                }).toList(),
                decoration: const InputDecoration(
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
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Example for product ID == 2 => extension familiar
            if (widget.policy.product.id == 2) ...[
              const Text(
                "Extensión Familiar",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(15, 26, 90, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.policy.relatives.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "${widget.policy.relatives[index].relationship.name} UDS 999.99",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              "TOTAL",
              style: TextStyle(
                fontSize: 32,
                color: Color.fromRGBO(15, 26, 90, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "usd $totalUSD",
              style: const TextStyle(
                fontSize: 26,
                color: Color.fromRGBO(15, 26, 90, 1),
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "Bs $totalBs",
              style: const TextStyle(
                fontSize: 26,
                color: Color.fromRGBO(15, 26, 90, 1),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
