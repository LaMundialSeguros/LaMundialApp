// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/pages/Sales/RiskStatement.dart';
import 'package:lamundialapp/pages/Sales/VerifyPayment.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


final localAuth = LocalAuthentication();

class TermsAndConditionsPage extends StatefulWidget {
  final Policy policy;
  const TermsAndConditionsPage(this.policy,{Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  TermsAndConditionsPageState createState() => TermsAndConditionsPageState();
}

class TermsAndConditionsPageState extends State<TermsAndConditionsPage> {

  bool isLoading = false;

  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {


      Policy policy = widget.policy;

      Navigator.push(context,MaterialPageRoute(builder: (context) => RiskStatementPage(policy)));
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

  Widget build(BuildContext context) {
    bool _isChecked = false;
    return Scaffold(
      appBar: CustomAppBarSales("Términos y condiciones"),
      body:SingleChildScrollView(child: Builder(
        builder: (BuildContext context) {
          return buildForm(context); // Pasa el contexto obtenido
        },
      ))
    );
  }

  Widget buildForm(BuildContext context) {
    String? _comment;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          color: Colors.transparent,
          //margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Text(
                "1. En el marco de lo establecido en la Providencia Administrativa N° SAA-01-0506-2024 emanada de la Superintendencia de la Actividad Aseguradora en fecha 29 de agosto de 2024, publicada en la Gaceta Oficial N° 6.835 de fecha 03 de septiembre de 2024 sobre las Normas que Regulan Los Contratos de Seguro y de Medicina Prepagada, para la suscripción de pólizas de seguros, y de conformidad con lo establecido en el artículo 12 y 17, en aras de adecuar los aspectos regulatorios de la actividad aseguradora en cuanto a la emisión de pólizas de seguros que se comercializan a través de canales alternos, La Mundial de Seguros, C.A. pone a disposición de sus clientes el Landing Page, una herramienta tecnológica para prestar los servicios que estos requieran.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "2. En cuanto a la aceptación de contratación, el cliente declara: Manifiesto expresamente bajo fe de juramento que las declaraciones de datos solicitadas en el presente aplicativo web han sido realizadas directamente por mi persona. En consecuencia, tal información es fidedigna e indubitada, motivo por el cual, constituye mi consentimiento expreso, de aceptación de la presente póliza. Con esta declaración garantizo la implementación adecuada de la “Política Conozca a su Cliente” así como la identificación exacta del contratante y/o beneficiarios que formarán parte del contrato de seguros.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "3. Mediante la mencionada herramienta tecnológica, los clientes podrán gestionar la experiencia de emisión de pólizas de seguros, realizar pagos; y a su vez suscribir las declaraciones juradas que correspondan, en señal de aceptación y conocimiento de las generalidades que comprenden la suscripción de pólizas de seguros a través de experiencias digitales.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "4. En cuanto a la veracidad de los datos suministrados, el Cliente manifiesta: Declaro que todos los datos suministrados por mí a La Mundial de Seguros, C.A., son veraces, verificables y comprobables. En razón de lo anterior, autorizo a La Mundial de Seguros, C.A., a comprobar por medios propios o contratados, públicos o privados, la información aquí suministrada, y exonero, de las responsabilidades a las que hubiera lugar, en caso de comprobarse suministro de datos falsos para dar así cumplimiento a lo establecido en las Normas Legales vigentes.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "5. En cuanto al Origen de los Fondos, el cliente manifiesta: Yo, tomador de la Póliza, doy fe que el dinero utilizado para el pago de la prima, proviene de actividades lícitas y, por tanto, no tiene relación alguna con dinero, capitales, bienes, haberes, valores o títulos que se consideren producto de las actividades o acciones derivadas de operaciones ilícitas contempladas en la Ley Orgánica Contra la Delincuencia Organizada y Financiamiento al Terrorismo, y/o en la Ley Orgánica de Drogas.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "6. En cuanto a la “Política Conozca a Su Cliente” de la Providencia Administrativa N° SAA-01-0536- 2024, sobre Normas de Administración de Riesgos LC/FT/FPADM y Otros Ilícitos, en cuanto a la conformación del expediente, el cliente manifiesta: Declaro que, una vez adquirida la póliza de seguro requerida, cumpliré con enviar de forma digital/o físico los recaudos necesarios para la conformación del expediente de suscripción que corresponde, los cuales serán solicitados e identificados por La Mundial de Seguros, C.A. vía correo electrónico.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "7. En cuanto a la aceptación de comunicación vía correo electrónico, a través de la dirección suministrada a través del Landing Page, el cliente declara: Acepto recibir comunicaciones de parte de La Mundial de Seguros C.A., en el correo electrónico registrado en el presente aplicativo web, y entiendo que todos los contratos, avisos, notificaciones y/o otras comunicaciones que me envíen por medios electrónicos satisfará cualquier requisito de forma escrita, salvo que cualquier legislación aplicable con carácter imperativo exigiera una forma distinta de comunicación.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "8. En cuanto a los Términos y Condiciones de suscripción y prestación de servicios de La Mundial de Seguros, C.A., el cliente manifiesta: Declaro que he leído y que acepto los términos y condiciones inherentes a la contratación de productos y servicios electrónicos.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 10),
              Divider(),
              Text(
                "9. En cuanto a las Condiciones, Generales y Particulares, y Anexos contratados, el cliente manifiesta: Declaro que he leído, conozco y acepto las condiciones generales y particulares de la póliza contratada y anexo que ha sido debidamente enviado a mi correo electrónico una vez concluido el proceso digital realizado a través de la herramienta tecnológica Landing Page de La Mundial de Seguros, C.A.",
                //textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins"
                ),
              ),
              Divider(),
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
            ],
          )),
    );
  }
}
