import 'package:json_annotation/json_annotation.dart';

part 'Brand.g.dart';

@JsonSerializable()
class Brand {

  final int id;
  final String name;

  Brand(this.id,this.name);

  // Métodos generados automáticamente
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  Map<String, dynamic> toJson() => _$BrandToJson(this);

  // Método para crear una instancia desde un mapa JSON
  factory Brand.fromJsonApi(Map<String, dynamic> json) {
    return Brand(
      json['cmarca'], // Asegura que sea un entero
      json['xmarca'],
    );
  }

}
