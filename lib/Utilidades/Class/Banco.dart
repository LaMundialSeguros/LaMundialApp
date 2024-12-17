class Banco {
  final String code;
  final String name;

  Banco({required this.code, required this.name});

  // Método para convertir un Map (JSON) en un objeto Banco
  factory Banco.fromJson(Map<String, dynamic> json) {
    return Banco(
      code: json['Code'],
      name: json['Name'],
    );
  }
}