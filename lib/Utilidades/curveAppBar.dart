// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CurveAppBar extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    final Path path = Path();
    path.moveTo(0,0);
    path.lineTo(0,size.height - 40);
    path.quadraticBezierTo(size.width / 4,size.height,size.width/1.5,size.height - 45);
    path.lineTo(size.width+400,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper){
    return true;
    //throw UnimplementedError();
  }
}