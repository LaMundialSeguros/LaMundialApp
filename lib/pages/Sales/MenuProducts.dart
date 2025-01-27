import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lamundialapp/Apis/apis.dart';
import 'package:lamundialapp/Utilidades/Class/Product.dart';
import 'package:lamundialapp/pages/Sales/TakerDetails.dart';
import 'package:http/http.dart' as http;


class MenuProducts extends StatefulWidget{
    const MenuProducts({Key? key}) : super(key: key);
    @override

    MenuProductsPageState createState() => MenuProductsPageState();
}
class MenuProductsPageState extends State<MenuProducts>{
    List<Product> products = [];

    @override
    void initState() {
      super.initState();
      apiServiceGetRamos();
    }

    /*List<Product> products = [
      Product('Salud Individual', 1),
      Product('Salud Familiar', 2),
      Product('Seguro Funerario', 3),
      Product('4 en 1', 4),
      Product('Póliza de Vida', 5),
      Product('R.C.V. Autos', 6),
      Product('R.C.V. Motos', 7),
    ];*/

    Future<void> apiServiceGetRamos() async {
      products = [];
      final url = Uri.parse('https://apisys2000.lamundialdeseguros.com/api/v1/app/getPlanesCorredor');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'xcorreo': GlobalVariables().user.email,
      });

      try {
        final response = await http.post(url,headers: headers,body: body);

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          if (jsonResponse['status'] == true) {
            var records =jsonResponse['result']['records'];
            final List<dynamic> targetProduct = records[0];

            setState(() {
          products = targetProduct
              .where((product) => product['product'] != null) // Filter out products with null 'product'
              .map((product) {
                return Product.fromJsonApi(product);
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

  @override
  Widget build(BuildContext context) {

    final search = TextEditingController();
    FocusNode searchCodeFocus = FocusNode();

    return GridView.count(
      crossAxisCount: 2,
      children: [
        for (var product in products)
          GestureDetector(
            onTap: () {
              if(product.id == 56 || product.id == 57){
                Navigator.push(context,MaterialPageRoute(builder: (context) => TakerDetailsPage(product)));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('En mantenimiento.')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(254, 246, 246, 1),
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(30.0),
                    topRight:  Radius.circular(30.0),
                    bottomLeft:  Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(232, 79, 81, 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(232, 79, 81, 0.35), // Color de la sombra
                      spreadRadius: 2, // Distancia de la sombra
                      blurRadius: 4, // Difuminado de la sombra
                      offset: Offset(0, 3), // Posición de la sombra
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/'+product.id.toString()+'_icon.png',height: 60,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.product,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(15, 26, 90, 1),
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}