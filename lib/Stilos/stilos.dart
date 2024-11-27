import 'package:flutter/material.dart';
import 'dart:core';
import 'package:rflutter_alert/rflutter_alert.dart';

// Estilo de las alertas
var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    animationDuration: const Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      //color: Color.fromARGB(255, 15, 14, 14),
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    constraints: const BoxConstraints.expand(width: 800),
    //First to chars "55" represents transparency of color
    overlayColor: const Color.fromARGB(146, 110, 109, 109),
    alertElevation: 10,
    alertAlignment: Alignment.bottomCenter);

// Fin del estilo
// Estilo de las alertas
var alertStyle2 = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    animationDuration: const Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      //color: Color.fromARGB(255, 15, 14, 14),
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    constraints: const BoxConstraints.expand(width: 600),
    //First to chars "55" represents transparency of color
    overlayColor: const Color.fromARGB(146, 110, 109, 109),
    alertElevation: 10,
    alertAlignment: Alignment.topCenter);

// Fin del estilo
// Estilo de las alertas
var alertStyle3 = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    animationDuration: const Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 60,
      //color: Color.fromARGB(255, 15, 14, 14),
      // ignore: use_full_hex_values_for_flutter_colors
      color: Color(0xffb1763ad),
    ),
    constraints: const BoxConstraints.expand(width: 600),
    //First to chars "55" represents transparency of color
    overlayColor: const Color.fromARGB(146, 110, 109, 109),
    alertElevation: 10,
    alertAlignment: Alignment.topCenter);

// Fin del estilo