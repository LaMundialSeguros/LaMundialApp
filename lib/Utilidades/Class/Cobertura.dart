// ignore_for_file: file_names, prefer_null_aware_operators

class Cobertura {
  final int ramo;
  final String cplan;
  final String cobertura;
  final String moneda;
  final double? msumaaseg;
  final double? msumaasegext;
  final double? mprima;
  final double? mprimaext;
  final double tasa;

  Cobertura({
    required this.ramo,
    required this.cplan,
    required this.cobertura,
    required this.moneda,
    this.msumaaseg,
    this.msumaasegext,
    this.mprima,
    this.mprimaext,
    required this.tasa,
  });

  factory Cobertura.fromJson(Map<String, dynamic> json) {
    return Cobertura(
      ramo: json['ramo'],
      cplan: json['cplan'],
      cobertura: json['cobertura'],
      moneda: json['moneda'],
      msumaaseg: json['msumaaseg'] != null ? json['msumaaseg'].toDouble() : null,
      msumaasegext: json['msumaasegext'] != null ? json['msumaasegext'].toDouble() : null,
      mprima: json['mprima'] != null ? json['mprima'].toDouble() : null,
      mprimaext: json['mprimaext'] != null ? json['mprimaext'].toDouble() : null,
      tasa: json['tasa'].toDouble(),
    );
  }
}