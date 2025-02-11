// ignore_for_file: file_names

class Frecuencia {
  final String ifrecuencia;
  final String xdescripcion;

  Frecuencia({required this.ifrecuencia, required this.xdescripcion});

  factory Frecuencia.fromJson(Map<String, dynamic> json) {
    return Frecuencia(
      ifrecuencia: json['ifrecuencia'],
      xdescripcion: json['xdescripcion'],
    );
  }
}