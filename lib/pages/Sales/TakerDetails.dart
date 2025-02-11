// ignore_for_file: avoid_print, unused_field, avoid_init_to_null, prefer_final_fields, non_constant_identifier_names, unnecessary_string_interpolations, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, prefer_conditional_assignment, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Amount.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/Brand.dart';
import 'package:lamundialapp/Utilidades/Class/CameraOverlayPage.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/Utilidades/Class/Relative.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:lamundialapp/pages/Sales/BeneficiariesForm.dart';
import 'package:lamundialapp/pages/Sales/RelativesForm.dart';
import 'package:lamundialapp/pages/Sales/RiskStatementAuto.dart';

import '../../Utilidades/Class/Gender.dart';
import '../../Utilidades/Class/TypeDoc.dart';
import '../../Utilidades/Class/Vehicle.dart';

final localAuth = LocalAuthentication();

class TakerDetailsPage extends StatefulWidget {
  final Product product;
  const TakerDetailsPage(this.product, {Key? key}) : super(key: key);

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
  final typeVehicle = TextEditingController();

//vehicle

  final brand = TextEditingController();
  var model = TextEditingController();
  var year = TextEditingController();
  final serial = TextEditingController();
  final color = TextEditingController();
  final placa = TextEditingController();

  final ImagePicker _picker = ImagePicker();

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
  FocusNode typeVehicleCodeFocus = FocusNode();
  FocusNode brandCodeFocus = FocusNode();
  FocusNode modelCodeFocus = FocusNode();
  FocusNode yearCodeFocus = FocusNode();
  FocusNode serialCodeFocus = FocusNode();
  FocusNode colorCodeFocus = FocusNode();
  FocusNode placaCodeFocus = FocusNode();
  //FocusNode phoneCodeFocus = FocusNode();

  bool isLoading = false;
  bool _areDifferent = false;

  bool _isUpdatingFromTaker = false;
  bool _isUpdatingFromOwner = false;

  var typeDoc = null;
  var country = null;
  var smoker = null;
  var typeDocOwner = null;
  var selectedGender = null;
  var selectedbeneficiary = null;
  var selectedProducer = null;
  //var selectedTypeVehicle = null;
  var selectedRelatives = null;
  var selectedBrand = null;
  var selectedModel = null;
  var selectedVersion = null;
  var selectedColor = null;

  int auto = 57;
  int moto = 56;
  int fourInOne = 5;
  int funeral = -1;
  int family = 7;
  int life = 3;

  File? _imageFile;
  File? _imageFileAuto;
  File? _imageFileRif;
  //final ImagePicker _picker = ImagePicker();
  String _recognizedText = "Texto reconocido aparecerá aquí.";

  // For Titular/Asegurado
  File? _imageFileOwner;
  final ImagePicker _pickerOwner = ImagePicker();

  // FocusNode for Owner's fields (if needed)
  FocusNode idCardOwnerCodeFocus = FocusNode();

  String extractSpecificId(String text) {
    // RegEx para capturar cédulas con 5 a 9 dígitos (por ejemplo: "V 27.606.5" o "E 12.345.678")
    final regex = RegExp(r'\b[VvEe]\s\d{1,2}(\.\d{3}){1,2}\b');
    final match = regex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }
    return match != null ? match.group(0)! : '';
  }

  String cleanID(String id) {
    // Elimina la letra V, E (mayúsculas o minúsculas) y los espacios iniciales
    id = id.replaceAll(RegExp(r'[VvEe]\s'), '');

    // Elimina los puntos
    id = id.replaceAll('.', '');

    return id;
  }

  String extractOnlyPrefix(String id) {
    // Busca solo el prefijo V o E al inicio de la cadena
    final match = RegExp(r'^[VvEe]').firstMatch(id);

    // Devuelve la letra encontrada en mayúscula o un mensaje si no hay prefijo
    return match != null
        ? match.group(0)!.toUpperCase()
        : 'Prefijo no encontrado';
  }

  String extractName(String text) {
    // RegEx que busca "APELLIDOS" seguido de dos apellidos en mayúsculas
    final regex = RegExp(r'NOMBRES?\s+([A-ZÁÉÍÓÚÑ]+(?:\s[A-ZÁÉÍÓÚÑ]+)*)');
    final match = regex.firstMatch(text);

    if (match != null) {
      // Devuelve los apellidos encontrados después de "APELLIDOS"
      return match.group(1)!;
    } else {
      return '';
    }
  }

  String extractLastName(String text) {
    // RegEx que busca "APELLIDOS" seguido de dos apellidos en mayúsculas
    final regex = RegExp(r'APELLIDOS?\s+([A-ZÁÉÍÓÚÑ]+(?:\s[A-ZÁÉÍÓÚÑ]+)*)');
    final match = regex.firstMatch(text);

    if (match != null) {
      // Devuelve los apellidos encontrados después de "APELLIDOS"
      return match.group(1)!;
    } else {
      return '';
    }
  }

  String? extractDateOfBirth(String text) {
    final regex = RegExp(r'\b(\d{1,2})[-/](\d{1,2})[-/](\d{4})\b');
    final match = regex.firstMatch(text);

    if (match != null) {
      try {
        final date = '${match.group(1)}/${match.group(2)}/${match.group(3)}';
        DateFormat format = DateFormat('dd/MM/yyyy');
        DateTime dateTime = format.parse(date);
        return DateFormat('dd/MM/yyyy').format(dateTime);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String? extractSerial(String input) {
    final regex =
        RegExp(r'Serial\s+N(?:[\.\s]*[A-Za-z]+)*[\.\s]*:?([A-Za-z0-9]+)');
    final match = regex.firstMatch(input);

    // Si se encuentra el prefijo y el serial, lo devuelve sin el prefijo
    if (match != null) {
      return match.group(1); // Retorna el serial limpio
    } else {
      return '';
    }
  }

  String? extractPlaca(String input) {
    // First, try to find a license plate following the word "Placa:"
    // Case-insensitive pattern to detect "Placa:" followed by alphanumeric characters.
    final regex = RegExp(r'Pl?aca:?\s*([A-Za-z0-9]+)', caseSensitive: false);
    final match = regex.firstMatch(input);

    if (match != null) {
      return match.group(1); // Returns the matched license plate value.
    }
    return '';
  }

  String? extractYear(String input) {
    // Patrón para detectar un número de 4 dígitos (año)
    // Regex matches numbers from 1900 to 2100
    final regex = RegExp(r'(?<!\d)((19|20)\d{2}|2100)(?!\d)');
    final match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0); // Retorna el año
    } else {
      return '';
    }
  }

  Future<void> _recognizeTextAuto(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      List<String> datos = recognizedText.text.split('\n');
      String xserial = '';
      String xplaca = '';
      String xyear = '';

      for (String dato in datos) {
        // Extract serial if not yet extracted
        if (xserial.isEmpty) {
          xserial = extractSerial(dato) ?? '';
          if (xserial.isNotEmpty) {
            serial.text = xserial;
          }
        }
        // Extract placa if not yet extracted
        if (xplaca.isEmpty) {
          xplaca = extractPlaca(dato) ?? '';
          if (xplaca.isNotEmpty) {
            placa.text = xplaca;
          }
        }
        // Try to extract year from each line
        if (xyear.isEmpty) {
          xyear = extractYear(dato) ?? '';
        }
      }

      // If year not found in individual lines, search entire recognized text
      if (xyear.isEmpty) {
        xyear = extractYear(recognizedText.text) ?? '';
      }

      // If a year was found, update the year field and call the API
      if (xyear.isNotEmpty) {
        year.text = xyear;
        apiServiceBrand(int.parse(year.text));
      }
    } catch (e) {
      print('Error al reconocer texto: $e');
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      List<String> datos = recognizedText.text.split('\n');
      String id = '';
      String lastNames = '';
      String names = '';
      String dateBirthDay = '';

      for (String dato in datos) {
        // Capture ID
        if (id.isEmpty) {
          id = extractSpecificId(dato);
          identityCard.text = cleanID(id);
          // Only sync to owner if they are not different
          if (!_areDifferent) {
            idCard.text = cleanID(id);
            for (TypeDoc t in TypeDocs) {
              String prefix = extractOnlyPrefix(id);
              if (t.name == prefix) {
                setState(() {
                  typeDoc = t;
                  typeDocOwner = t;
                });
              }
            }
          }
        }

        // Capture Names
        if (names.isEmpty) {
          names = extractName(dato);
          name.text = names;
          if (!_areDifferent) {
            nameOwner.text = names;
          }
        }

        // Capture Last Names
        if (lastNames.isEmpty) {
          lastNames = extractLastName(dato);
          lastName.text = lastNames;
          if (!_areDifferent) {
            lastNameOwner.text = lastNames;
          }
        }

        // Capture Date of Birth with conditional syncing
        if (dateBirthDay.isEmpty) {
          final extractedDate = extractDateOfBirth(dato);
          if (extractedDate != null) {
            dateBirthDay = extractedDate;
            setState(() {
              dateBirth.text = dateBirthDay;
              age.text =
                  calculateAge(DateFormat('dd/MM/yyyy').parse(dateBirthDay))
                      .toString();
            });
            if (!_areDifferent) {
              setState(() {
                dateBirthOwner.text = dateBirthDay;
                ageOwner.text =
                    calculateAge(DateFormat('dd/MM/yyyy').parse(dateBirthDay))
                        .toString();
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error al reconocer texto: $e');
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final XFile? pickedFile = await _picker.pickImage(source: source);
    //final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _recognizeText(_imageFile!);
        //_getImageAndRecognizeText(_imageFile);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImageRif(ImageSource source) async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final XFile? pickedFile = await _picker.pickImage(source: source);
    //final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFileRif = File(pickedFile.path);
        //_recognizeText(_imageFileRif!);
        //_getImageAndRecognizeText(_imageFile);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickImageAuto(ImageSource source) async {
    //final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final XFile? pickedFile = await _picker.pickImage(source: source);
    //final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFileAuto = File(pickedFile.path);
        _recognizeTextAuto(_imageFileAuto!);
        //_getImageAndRecognizeText(_imageFile);
      } else {
        print('No image selected.');
      }
    });
  }

  List<TypeDoc> TypeDocs = [TypeDoc('V', 'V'), TypeDoc('E', 'E')];

  List<Gender> Genders = [Gender('Femenino', 1), Gender('Masculino', 2)];

  List<TypeVehicle> TypeVehicles = [
    TypeVehicle(1, 'sedán'),
    TypeVehicle(2, 'SUV')
  ];

  List<Producer> Producers = [
    Producer(1, 'test 1', '', '', '', '', ''),
    Producer(2, 'test 2', '', '', '', '', '')
  ];

  List<Map<String, dynamic>> models = [];
  List<Map<String, dynamic>> versions = [];
  List<Map<String, dynamic>> colors = [];

  List<bool> smoke = [false, true];

  List<int> beneficiaries = [0, 1, 2, 3, 4, 5];
  List<int> relatives = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  List<Country> Paises = [Country("Venezuela", 1)];

  // Poliza a gestionar

  List<Brand> Brands = [];

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

  Future<void> _pickImageOwner(ImageSource source) async {
    final XFile? pickedFile = await _pickerOwner.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFileOwner = File(pickedFile.path);
        _recognizeTextOwner(_imageFileOwner!);
      } else {
        print('No image selected for Owner.');
      }
    });
  }

// Method to recognize text for Owner
  Future<void> _recognizeTextOwner(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      List<String> datos = recognizedText.text.split('\n');
      String id = '';
      String lastNames = '';
      String names = '';
      String dateBirthDay = '';

      for (String dato in datos) {
        // Capture ID
        if (id.isEmpty) {
          id = extractSpecificId(dato);
          idCard.text = cleanID(id);
          // Optionally, set typeDocOwner if needed
        }

        // Capture Names
        if (names.isEmpty) {
          names = extractName(dato);
          nameOwner.text = names;
        }

        // Capture Last Names
        if (lastNames.isEmpty) {
          lastNames = extractLastName(dato);
          lastNameOwner.text = lastNames;
        }

        // Capture Date of Birth only for Owner
        if (dateBirthDay.isEmpty) {
          final regex = RegExp(r'\b(\d{1,2})[-/](\d{1,2})[-/](\d{4})\b');
          final match = regex.firstMatch(dato);
          if (match != null) {
            String date =
                '${match.group(1)}/${match.group(2)}/${match.group(3)}';
            DateFormat format = DateFormat('dd/MM/yyyy');
            DateTime dateTime = format.parse(date);
            setState(() {
              dateBirthOwner.text =
                  "${DateFormat('dd/MM/yyyy').format(dateTime)}";
              ageOwner.text = "${calculateAge(dateTime)}";
            });
            dateBirthDay = date;
          }
        }
      }
    } catch (e) {
      print('Error al reconocer texto para Owner: $e');
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _openCameraOverlay(Function(XFile) onPictureTaken) async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraOverlayPage(
            camera: firstCamera,
            onPictureTaken: onPictureTaken,
          ),
        ),
      );
    } catch (e) {
      print('Error initializing camera: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error initializing camera.')));
    }
  }

  Future<void> apiServiceBrand(int year) async {
    selectedBrand = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "qano": year,
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/brand'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetBrand = jsonResponse['data']['brand'];

          setState(() {
            // Convertimos cada elemento en una instancia de TypePayment
            Brands = targetBrand.map((brand) {
              return Brand.fromJsonApi(brand);
            }).toList();
          });
        }
      } else {
        SnackBar(
            content: Text(
                'Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception(
            'Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceModels(int year, int brandId) async {
    selectedModel = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({"qano": year, "cmarca": brandId});

    try {
      final response = await http.post(
        Uri.parse(
            'https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/model'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetModel = jsonResponse['data']['model'];

          setState(() {
            // Convertimos cada elemento en un Map
            models = targetModel.map((model) {
              return {
                'id': model['cmodelo'],
                'name': model['xmodelo'],
              };
            }).toList();
          });
        }
      } else {
        SnackBar(
            content: Text(
                'Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception(
            'Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceVersion(int year, int brandId, int modelId) async {
    selectedVersion = null;
    // Cuerpo de la petición en formato JSON
    final body =
        jsonEncode({"qano": year, "cmarca": brandId, "cmodelo": modelId});

    try {
      final response = await http.post(
        Uri.parse(
            'https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/version'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetModel = jsonResponse['data']['version'];

          setState(() {
            // Convertimos cada elemento en un Map
            versions = targetModel.map((model) {
              return {
                'id': model['cversion'],
                'name': model['xversion'],
                'type': model['xclase_rcv'],
              };
            }).toList();
          });
        }
      } else {
        SnackBar(
            content: Text(
                'Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception(
            'Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceColor() async {
    selectedVersion = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({});

    try {
      final response = await http.post(
        Uri.parse(
            'https://apisys2000.lamundialdeseguros.com//api/v1/valrep/color'),
        headers: {
          'Content-Type': 'application/json', // Define el tipo de contenido
          //'Authorization': 'Bearer tu_token', // Si necesitas autenticación
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> targetColor = jsonResponse['data']['color'];

          setState(() {
            // Convertimos cada elemento en un Map
            colors = targetColor.map((color) {
              return {
                'id': color['ccolor'],
                'name': color['xcolor'],
              };
            }).toList();
          });
        }
      } else {
        SnackBar(
            content: Text(
                'Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception(
            'Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
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

  Future<bool> apiServiceValidateAuto(Policy policy) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://apisys2000.lamundialdeseguros.com/api/v1/external/validateEmissionAuto');
    final headers = {
      'Content-Type': 'application/json',
      'apikey':
          '2baed164561a8073ba1d3b45bc923e3785517b5dc0668eda178b0c87b7c3598c',
    };
    var productor = "0";

    DateTime dateTime = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(dateTime);

    final body = jsonEncode({
      'plan': 'Auto',
      'tipo_cedula_tomador': policy.taker.typeDoc.id,
      'rif_tomador': policy.taker.iDcard,
      'nombre_tomador': policy.taker.name,
      'apellido_tomador': policy.taker.lastName,
      'fnac_tomador': formatearFecha(policy.taker.Birthdate, 'yyyy-MM-dd'),
      'tipo_cedula_titular': policy.detailsOwner.typeDoc.id,
      'rif_titular': policy.detailsOwner.idCard,
      'nombre_titular': policy.detailsOwner.name,
      'apellido_titular': policy.detailsOwner.lastName,
      'fnac_titular':
          formatearFecha(policy.detailsOwner.birthDate, 'yyyy-MM-dd'),
      'telefono_titular': policy.detailsOwner.phone,
      'correo_titular': policy.detailsOwner.email,
      'marca': policy.vehicle!.brand.id,
      'modelo': policy.vehicle!.modelId,
      'version': policy.vehicle!.versionId,
      'año': policy.vehicle!.year,
      'color': policy.vehicle!.color,
      'placa': policy.vehicle!.placa,
      'serial_carroceria': policy.vehicle!.serial,
      'dec_persona_politica': policy.PoliticianExposed,
      'dec_term_y_cod': true,
      'productor': GlobalVariables().user.cedula,
      'frecuencia': 'A',
      'fecha_emision': formattedDate
    });

    print('Validation Request Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Validation Response Status: ${response.statusCode}');
      print('Validation Response Body: ${response.body}');

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        if (decoded['status'] == false) {
          String errorMessage =
              decoded['result']?['error'] ?? 'Validación fallida.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 3),
            ),
          );
          return false;
        } else {
          return true;
        }
      } else {
        String error =
            decoded['message'] ?? 'Error desconocido durante la validación.';
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

  Future<void> Save() async {
    // Only validate if the checkbox is checked
    if (_areDifferent && identityCard.text.trim() == idCard.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'La cédula del tomador y titular no pueden ser iguales. Por favor, modifíquelas.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop further execution if validation fails
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (smoker == null) {
        smoker = false;
      }

      // **Age Validation**
      int takerAge = int.tryParse(age.text) ?? 0;
      int ownerAge = int.tryParse(ageOwner.text) ?? 0;
      if (takerAge < 18 || ownerAge < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Los menores de edad no están permitidos.')),
        );
        return; // Stop further execution
      }

      // New Vehicle Data Validation
      if (widget.product.id == auto || widget.product.id == moto) {
        if (typeVehicle.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Complete los datos del vehículo.')),
          );
          return; // Stop if vehicle data is incomplete
        }
        // Additional check for unconfigured vehicle
        if (typeVehicle.text.trim() == "Vehículo no está configurado.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'El vehículo no está configurado. Por favor, seleccione otra opción o contacte con el administrador.')),
          );
          return; // Prevent continuation if vehicle type is not configured
        }
        // Check if selectedColor is not chosen
        if (selectedColor == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Por favor, seleccione un color para el vehículo.')),
          );
          return; // Stop execution until color is selected
        }
      }
      if (typeDoc == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Por favor, seleccione el tipo de documento del tomador')));
        // Dropdowns might not accept focus directly, so we just notify the user.
        return;
      }

      if (_areDifferent && typeDocOwner == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Por favor, seleccione el tipo de documento del titular')));
        return;
      }

      if (identityCard.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Por favor, ingrese la cédula del tomador')));
        FocusScope.of(context).requestFocus(identityCardCodeFocus);
        return;
      }

      if (name.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Por favor, ingrese el nombre del tomador')));
        FocusScope.of(context).requestFocus(nameCodeFocus);
        return;
      }

      if (lastName.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Por favor, ingrese el apellido del tomador')));
        FocusScope.of(context).requestFocus(lastNameCodeFocus);
        return;
      }

      if (dateBirth.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Por favor, ingrese la fecha de nacimiento del tomador')));
        FocusScope.of(context).requestFocus(dateBirthCodeFocus);
        return;
      }

      if (selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, seleccione el sexo')));
        // Focus might not work for dropdown; just notify.
        return;
      }

      if (email.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Por favor, ingrese el correo electrónico')));
        FocusScope.of(context).requestFocus(emailCodeFocus);
        return;
      }

      if (phone.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, ingrese el teléfono')));
        FocusScope.of(context).requestFocus(phoneCodeFocus);
        return;
      }

      // If product is auto/moto, check vehicle-specific fields
      if (widget.product.id == auto || widget.product.id == moto) {
        if (typeVehicle.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Complete los datos del vehículo')));
          FocusScope.of(context).requestFocus(typeVehicleCodeFocus);
          return;
        }
        if (selectedColor == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Por favor, seleccione un color para el vehículo')));
          return;
        }
      }

      Taker taker = Taker(
          typeDoc, identityCard.text, name.text, lastName.text, dateBirth.text);

      DetailsOwner owner = DetailsOwner(
          typeDocOwner,
          idCard.text,
          nameOwner.text,
          lastNameOwner.text,
          selectedGender,
          dateBirthOwner.text,
          smoker ?? false,
          country,
          phone.text,
          email.text,
          selectedbeneficiary ?? 0);
      var vehicle = null;
      if (widget.product.id == auto || widget.product.id == moto) {
        vehicle = Vehicle(
            selectedBrand,
            selectedModel['name'],
            selectedModel['id'],
            selectedVersion['name'],
            selectedVersion['id'],
            year.text,
            selectedColor['name'],
            selectedColor['id'],
            placa.text,
            serial.text,
            typeVehicle.text);
      }

      if (selectedRelatives == null) {
        selectedRelatives = 0;
      }

      List<Beneficiary> beneficiaries = [];
      List<Relative> relatives = [];
      List<Amount> amounts = [];

      Policy policy = Policy(
        widget.product,
        taker,
        owner,
        selectedProducer,
        beneficiaries,
        selectedRelatives,
        relatives,
        vehicle,
        false,
        false,
        false,
        false,
        false,
        "",
        false,
        "",
        false,
        "",
        false,
        "",
        0,
        0,
        "xxxxxx",
        "",
        false,
        false,
        "",
        id: _imageFile, // taker's image
        rif: _imageFileRif, // rif image
        auto: _imageFileAuto, // auto image
        ownerId: _areDifferent ? _imageFileOwner : null,
      );

      // Validate vehicle details via API for auto/moto products
      if (widget.product.id == auto || widget.product.id == moto) {
        bool valid = await apiServiceValidateAuto(policy);
        if (!valid) {
          return; // Stop if validation fails
        }
      }

      switch (widget.product.id) {
        case 14:
        case 57:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RiskStatementAutoPage(policy)));
          break;
        case 56:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RiskStatementAutoPage(policy)));
          break;
        case 15:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RelativesFormPage(policy)));
          break;
        case 3:
        case 5:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BeneficiariesFormPage(policy)));
          break;
        default:
      }

      // Resto del código...
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Crear una instancia de FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    apiServiceColor();
    yearCodeFocus.addListener(() {
      if (!yearCodeFocus.hasFocus) {
        // El TextField perdió el foco
        apiServiceBrand(int.parse(year.text));
      }
    });

    // Set the default country to Venezuela
    if (Paises.isNotEmpty) {
      country = Paises[0];
    }
    // TextField: Tomador -> identityCard
    // TextField: Titular -> idCard

    identityCard.addListener(() {
      // If they're NOT different and we're not currently updating from Owner, copy Taker -> Owner
      if (!_areDifferent && !_isUpdatingFromOwner) {
        _isUpdatingFromTaker = true;
        idCard.text = identityCard.text;
        _isUpdatingFromTaker = false;
      }
    });

    idCard.addListener(() {
      // If they're NOT different and we're not currently updating from Taker, copy Owner -> Taker
      if (!_areDifferent && !_isUpdatingFromTaker) {
        _isUpdatingFromOwner = true;
        identityCard.text = idCard.text;
        _isUpdatingFromOwner = false;
      }
    });

    // TextField: Tomador -> name
    // TextField: Titular -> nameOwner

    name.addListener(() {
      if (!_areDifferent && !_isUpdatingFromOwner) {
        _isUpdatingFromTaker = true;
        nameOwner.text = name.text;
        _isUpdatingFromTaker = false;
      }
    });

    nameOwner.addListener(() {
      if (!_areDifferent && !_isUpdatingFromTaker) {
        _isUpdatingFromOwner = true;
        name.text = nameOwner.text;
        _isUpdatingFromOwner = false;
      }
    });

    // TextField: Tomador -> lastName
    // TextField: Titular -> lastNameOwner

    lastName.addListener(() {
      if (!_areDifferent && !_isUpdatingFromOwner) {
        _isUpdatingFromTaker = true;
        lastNameOwner.text = lastName.text;
        _isUpdatingFromTaker = false;
      }
    });

    lastNameOwner.addListener(() {
      if (!_areDifferent && !_isUpdatingFromTaker) {
        _isUpdatingFromOwner = true;
        lastName.text = lastNameOwner.text;
        _isUpdatingFromOwner = false;
      }
    });

    // TextField: Tomador -> dateBirth
    // TextField: Titular -> dateBirthOwner

    dateBirth.addListener(() {
      if (!_areDifferent && !_isUpdatingFromOwner) {
        _isUpdatingFromTaker = true;
        dateBirthOwner.text = dateBirth.text;
        try {
          DateFormat format = DateFormat('dd/MM/yyyy');
          DateTime dt = format.parse(dateBirth.text);
          ageOwner.text = calculateAge(dt).toString();
        } catch (e) {
          print('Error parsing dateBirth: $e');
        }
        _isUpdatingFromTaker = false;
      }
    });

    dateBirthOwner.addListener(() {
      if (!_areDifferent && !_isUpdatingFromTaker) {
        _isUpdatingFromOwner = true;
        dateBirth.text = dateBirthOwner.text;
        try {
          DateFormat format = DateFormat('dd/MM/yyyy');
          DateTime dt = format.parse(dateBirthOwner.text);
          age.text = calculateAge(dt).toString();
        } catch (e) {
          print('Error parsing dateBirthOwner: $e');
        }
        _isUpdatingFromOwner = false;
      }
    });
  }

  @override
  void dispose() {
    brandCodeFocus.dispose();
    year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSales(widget.product.product),
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

    Future<void> _selectDate(BuildContext context, int type) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2101),
      );

      if (picked != null) {
        setState(() {
          selectedDate = picked;
          final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
          final calculatedAge = "${calculateAge(selectedDate!)}";

          if (type == 1) {
            dateBirth.text = formattedDate;
            age.text = calculatedAge;
            // Sincronizar con Titular si no son diferentes
            if (!_areDifferent) {
              dateBirthOwner.text = formattedDate;
              ageOwner.text = calculatedAge;
            }
          } else {
            dateBirthOwner.text = formattedDate;
            ageOwner.text = calculatedAge;
          }
        });
      }
    }

    // Expresión regular para validar el correo electrónico
    bool _isValidEmail(String email) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailRegex.hasMatch(email);
    }

    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(children: [
          const SizedBox(height: 25),
          Center(
            child: GestureDetector(
                onTap: () {
                  _openCameraOverlay((XFile image) {
                    setState(() {
                      _imageFile = File(image.path);
                      _recognizeText(_imageFile!);
                    });
                  });
                },
                child: Container(
                    width: 300,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 247, 255, 1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(
                              98, 162, 232, 0.5), // Color de la sombra
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
                          'Cargar Cédula',
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
                    ))),
          ),
          const SizedBox(height: 20),
          if (_imageFile != null)
            Center(
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
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(
                              98, 162, 232, 0.5), // Color de la sombra
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
          //Detalles del Tomador
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
                      // Color de fondo gris
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
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
                      topLeft: Radius.zero,
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.zero,
                    ),
                    onChanged: (TypeDoc? newValue) {
                      setState(() {
                        typeDoc = newValue;
                        if (!_areDifferent) {
                          // Sincroniza typeDoc con typeDocOwner si no son diferentes
                          typeDocOwner = newValue;
                        }
                      });
                    },
                    items: TypeDocs.map((TypeDoc tipoDoc) {
                      return DropdownMenuItem<TypeDoc>(
                        value: tipoDoc,
                        child: Text(tipoDoc.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'CI',
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
                      suffixIcon: Padding(
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
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: name,
                    focusNode: nameCodeFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: lastName,
                    focusNode: lastNameCodeFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Apellido',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
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
                      // Color de fondo gris
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
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
                            contentPadding: const EdgeInsets.only(
                                top: 0, bottom: 8, right: 0, left: 20),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/calendar.png",
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () => _selectDate(context, 1),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
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
          // *********** NEW CHECKBOX ROW ***********
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the row
            children: [
              Checkbox(
                value: _areDifferent,
                onChanged: (bool? newValue) {
                  setState(() {
                    _areDifferent = newValue ?? false;
                    if (!_areDifferent) {
                      // Sincronizar todos los campos cuando tomador y asegurado son la misma persona
                      _isUpdatingFromTaker = true;
                      idCard.text = identityCard.text;
                      nameOwner.text = name.text;
                      lastNameOwner.text = lastName.text;
                      dateBirthOwner.text = dateBirth.text;
                      ageOwner.text = age.text;
                      // Sincronizar también typeDoc
                      typeDocOwner = typeDoc;
                      _isUpdatingFromTaker = false;
                    } else {
                      // Permitir entrada independiente para el titular
                      _isUpdatingFromOwner = true;
                      idCard.text = '';
                      nameOwner.text = '';
                      lastNameOwner.text = '';
                      dateBirthOwner.text = '';
                      ageOwner.text = '';
                      typeDocOwner = null;
                      _isUpdatingFromOwner = false;
                    }
                  });
                },
              ),
              Text(
                "¿El tomador y asegurado son personas diferentes?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF49454F),
                ),
              ),
            ],
          ),
          // *****************************************
          // After the Titular fields (e.g., after the ageOwner TextField)

          const SizedBox(height: 20),
          if (_areDifferent)
            Center(
              child: GestureDetector(
                onTap: () {
                  _openCameraOverlay((XFile image) {
                    setState(() {
                      _imageFileOwner = File(image.path);
                      _recognizeTextOwner(_imageFileOwner!);
                    });
                  });
                },
                child: Container(
                  width: 300,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 247, 255, 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(98, 162, 232, 0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cargar Cédula Titular',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'assets/upload.png', // Replace with your image path
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (_areDifferent && _imageFileOwner != null)
            Center(
              child: GestureDetector(
                onTap: () {
                  _pickImageOwner(ImageSource.gallery);
                },
                child: Container(
                  width: 150,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 247, 255, 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(98, 162, 232, 0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.file(_imageFileOwner!),
                ),
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
                      // Color de fondo gris
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
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
                      topLeft: Radius.zero,
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.zero,
                    ),
                    onChanged: (TypeDoc? newValue) {
                      setState(() {
                        typeDocOwner = newValue;
                        if (!_areDifferent) {
                          // When not different, sync the Taker's TypeDoc as well
                          typeDoc = newValue;
                        }
                      });
                    },
                    items: TypeDocs.map((TypeDoc tipoDoc) {
                      return DropdownMenuItem<TypeDoc>(
                        value: tipoDoc,
                        child: Text(tipoDoc.name),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'CI',
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
                      suffixIcon: Padding(
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
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Solo permite números
                    ],
                    controller: idCard,
                    focusNode: idCardCodeFocus,
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: nameOwner,
                    focusNode: nameOwnerCodeFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Nombre',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(
                      color: Color.fromRGBO(79, 127, 198, 1),
                    ), // Borde rojo
                  ),
                  child: TextField(
                    maxLength:
                        50, // Limita la longitud del texto a 50 caracteres
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          '[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')), // Solo letras y espacios
                    ],
                    controller: lastNameOwner,
                    focusNode: lastNameOwnerCodeFocus,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontFamily: 'Poppins',
                      // Otros estilos de texto que desees aplicar
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Apellido',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
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
                // Color de fondo gris
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
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
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
            padding: const EdgeInsets.only(left: 50, right: 0),
            child: Row(
              children: [
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      // Color de fondo gris
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
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
                            contentPadding: const EdgeInsets.only(
                                top: 0, bottom: 8, right: 0, left: 20),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 116, 126, 1),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/calendar.png",
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () => _selectDate(context, 2),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
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
                if (widget.product.id == funeral ||
                    widget.product.id == fourInOne ||
                    widget.product.id == life)
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                        // Color de fondo gris
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
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
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
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
                          child: Text("${s == true ? "SI" : "NO"}"),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: '¿Fuma?',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 35),
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
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      // Color de fondo gris
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
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
                      topLeft: Radius.zero,
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
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
                      contentPadding: EdgeInsets.only(top: 6, left: 16),
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
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
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
                hintStyle: TextStyle(
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.zero,
              ),
              border: Border.all(
                color: Color.fromRGBO(79, 127, 198, 1),
              ), // Borde rojo
            ),
            child: TextField(
              maxLength: 11,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo permite números
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
                hintStyle: TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: GestureDetector(
                onTap: () {
                  _openCameraOverlay((XFile image) {
                    setState(() {
                      _imageFileRif = File(image.path);
                      // Optionally process the image for Rif if needed
                    });
                  });
                },
                child: Container(
                    width: 300,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 247, 255, 1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(
                              98, 162, 232, 0.5), // Color de la sombra
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
                          'Cargar Rif',
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
                      ],
                    ))),
          ),
          const SizedBox(height: 20),
          if (_imageFileRif != null)
            Center(
              child: GestureDetector(
                  onTap: () {
                    _pickImageRif(ImageSource.gallery);
                  },
                  child: Container(
                    width: 150,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 247, 255, 1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(
                              98, 162, 232, 0.5), // Color de la sombra
                          spreadRadius: 1, // Extensión de la sombra
                          blurRadius: 4, // Difuminado de la sombra
                          offset: Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    child: Image.file(_imageFileRif!),
                  )),
            ),
          const SizedBox(height: 20),
          if (widget.product.id == funeral ||
              widget.product.id == fourInOne ||
              widget.product.id == life)
            const SizedBox(height: 30),
          if (widget.product.id == funeral ||
              widget.product.id == fourInOne ||
              widget.product.id == life)
            Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
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
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == family) const SizedBox(height: 30),
          if (widget.product.id == family)
            Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
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
                value: selectedRelatives,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedRelatives = newValue;
                  });
                },
                items: relatives.map((int b) {
                  return DropdownMenuItem<int>(
                    value: b,
                    child: Text(b.toString()),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Familiares',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 25),
          if (widget.product.id == auto || widget.product.id == moto)
            Container(
              child: Text(
                "Datos del Vehículo",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          if (widget.product.id == auto || widget.product.id == moto)
            Center(
              child: GestureDetector(
                  onTap: () {
                    _openCameraOverlay((XFile image) {
                      setState(() {
                        _imageFileAuto = File(image.path);
                        _recognizeTextAuto(_imageFileAuto!);
                      });
                    });
                  },
                  child: Container(
                      width: 300,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 247, 255, 1),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(
                                98, 162, 232, 0.5), // Color de la sombra
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
                            'Certificado de Circulación',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(15, 26, 90, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                          SizedBox(width: 8),
                          Image.asset(
                            'assets/upload.png', // Replace with your image path
                            width: 35, // Set image width (optional)
                            height: 35, // Set image height (optional)
                            fit:
                                BoxFit.cover, // Adjust image fitting (optional)
                          ),
                        ],
                      ))),
            ),
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            if (_imageFileAuto != null)
              Center(
                child: GestureDetector(
                    onTap: () {
                      _pickImageAuto(ImageSource.gallery);
                    },
                    child: Container(
                      width: 150,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 247, 255, 1),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(
                                98, 162, 232, 0.5), // Color de la sombra
                            spreadRadius: 1, // Extensión de la sombra
                            blurRadius: 4, // Difuminado de la sombra
                            offset: Offset(0, 3), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      child: Image.file(_imageFileAuto!),
                    )),
              ),
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      maxLength: 4,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Solo permite números
                      ],
                      controller: year,
                      focusNode: yearCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Año',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
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
                        // Color de fondo gris
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.zero,
                        ),
                        border: Border.all(
                          color: Color.fromRGBO(79, 127, 198, 1),
                        )),
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                      iconSize: 0,
                      value: selectedColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedColor = newValue;
                        });
                      },
                      items: colors.map((color) {
                        return DropdownMenuItem(
                          value: color,
                          child: Text(color['name'] ?? 'Color no disponible',
                              style: TextStyle(fontSize: 10)), // Arreglo aquí
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Color',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(121, 116, 126, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 30),
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(79, 127, 198, 1),
                  )),
              child: DropdownButtonFormField<Brand>(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                iconSize: 0,
                value: selectedBrand,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (Brand? newValue) {
                  setState(() {
                    selectedBrand = newValue;
                    // Reset dependent fields when brand changes
                    selectedModel = null;
                    selectedVersion = null;
                    typeVehicle.text = '';
                    models = []; // Optionally clear models list
                    versions = []; // Optionally clear versions list

                    // Fetch models for the selected brand
                    apiServiceModels(int.parse(year.text), selectedBrand!.id);
                  });
                },
                items: Brands.map((Brand brand) {
                  return DropdownMenuItem<Brand>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Marcas',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(79, 127, 198, 1),
                  )),
              child: DropdownButtonFormField<Map<String, dynamic>>(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                iconSize: 0,
                value: selectedModel,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedModel = newValue;
                    selectedVersion = null; // Clear previous version selection
                    typeVehicle.text = ''; // Reset the typeVehicle field
                    apiServiceVersion(int.parse(year.text), selectedBrand.id,
                        selectedModel["id"]);
                  });
                },
                items: models.map((model) {
                  return DropdownMenuItem(
                    value: model,
                    child: Text(model['name'] ??
                        'Nombre no disponible'), // Arreglo aquí
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Modelo',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.zero,
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(79, 127, 198, 1),
                  )),
              child: DropdownButtonFormField<Map<String, dynamic>>(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                iconSize: 0,
                value: selectedVersion,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedVersion = newValue;
                    if (selectedVersion['type'] != null) {
                      typeVehicle.text = selectedVersion['type'];
                    } else {
                      typeVehicle.text = "Vehículo no está configurado.";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Vehículo no está configurado. Contactar con el administrador')),
                      );
                    }
                  });
                },
                items: versions.map((version) {
                  return DropdownMenuItem(
                    value: version,
                    child: Text(version['name'] ?? 'Vehiculo no disponible',
                        style: TextStyle(fontSize: 10)), // Arreglo aquí
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Versión',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(121, 116, 126, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      maxLength:
                          10, // Limita la longitud del texto (ajusta según tus necesidades)
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]')), // Solo letras y números
                      ],
                      controller: placa,
                      focusNode: placaCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Placa',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      border: Border.all(
                        color: Color.fromRGBO(79, 127, 198, 1),
                      ), // Borde rojo
                    ),
                    child: TextField(
                      maxLength:
                          30, // Limita la longitud del texto (ajusta según tus necesidades)
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]')), // Solo letras y números
                      ],
                      controller: serial,
                      focusNode: serialCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Serial',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
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
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (widget.product.id == auto || widget.product.id == moto)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.zero,
                ),
                border: Border.all(
                  color: Color.fromRGBO(79, 127, 198, 1),
                ), // Borde rojo
              ),
              child: TextField(
                controller: typeVehicle,
                focusNode: typeVehicleCodeFocus,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontFamily: 'Poppins',
                  // Otros estilos de texto que desees aplicar
                ),
                decoration: InputDecoration(
                  hintText: 'Tipo de Vehículo',
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
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (widget.product.id == auto || widget.product.id == moto)
            const SizedBox(height: 20),
          if (GlobalVariables().user.rol == 3)
            Container(
              child: Text(
                "Productor",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          if (GlobalVariables().user.rol == 3) const SizedBox(height: 20),
          if (GlobalVariables().user.rol == 3)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  // Color de fondo gris
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
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
                  topLeft: Radius.zero,
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          if (widget.product.id == funeral || widget.product.id == fourInOne)
            const SizedBox(height: 30),
          if (widget.product.id == funeral || widget.product.id == fourInOne)
            Container(
              child: Text(
                "Tipo de Póliza",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromRGBO(15, 26, 90, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          if (widget.product.id == funeral || widget.product.id == fourInOne)
            const SizedBox(height: 20),
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
                    // Realiza la validación cuando el usuario presione el botón
                    if (!_isValidEmail(email.text)) {
                      // Correo inválido
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correo inválido')),
                      );
                    } else {
                      Save();
                    }
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
              children: const [
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
              children: const [
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
              children: const [
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
