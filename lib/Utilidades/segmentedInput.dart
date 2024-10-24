import 'package:flutter/material.dart';

class SegmentedInput extends StatelessWidget {
  final int numberOfSegments;
  final TextEditingController controller;

  const SegmentedInput({
    super.key,
    required this.numberOfSegments,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
                      numberOfSegments,
                      (index) =>  SizedBox(
                                  width: 40, // Adjust the width as needed
                                    child: Container(
                                      decoration: BoxDecoration(// Color de fondo gris
                                          borderRadius: BorderRadius.only(
                                            topLeft:  Radius.zero,
                                            topRight:  Radius.circular(20.0),
                                            bottomLeft:  Radius.circular(20.0),
                                            bottomRight: Radius.zero,
                                          ),
                                          border: Border.all(
                                            color: Color.fromRGBO(79, 127, 198, 1),
                                          )),
                                      child: TextField(
                                        style: const TextStyle(
                                          color: Colors.black, // Color del texto
                                          fontFamily: 'Poppins',
                                          // Otros estilos de texto que desees aplicar
                                        ),
                                        controller: TextEditingController(text: controller.text.length > index ? controller.text[index] : ''),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12.0,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          // Update the main controller with proper validation
                                          final newText = updateMainController(controller.text, index, value);
                                          if (newText != null) {
                                            controller.text = newText;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                    ),
      );
  }

  String? updateMainController(String currentText, int index, String newValue) {
    if (newValue.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(newValue)) {
      return null; // Prevent invalid input
    }

    if (currentText.length <= index) {
      // Handle cases where the current text is shorter than the number of segments
      return currentText + newValue;
    } else {
      return currentText.substring(0, index) + newValue + currentText.substring(index + 1);
    }
  }
}