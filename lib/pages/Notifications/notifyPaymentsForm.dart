import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lamundialapp/Utilidades/Class/Currency.dart';
import 'package:lamundialapp/Utilidades/Class/TypePayment.dart';
import 'package:lamundialapp/components/bannerNotifyPayments.dart';
import 'package:local_auth/local_auth.dart';


class notifyPaymentsForm extends StatefulWidget {
  const notifyPaymentsForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  NotifyPaymentsFormState createState() => NotifyPaymentsFormState();
}

class NotifyPaymentsFormState extends State<notifyPaymentsForm> {

  final reference = TextEditingController();
  final currency = TextEditingController();
  final amount = TextEditingController();
  var date = TextEditingController();
  FocusNode currencyCodeFocus = FocusNode();
  FocusNode dateCodeFocus = FocusNode();
  FocusNode amountCodeFocus = FocusNode();
  FocusNode referenceCodeFocus = FocusNode();

  var selectedTypePayment = null;
  var selectedCurrency = null;

  List<TypePayment> Genders = [
    TypePayment(1,'Transferencia Bancaria'),
    TypePayment(2,'Pago movil')
  ];

  List<Currency> coins = [
    Currency(1,'USD'),
    Currency(2,'Bs')
  ];
  @override
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

    return Container(
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
                            controller: amount,
                            focusNode: amountCodeFocus,
                            style: const TextStyle(
                              color: Colors.black, // Color del texto
                              fontFamily: 'Poppins',
                              // Otros estilos de texto que desees aplicar
                            ),
                            decoration: InputDecoration(
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
                      items: Genders.map((TypePayment typePayment) {
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
                      controller: reference,
                      focusNode: referenceCodeFocus,
                      style: const TextStyle(
                        color: Colors.black, // Color del texto
                        fontFamily: 'Poppins',
                        // Otros estilos de texto que desees aplicar
                      ),
                      decoration: InputDecoration(
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
                  const SizedBox(height: 30),
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
                            //Save();
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
                ]))));
  }
}