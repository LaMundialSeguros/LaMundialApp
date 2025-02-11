// ignore_for_file: avoid_print, unused_field, prefer_final_fields, avoid_init_to_null, non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lamundialapp/Utilidades/curveAppBar.dart';
import 'package:lamundialapp/pages/ForgotPassword.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utilidades/Class/Gender.dart';
import '../../Utilidades/Class/TypeDoc.dart';
import '../../components/logo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

final localAuth = LocalAuthentication();

class RegisterClientPage extends StatefulWidget {
  const RegisterClientPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  RegisterClientPageState createState() => RegisterClientPageState();
}

class RegisterClientPageState extends State<RegisterClientPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final rol = TextEditingController();
  final cedula = TextEditingController();
  final rif = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();
  final ocupacion = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  FocusNode rolCodeFocus = FocusNode();
  FocusNode cedulaCodeFocus = FocusNode();
  FocusNode rifCodeFocus = FocusNode();
  FocusNode telefonoCodeFocus = FocusNode();
  FocusNode correoCodeFocus = FocusNode();
  FocusNode ocupacionCodeFocus = FocusNode();


  File? _imageFile;
  //final ImagePicker _picker = ImagePicker();
  String _recognizedText = "Texto reconocido aparecerá aquí.";

  String extractSpecificText(String text) {
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

  Future<void> _recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      List<String> datos = recognizedText.text.split('\n');
      for (String dato in datos) {
        String texto = extractSpecificText(dato);
        if(texto != 'No detectado'){

          cedula.text = cleanID(texto);
          for(TypeDoc t in TypeDocs){
            String prefix = extractOnlyPrefix(texto);
            if(t.name == prefix){
              setState(() {
                typeDoc = t;
              });
              break;
            }
          }
          break;
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

  var typeDoc = null;
  var selectedGender = null;

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];

  List<Gender> Genders = [
    Gender('Femenino',1),
    Gender('Masculino', 2)
  ];

  Future<void> RegisterClient() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar campos nulos
      if (selectedGender == null || selectedGender == null) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      if (cedula.text.isEmpty || rif.text.isEmpty || ocupacion.text.isEmpty || telefono.text.isEmpty || correo.text.isEmpty) {
        // Muestra la alerta de usuarioNoexiste desde el archivo alertas.dart
        await alertas.usuarioNoexiste(context);
        return;
      }

      Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
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
      appBar: PreferredSize(
        child: ClipPath(clipper: CurveAppBar(),
        child: AppBar(
          //toolbarHeight: 50,
          backgroundColor: Color.fromRGBO(15, 26, 90, 1),
          title: LogoWidget(),
          leading: IconButton(
            icon: Image.asset(
              'assets/return.png', // Reemplaza con la ruta de tu imagen
              height: 40,
            ), // Reemplaza con tu icono deseado
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        ),
        preferredSize: Size.fromHeight(150),
      ),/*AppBar(

      )*/
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
          Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '   REGISTRO \n DE USUARIO',
                          style: TextStyle(
                              fontSize: 34,
                              color: Color.fromRGBO(15, 26, 90, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
          const SizedBox(height: 50),
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
                              boxShadow: const [
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
                                  'Foto C.I.',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color.fromRGBO(15, 26, 90, 1),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  'assets/photo.png', // Replace with your image path
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
                            boxShadow: const [
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
                            controller: cedula,
                            focusNode: cedulaCodeFocus,
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
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                      ],
                      controller: rif,
                      focusNode: rifCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Ingrese su RIF',
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
                      maxLength: 11,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // Solo permite números
                      ],
                      controller: telefono,
                      focusNode: telefonoCodeFocus,
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
                      controller: correo,
                      focusNode: correoCodeFocus,
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
                      maxLength: 20,  // Limita la longitud del texto a 50 caracteres
                      inputFormatters:	[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-ZáéíóúÁÉÍÓÚÑñ ]')),  // Solo letras y espacios
                      ],
                      controller: ocupacion,
                      focusNode: ocupacionCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Ingrese su Ocupación',
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
          const SizedBox(height: 30),
          Container(
            width: 380,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Realiza la validación cuando el usuario presione el botón
                    if (!_isValidEmail(correo.text)) {
                      // Correo inválido
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correo inválido')),
                      );
                    }else{
                      RegisterClient();
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
                    'Registrarse',
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
