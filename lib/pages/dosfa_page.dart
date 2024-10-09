import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lamundialapp/Alertas/alertaspos.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

AlertaState alertas = AlertaState();
var dosfaFormatter = MaskTextInputFormatter(
  mask: '#  #  #  #  #  #',
  filter: {"#": RegExp(r'[0-9]')},
);

class TwoFactorAuthPage extends StatefulWidget {
  const TwoFactorAuthPage({Key? key}) : super(key: key);

  @override
  TwoFactorAuthPageState createState() => TwoFactorAuthPageState();
}

class TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  static final TextEditingController twoFactorCodeController =
      TextEditingController();
  bool isLoading = false;
  FocusNode twoFactorCodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Asignar el controlador al campo una vez en initState
    twoFactorCodeController.text =
        ''; // Puedes inicializar el texto aquí si es necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
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
              //child: buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    //FocusNode twoFactorCodeFocus = FocusNode();
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
        color: Colors.white,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              SizedBox(height: screenSize.height / 4),
              const Text(
                'Factor de doble autenticación (2FA)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Capriola',
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 0.8 * screenSize.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: twoFactorCodeController,
                        focusNode: twoFactorCodeFocus,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Color del texto
                          fontFamily: 'Capriola',
                          // Otros estilos de texto que desees aplicar
                        ),
                        inputFormatters: [dosfaFormatter],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Código Autenticador de Google',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          hintStyle: TextStyle(
                              color: Colors.grey[500], fontFamily: 'Capriola'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      twoFactorCodeFocus.unfocus();
                      setState(() {
                        isLoading = true;
                      });

                      if (twoFactorCodeController.text.isEmpty) {
                        alertas.usuarioNoexiste(context);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        apiConsultaDosfa(
                                context,
                                twoFactorCodeController.text
                                    .replaceAll(' ', ''))
                            .then((_) {})
                            .catchError((error) {})
                            .whenComplete(() {
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromRGBO(3, 134, 208, 1),
                      minimumSize: const Size(200, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Capriola'),
                    ),
                  ),
                  // if (isLoading)
                  //   const CircularProgressIndicator(
                  //     valueColor: AlwaysStoppedAnimation<Color>(
                  //         Color.fromARGB(179, 255, 255, 255)),
                  //   ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  //SystemNavigator.pop();
                  twoFactorCodeController.text = '';
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) =>
                        false, // Elimina todas las rutas existentes en la pila
                  );
                },
                child: const Text(
                  'Salir',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: 'Capriola',
                  ),
                ),
              ),
            ]))));
  }
}
