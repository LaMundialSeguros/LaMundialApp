import 'dart:convert';

import 'package:lamundialapp/Utilidades/Class/Maplan.dart';

class ApiResponse {
  final bool status;
  final Result result;

  ApiResponse({required this.status, required this.result});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final List<Maplan> maplanes;

  Result({required this.maplanes});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['maplanes'] as List;
    List<Maplan> maplanList = list.map((i) => Maplan.fromJson(i)).toList();

    return Result(maplanes: maplanList);
  }
}