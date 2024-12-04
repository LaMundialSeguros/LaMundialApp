import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/Class/Currency.dart';
import 'package:lamundialapp/Utilidades/Class/TypeDoc.dart';
import 'package:lamundialapp/Utilidades/Class/TypePayment.dart';
import 'package:lamundialapp/Utilidades/Class/notifyPayment.dart';
import 'package:lamundialapp/components/bannerNotifyPayments.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:image_picker/image_picker.dart';

class NotifyPaymentsForm extends StatefulWidget {
  const NotifyPaymentsForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  NotifyPaymentsFormState createState() => NotifyPaymentsFormState();
}

class NotifyPaymentsFormState extends State<NotifyPaymentsForm> {

  final reference = TextEditingController();
  //final currency = TextEditingController();
  final amount = TextEditingController();
  var date = TextEditingController();
  final identityCard = TextEditingController();

  FocusNode identityCardCodeFocus = FocusNode();
  FocusNode currencyCodeFocus = FocusNode();
  FocusNode dateCodeFocus = FocusNode();
  FocusNode amountCodeFocus = FocusNode();
  FocusNode referenceCodeFocus = FocusNode();

  var typeDoc = null;
  var selectedTypePayment = null;
  var selectedCurrency = null;
  var selectedBankRec = null;
  var selectedBank = null;

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  bool isLoading = false;

  // Lista para almacenar los bancos
  List<Map<String, dynamic>> BankReceptors = [];  // Lista de elementos para el dropdown
  List<Map<String, dynamic>> Banks = [];
  //List<Map<String, dynamic>> TypePayments = [];
  List<TypePayment> TypePayments = [];
  // Lista de elementos para el dropdown
  // Función para obtener datos de la API
  Future<void> apiServiceBankReceptors() async {
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "ctipopago": 2,
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/target-bank'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetBank = jsonResponse['data']['targetBank'];

          setState(() {
            // Convertimos cada elemento en un Map
            BankReceptors = targetBank.map((bank) {
              return {
                'id': bank['cbanco_destino'],
                'name': bank['xbanco'],
              };
            }).toList();
          });
        }
      } else {
        throw Exception('Error al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceBanks() async {
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "itipo": "V",
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/bank'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetBank = jsonResponse['data']['bank'];

          setState(() {
            // Convertimos cada elemento en un Map
            Banks = targetBank.map((bank) {
              return {
                'id': bank['cbanco_destino'],
                'name': bank['xbanco'],
              };
            }).toList();
          });
        }
      } else {
        throw Exception('Error al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiStypeOfPayment() async {
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "itipo": "V",
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/type-of-payment'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetBank = jsonResponse['data']['typePayment'];

          setState(() {
            // Convertimos cada elemento en un Map
            /*TypePayments = targetBank.map((bank) {
              return {
                'id': bank['ctipopago'],
                'name': bank['xtipopago'],
              };
            }).toList();*/

            // Convertimos cada elemento en una instancia de TypePayment
            TypePayments = targetBank.map((bank) {
              return TypePayment.fromJsonApi(bank);
            }).toList();

          });
        }
      } else {
        throw Exception('Error al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  List<Currency> coins = [
    Currency(1,'USD','\$'),
    Currency(2,'Bs','Bs')
  ];

  Future<void> _pickImage(ImageSource source) async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final XFile? pickedFile = await _picker.pickImage(source: source);
    //final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> save() async {
    setState(() {
      isLoading = true;
    });

    try {

      // Validar campos nulos
      if (selectedTypePayment == null ||  selectedCurrency == null ||  selectedBankRec == null ||  selectedBank == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      if (reference.text.isEmpty || amount.text.isEmpty || date.text.isEmpty || identityCard.text.isEmpty) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      NotifyPayment notifyPayment = NotifyPayment(1,typeDoc,identityCard.text,amount.text,date.text,reference.text,selectedTypePayment,selectedCurrency,selectedBankRec,selectedBank);
      /*if(_imageFile != null){
        await sendImageToApi(context,_imageFile!,cedula.text);
      }*/
      // Aquí, además de hacer la consulta del usuario, también almacenas las credenciales
      await apiRegisterPayment(context,notifyPayment);
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
    apiServiceBankReceptors();
    apiServiceBanks();
    apiStypeOfPayment();
  }

  Widget build(BuildContext context) {

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
          date = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(selectedDate!)}");
        });
      }

    }

    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();

    return SingleChildScrollView(child:Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(children: [
                  //RCV
                  const BannerWidgetNotifyPayments(),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: date,
                            focusNode: dateCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              hintText: 'Fecha de Reporte',
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
                          child: DropdownButtonFormField<Currency>(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            iconSize: 0,
                            value: selectedCurrency,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
                              bottomRight: Radius.zero,
                            ),
                            onChanged: (Currency? newValue) {
                              setState(() {
                                selectedCurrency = newValue;
                              });
                            },
                            items: coins.map((Currency currency) {
                              return DropdownMenuItem<Currency>(
                                value: currency,
                                child: Text(currency.name),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
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
                            controller: amount,
                            focusNode: amountCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Monto',
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
                    child: DropdownButtonFormField<TypePayment>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedTypePayment,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (TypePayment? newValue) {
                        setState(() {
                          selectedTypePayment = newValue;
                        });
                      },
                      items: TypePayments.map((TypePayment typePayment) {
                        return DropdownMenuItem<TypePayment>(
                          value: typePayment,
                          child: Text(typePayment.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Tipo de Pago',
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
                  Container(
                      width: 300,
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
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          color: Colors.black,
                        ),
                        iconSize: 0,
                        value: selectedBank,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.zero,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedBank = newValue;
                          });
                        },
                        items: Banks.map((bank) {
                          return DropdownMenuItem(
                            value: bank,
                            child: Text(bank['name'] ?? 'Nombre no disponible'), // Arreglo aquí
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: 'Banco Emisor',
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
                      )
                  ),
                  const SizedBox(height: 20),
                  Container(
                      width: 300,
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
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.black,
                        ),
                        iconSize: 0,
                        value: selectedBankRec,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.zero,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedBankRec = newValue;
                          });
                        },
                        items: BankReceptors.map((bank) {
                          return DropdownMenuItem(
                            value: bank,
                            child: Text(bank['name'] ?? 'Nombre no disponible'), // Arreglo aquí
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: 'Banco Receptor',
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
                      )
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
                      maxLength: 20,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                      ],
                      controller: reference,
                      focusNode: referenceCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Referencia',
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
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: Container(
                            width: 300,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 247, 255, 1),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(98, 162, 232, 0.5), // Color de la sombra
                                  spreadRadius: 1, // Extensión de la sombra
                                  blurRadius: 4, // Difuminado de la sombra
                                  offset: Offset(0, 3), // Desplazamiento de la sombra
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cargar Imagen',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color.fromRGBO(15, 26, 90, 1),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  'assets/upload.png', // Replace with your image path
                                  width: 35, // Set image width (optional)
                                  height: 35, // Set image height (optional)
                                  fit: BoxFit.cover, // Adjust image fitting (optional)
                                ),
                                /*IconButton(
                    icon: Icon(Icons.camera_alt), // Replace with desired icon
                    onPressed: _pickImage,
                  ),*/
                              ],
                            )
                        )),
                  ),
                  const SizedBox(height: 20),
                  if(_imageFile != null) Center(
                    child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: 150,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(246, 247, 255, 1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(98, 162, 232, 0.5), // Color de la sombra
                                spreadRadius: 1, // Extensión de la sombra
                                blurRadius: 4, // Difuminado de la sombra
                                offset: Offset(0, 3), // Desplazamiento de la sombra
                              ),
                            ],
                          ),
                          child: Image.file(_imageFile!),
                        )),
                  ),
                  const SizedBox(height: 20),
                  // Boton
                  Container(
                    width: 380,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //print(selectedRol.name);
                            save();
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
                            'Notificar Pago',
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
                  const SizedBox(height: 20),
                ])))));
  }
}