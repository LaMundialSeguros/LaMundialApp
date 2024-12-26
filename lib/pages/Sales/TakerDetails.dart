// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Amount.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/Brand.dart';
import 'package:lamundialapp/Utilidades/Class/Contry.dart';
import 'package:lamundialapp/Utilidades/Class/DetailsOwner.dart';
import 'package:lamundialapp/Utilidades/Class/PaymentFrequency.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Producer.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/Utilidades/Class/Relative.dart';
import 'package:lamundialapp/Utilidades/Class/Taker.dart';
import 'package:lamundialapp/Utilidades/Class/TypeVehicle.dart';
import 'package:lamundialapp/pages/Sales/BeneficiariesForm.dart';
import 'package:lamundialapp/pages/Sales/RelativesForm.dart';
import 'package:lamundialapp/pages/Sales/RiskStatement.dart';
import 'package:lamundialapp/pages/Sales/RiskStatementAuto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utilidades/Class/Gender.dart';
import '../../Utilidades/Class/TypeDoc.dart';
import '../../Utilidades/Class/Vehicle.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;

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

  int auto = 24;
  int moto = 22;
  int fourInOne = 5;
  int funeral = -1;
  int family = 7;
  int life = 3;

  File? _imageFile;
  File? _imageFileAuto;
  File? _imageFileRif;
  //final ImagePicker _picker = ImagePicker();
  String _recognizedText = "Texto reconocido aparecerá aquí.";

  String extractSpecificId(String text) {
    // RegEx para capturar cédulas con 5 a 9 dígitos (por ejemplo: "V 27.606.5" o "E 12.345.678")
    final regex = RegExp(r'\b[VvEe]\s\d{1,2}(\.\d{3}){1,2}\b');
    final match = regex.firstMatch(text);
    if(match != null){
      return match.group(0)!;
    }
    return match != null ? match.group(0)! : 'No detectado';
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
    return match != null ? match.group(0)!.toUpperCase() : 'Prefijo no encontrado';
  }

  String extractName(String text) {
    // RegEx que busca "APELLIDOS" seguido de dos apellidos en mayúsculas
    final regex = RegExp(r'NOMBRES\s+([A-ZÁÉÍÓÚÑ]+(?:\s[A-ZÁÉÍÓÚÑ]+)*)');
    final match = regex.firstMatch(text);

    if (match != null) {
      // Devuelve los apellidos encontrados después de "APELLIDOS"
      return match.group(1)!;
    } else {
      return 'No detectado';
    }
  }

  String extractLastName(String text) {
    // RegEx que busca "APELLIDOS" seguido de dos apellidos en mayúsculas
    final regex = RegExp(r'APELLIDOS\s+([A-ZÁÉÍÓÚÑ]+(?:\s[A-ZÁÉÍÓÚÑ]+)*)');
    final match = regex.firstMatch(text);

    if (match != null) {
      // Devuelve los apellidos encontrados después de "APELLIDOS"
      return match.group(1)!;
    } else {
      return 'No detectado';
    }
  }

  String extractDateOfBirth(String text) {
    // RegEx para buscar una fecha en formato DD/MM/YYYY o DD-MM-YYYY
    final regex = RegExp(r'\b(\d{1,2})[-/](\d{1,2})[-/](\d{4})\b');
    final match = regex.firstMatch(text);

    if (match != null) {
      // Devuelve la fecha de nacimiento encontrada
      String date = '${match.group(1)}/${match.group(2)}/${match.group(3)}';
      DateFormat format = DateFormat('dd/MM/yyyy');
      DateTime dateTime = format.parse(date);
      setState(() {
        dateBirth = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(dateTime!)}");
        age = TextEditingController(text: "${dateTime != null ? calculateAge(dateTime!) : 'N/A'}");
        dateBirthOwner = TextEditingController(text: "${DateFormat('dd/MM/yyyy').format(dateTime!)}");
        ageOwner = TextEditingController(text: "${dateTime != null ? calculateAge(dateTime!) : 'N/A'}");
      });
      return date;
    } else {
      return 'No detectado';
    }
  }


  String? extractSerial(String input) {

    final regex = RegExp(r'Serial\s+N(?:[\.\s]*[A-Za-z]+)*[\.\s]*:?([A-Za-z0-9]+)');
    final match = regex.firstMatch(input);

    // Si se encuentra el prefijo y el serial, lo devuelve sin el prefijo
    if (match != null) {
      return match.group(1); // Retorna el serial limpio
    }else{
      return 'No detectado';
    }

  }

  String? extractPlaca(String input) {
    // Patrón para detectar "Placa:" seguido de letras y números
    final regex = RegExp(r'Placa:\s*([A-Za-z0-9]+)');
    final match = regex.firstMatch(input);

    // Si se encuentra el prefijo y el valor, devuelve el texto limpio
    if (match != null) {
      return match.group(1); // Retorna el valor de la placa
    }else{
      return 'No detectado';
    }
  }

  String? extractYear(String input) {
    // Patrón para detectar un número de 4 dígitos (año)
    final regex = RegExp(r'\b(\d{4})\b');
    final match = regex.firstMatch(input);

    // Si se encuentra un año, devolver la parte capturada
    if (match != null) {
      return match.group(1); // Retorna el año
    }else{
      return 'No detectado';
    }

  }

  Future<void> _recognizeTextAuto(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      List<String> datos = recognizedText.text.split('\n');
      String  xserial = 'No detectado';
      String  xplaca  = 'No detectado';
      String  xyear  = 'No detectado';
      for (String dato in datos){

        // Captura cedula
        if(xserial == 'No detectado'){
          xserial  = extractSerial(dato)!;
          serial.text = xserial;
        }

        // Captura cedula
        if(xplaca == 'No detectado'){
          xplaca  = extractPlaca(dato)!;
          placa.text = xplaca;
        }

        // Captura cedula
        if(xyear == 'No detectado'){
          xyear  = extractYear(dato)!;
          year.text = xyear;
          if(xyear != 'No detectado'){
            apiServiceBrand(year.text as int);
          }
        }
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
        String  id            = 'No detectado';
        String  lastNames     = 'No detectado';
        String  names         = 'No detectado';
        String  dateBirthDay  = 'No detectado';
      for (String dato in datos){

        // Captura cedula
        if(id == 'No detectado'){
          id  = extractSpecificId(dato);
          identityCard.text = cleanID(id);
          idCard.text = cleanID(id);
          for(TypeDoc t in TypeDocs){
            String prefix = extractOnlyPrefix(id);
            if(t.name == prefix){
              setState(() {
                typeDoc = t;
                typeDocOwner = t;
              });
            }
          }
        }
        // Captura nombres
        if(names ==  'No detectado'){
          names   =  extractName(dato);
          name.text = names;
          nameOwner.text = names;
        }
        // Captura apellidos
        if(lastNames ==  'No detectado'){
          lastNames   =  extractLastName(dato);
          lastName.text = lastNames;
          lastNameOwner.text = lastNames;
        }

        // Fecha de nacimiento
        if(dateBirthDay ==  'No detectado'){
          dateBirthDay    = extractDateOfBirth(dato);
          dateBirth.text  = dateBirthDay;
          dateBirthOwner.text = dateBirthDay;
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
    Producer(1,'test 1','','','','',''),
    Producer(2,'test 2','','','','','')
  ];

  List<Map<String, dynamic>> models = [];
  List<Map<String, dynamic>> versions = [];
  List<Map<String, dynamic>> colors = [];

  List<bool> smoke = [false,true];

  List<int> beneficiaries = [0,1,2,3,4,5];
  List<int> relatives = [1,2,3,4,5,6,7,8,9];

  List<Country> Paises = [
    Country("Venezuela", 1)
  ];

  // Poliza a gestionar

  List<Brand> Brands = [];


  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int monthDifference = currentDate.month - birthDate.month;

    if (monthDifference < 0 || (monthDifference == 0 && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> apiServiceBrand(int year) async {
    selectedBrand = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "qano": year,
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/brand'),
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
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceModels(int year,int brandId) async {
    selectedModel = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "qano": year,
      "cmarca": brandId
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/model'),
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
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> apiServiceVersion(int year,int brandId,int modelId) async {
    selectedVersion = null;
    // Cuerpo de la petición en formato JSON
    final body = jsonEncode({
      "qano": year,
      "cmarca": brandId,
      "cmodelo": modelId
    });

    try {
      final response = await http.post(
        Uri.parse('https://devapisys2000.lamundialdeseguros.com/api/v1/valrep/version'),
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
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
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
        Uri.parse('https://qaapisys2000.lamundialdeseguros.com//api/v1/valrep/color'),
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
        SnackBar(content: Text('Error de conecxion al cargar los datos. Código: ${response.statusCode}'));
        throw Exception('Error de conecxion al cargar los datos. Código: ${response.statusCode}');
      }

    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {

      // Validar campos nulos
      if (identityCard == null ||
          identityCard== null ||
          name == null ||
          lastName == null ||
          dateBirth == null ||
          idCard == null ||
          typeDocOwner == null ||
          nameOwner == null ||
          lastNameOwner == null ||
          dateBirth == null ||
          phone == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      if(placa == null || serial == null || brand == null || color == null || model == null || year ==null){
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }


      if (smoker == null) {
        smoker = false;
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
          smoker ?? false,
          country,
          phone.text,
          email.text,
          selectedbeneficiary ?? 0
      );
      var vehicle = null;
      if(widget.product.id == auto || widget.product.id == moto){
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
            typeVehicle.text
        );
      }

      if(selectedRelatives == null){
        selectedRelatives = 0;
      }

      List <Beneficiary> beneficiaries = [];
      List <Relative> relatives = [];
      List <Amount> amounts = [];

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
                              _imageFile,
                              _imageFileRif,
                              _imageFileAuto
                            );

      switch (widget.product.id) {
        case 14:
        case 22:
        case 24:
            Navigator.push(context,MaterialPageRoute(builder: (context) => RiskStatementAutoPage(policy)));
          break;
        case 15:
            Navigator.push(context,MaterialPageRoute(builder: (context) => RelativesFormPage(policy)));
          break;
        case 3:
        case 5:
          Navigator.push(context,MaterialPageRoute(builder: (context) => BeneficiariesFormPage(policy)));
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

    Future<void> _selectDate(BuildContext context,int type) async {
      final DateTime? picked = await
      showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930),
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

    // Expresión regular para validar el correo electrónico
    bool _isValidEmail(String email) {
      final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
                _pickImage(ImageSource.camera);
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
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
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,  // Solo permite números
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters:	[
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
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
                            maxLength: 50,  // Limita la longitud del texto a 50 caracteres
                            inputFormatters:	[
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
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
                        if(widget.product.id == funeral || widget.product.id == fourInOne || widget.product.id == life)Container(
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
                      maxLength: 11,
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
          const SizedBox(height: 25),
          Center(
                    child: GestureDetector(
                        onTap: () {
                          _pickImageRif(ImageSource.camera);
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
                            )
                        )),
                  ),
          const SizedBox(height: 20),
          if(_imageFileRif != null) Center(
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
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(98, 162, 232, 0.5), // Color de la sombra
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
          if(widget.product.id == funeral || widget.product.id == fourInOne || widget.product.id == life)const SizedBox(height: 30),
          if(widget.product.id == funeral || widget.product.id == fourInOne || widget.product.id == life)Container(
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
          if(widget.product.id == family)const SizedBox(height: 30),
          if(widget.product.id == family)Container(
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
                      value: selectedRelatives,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 25),
          if(widget.product.id == auto || widget.product.id == moto)Container(
                    child: Text(
                      "Datos del Vehículo",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          if(widget.product.id == auto || widget.product.id == moto)Center(
                    child: GestureDetector(
                        onTap: () {
                          _pickImageAuto(ImageSource.camera);
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
                                  'Certificado de circulacion',
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)if(_imageFileAuto != null) Center(
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
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(98, 162, 232, 0.5), // Color de la sombra
                                spreadRadius: 1, // Extensión de la sombra
                                blurRadius: 4, // Difuminado de la sombra
                                offset: Offset(0, 3), // Desplazamiento de la sombra
                              ),
                            ],
                          ),
                          child: Image.file(_imageFileAuto!),
                        )),
                  ),
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Padding(
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
                            maxLength: 4,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,  // Solo permite números
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
                              hintStyle:
                              TextStyle(
                                  color: Color.fromRGBO(121, 116, 126, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            /*onEditingComplete: () {
                              apiServiceBrand(int.parse(year.text));
                            },*/
                          ),
                        ),
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
                          child: DropdownButtonFormField<Map<String, dynamic>>(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            iconSize: 0,
                            value: selectedColor,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.zero,
                              topRight:  Radius.circular(30.0),
                              bottomLeft:  Radius.circular(30.0),
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
                                child: Text(color['name'] ?? 'Color no disponible',style:TextStyle(fontSize: 10)), // Arreglo aquí
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Container(
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
                    child: DropdownButtonFormField<Brand>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedBrand,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (Brand? newValue) {
                        setState(() {
                          selectedBrand = newValue;
                          apiServiceModels(int.parse(year.text),selectedBrand.id);
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Container(
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
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedModel,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedModel = newValue;
                          apiServiceVersion(int.parse(year.text),selectedBrand.id,selectedModel["id"]);
                        });
                      },
                      items: models.map((model) {
                        return DropdownMenuItem(
                          value: model,
                          child: Text(model['name'] ?? 'Nombre no disponible'), // Arreglo aquí
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Modelo',
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Container(
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
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,

                      ),
                      iconSize: 0,
                      value: selectedVersion,
                      borderRadius: BorderRadius.only(
                        topLeft:  Radius.zero,
                        topRight:  Radius.circular(40.0),
                        bottomLeft:  Radius.circular(40.0),
                        bottomRight: Radius.zero,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedVersion = newValue;
                          if(selectedVersion['type'] != null){
                            typeVehicle.text = selectedVersion['type'];
                          }else{
                            typeVehicle.text = "Vehículo no está configurado.";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Vehículo no está configurado. Contactar con el administardor')),
                            );
                          }
                        });
                      },
                      items: versions.map((version) {
                        return DropdownMenuItem(
                          value: version,
                          child: Text(version['name'] ?? 'Vehiculo no disponible',style: TextStyle(fontSize: 10)), // Arreglo aquí
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        hintText: 'Version',
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Padding(
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
                            maxLength: 10,  // Limita la longitud del texto (ajusta según tus necesidades)
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),  // Solo letras y números
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
                            maxLength: 30,  // Limita la longitud del texto (ajusta según tus necesidades)
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),  // Solo letras y números
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
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
          if(widget.product.id == auto || widget.product.id == moto)Container(
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
                controller: typeVehicle,
                focusNode: typeVehicleCodeFocus,
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
                  hintStyle:
                  TextStyle(
                      color: Color.fromRGBO(121, 116, 126, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
          if(widget.product.id == auto || widget.product.id == moto)const SizedBox(height: 20),
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
          if(widget.product.id == funeral || widget.product.id == fourInOne)const SizedBox(height: 30),
          if(widget.product.id == funeral || widget.product.id == fourInOne)Container(
                    child: Text(
                      "Tipo de Póliza",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(15, 26, 90, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
          if(widget.product.id == funeral || widget.product.id == fourInOne)const SizedBox(height: 20),
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
                    }else{
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
