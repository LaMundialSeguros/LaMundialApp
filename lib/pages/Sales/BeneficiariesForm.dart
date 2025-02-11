// ignore_for_file: avoid_print, non_constant_identifier_names, annotate_overrides, avoid_unnecessary_containers


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamundialapp/Utilidades/AppBarSales.dart';
import 'package:lamundialapp/Utilidades/Class/Beneficiary.dart';
import 'package:lamundialapp/Utilidades/Class/Policy.dart';
import 'package:lamundialapp/Utilidades/Class/Relationship.dart';
import 'package:lamundialapp/pages/Sales/RiskStatement.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Utilidades/Class/TypeDoc.dart';


final localAuth = LocalAuthentication();

class BeneficiariesFormPage extends StatefulWidget {
  final Policy policy;
  const BeneficiariesFormPage(this.policy,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  BeneficiariesFormPageState createState() => BeneficiariesFormPageState();
}

class BeneficiariesFormPageState extends State<BeneficiariesFormPage> {
  final List<TextEditingController> _identityCard = [];
  final List<TextEditingController> _name = [];
  final List<TextEditingController> _lastName = [];
  final List<TextEditingController> _percent = [];

  final List<FocusNode> _identityCardCodeFocus = [];
  final List<FocusNode> _nameCodeFocus = [];
  final List<FocusNode> _lastNameCodeFocus = [];
  final List<FocusNode> _percentCodeFocus = [];

  final List _selectedRelationship = [null,null,null,null,null];
  final List _selectedTypeDocs = [null,null,null,null,null];
  int beneficiaries = 0;

  bool isLoading = false;

  List<Relationship> Relationships = [
    Relationship(1,'Madre'),
    Relationship(2,'Padre'),
    Relationship(3,'Hijo/a'),
    Relationship(4,'Esposa/o'),
    Relationship(5,'Hermano/a'),
  ];

  List<TypeDoc> TypeDocs = [
    TypeDoc('V', 'V'),
    TypeDoc('E', 'E')
  ];


  // Poliza a gestionar



  Future<void> Save() async {
    setState(() {
      isLoading = true;
    });

    try {


      Policy policy = widget.policy;

      for (int i = 0; i < widget.policy.familyQuantity; i++) {
        var beneficiary = Beneficiary(_selectedTypeDocs[i],_identityCard[i].text,_name[i].text,_lastName[i].text,_selectedRelationship[i],_percent[i].text);
        policy.beneficiaries.add(beneficiary);
      }

      Navigator.push(context,MaterialPageRoute(builder: (context) => RiskStatementPage(policy)));
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

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarSales("Beneficiarios"),
      body:Padding(
        padding: const EdgeInsets.only(top: 1),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.0,
          progressIndicator: const SpinKitDualRing(
            color: Color.fromRGBO(76, 182, 149, 0.965),
            size: 60.0,
          ),
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
    );
  }

  Widget buildForm(BuildContext context) {

    beneficiaries = widget.policy.detailsOwner.beneficiaries;
    _identityCard.addAll(List.generate(beneficiaries, (_) => TextEditingController()));
    _name.addAll(List.generate(beneficiaries, (_) => TextEditingController()));
    _lastName.addAll(List.generate(beneficiaries, (_) => TextEditingController()));
    _percent.addAll(List.generate(beneficiaries, (_) => TextEditingController()));
    _identityCardCodeFocus.addAll(List.generate(5, (_) => FocusNode()));
    _nameCodeFocus.addAll(List.generate(beneficiaries, (_) => FocusNode()));
    _lastNameCodeFocus.addAll(List.generate(beneficiaries, (_) => FocusNode()));
    _percentCodeFocus.addAll(List.generate(beneficiaries, (_) => FocusNode()));

    int i=0;
    return Container(
        color: Colors.transparent,
        //margin: const EdgeInsets.only(top: 0),
        child: Form(
            child: Center(
                child: ListView.builder(
                itemCount: beneficiaries, //// CAMBIAR POR LA CANTIDAD DE BENEFICIARIOS
                itemBuilder: (context, index) {
                  i++;
                  return Column(
                      children: [
                        const SizedBox(height: 25),
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Beneficiario",
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
                                    borderRadius: const BorderRadius.only(
                                      topLeft:  Radius.zero,
                                      topRight:  Radius.circular(30.0),
                                      bottomLeft:  Radius.circular(30.0),
                                      bottomRight: Radius.zero,
                                    ),
                                    border: Border.all(
                                      color: const Color.fromRGBO(79, 127, 198, 1),
                                    )),
                                child: DropdownButtonFormField<TypeDoc>(
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                  iconSize: 0,
                                  value: _selectedTypeDocs[index],
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(30.0),
                                    bottomLeft:  Radius.circular(30.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  onChanged: (TypeDoc? newValue) {
                                    setState(() {
                                      _selectedTypeDocs[index] = newValue;
                                    });
                                  },
                                  items: TypeDocs.map((TypeDoc tipoDoc) {
                                    return DropdownMenuItem<TypeDoc>(
                                      value: tipoDoc,
                                      child: Text(tipoDoc.name),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 35),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)),
                                    suffixIcon: Container(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(40.0),
                                    bottomLeft:  Radius.circular(40.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  border: Border.all(
                                    color: const Color.fromRGBO(79, 127, 198, 1),
                                  ), // Borde rojo
                                ),
                                child: TextField(
                                  controller: _identityCard[index],
                                  focusNode: _identityCardCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Cédula de Identidad',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(40.0),
                                    bottomLeft:  Radius.circular(40.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  border: Border.all(
                                    color: const Color.fromRGBO(79, 127, 198, 1),
                                  ), // Borde rojo
                                ),
                                child: TextField(
                                  controller: _name[index],
                                  focusNode: _nameCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Nombre',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(40.0),
                                    bottomLeft:  Radius.circular(40.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  border: Border.all(
                                    color: const Color.fromRGBO(79, 127, 198, 1),
                                  ), // Borde rojo
                                ),
                                child: TextField(
                                  controller: _lastName[index],
                                  focusNode: _lastNameCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Apellido',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
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
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(40.0),
                                    bottomLeft:  Radius.circular(40.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  border: Border.all(
                                    color: const Color.fromRGBO(79, 127, 198, 1),
                                  ), // Borde rojo
                                ),
                                child: TextField(
                                  controller: _percent[index],
                                  focusNode: _percentCodeFocus[index],
                                  style: const TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontFamily: 'Poppins',
                                    // Otros estilos de texto que desees aplicar
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: '%',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
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
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(// Color de fondo gris
                                    borderRadius: const BorderRadius.only(
                                      topLeft:  Radius.zero,
                                      topRight:  Radius.circular(30.0),
                                      bottomLeft:  Radius.circular(30.0),
                                      bottomRight: Radius.zero,
                                    ),
                                    border: Border.all(
                                      color: const Color.fromRGBO(79, 127, 198, 1),
                                    )),
                                child: DropdownButtonFormField<Relationship>(
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                  iconSize: 0,
                                  value: _selectedRelationship[index],
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.zero,
                                    topRight:  Radius.circular(30.0),
                                    bottomLeft:  Radius.circular(30.0),
                                    bottomRight: Radius.zero,
                                  ),
                                  onChanged: (Relationship? newValue) {
                                    setState(() {
                                      _selectedRelationship[index] = newValue;
                                    });
                                  },
                                  items: Relationships.map((Relationship relationship) {
                                    return DropdownMenuItem<Relationship>(
                                      value: relationship,
                                      child: Text(relationship.name),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: 'Parentesco',
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(121, 116, 126, 1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)),
                                    suffixIcon: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Boton
                        if(beneficiaries==i)const SizedBox(height: 50),
                        if(beneficiaries==i)Container(
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
                        if(beneficiaries==i)const SizedBox(height: 30)
                      ]
                  );
                },
                                      ))));
  }
}
