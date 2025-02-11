// ignore_for_file: file_names

class Plan {
  final int cramo;
  final String cplan;
  final String xplan;
  final String cmoneda;
  final double sumaAseguradaPlanBs;
  final double sumaAseguradaPlanExt;
  final double primaPlanBs;
  final double primaPlanExt;

  Plan({
    required this.cramo,
    required this.cplan,
    required this.xplan,
    required this.cmoneda,
    required this.sumaAseguradaPlanBs,
    required this.sumaAseguradaPlanExt,
    required this.primaPlanBs,
    required this.primaPlanExt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      cramo: json['cramo'],
      cplan: json['cplan'],
      xplan: json['xplan'],
      cmoneda: json['cmoneda'],
      sumaAseguradaPlanBs: json['Suma asegurada Plan Bs'].toDouble(),
      sumaAseguradaPlanExt: json['Suma asegurada Plan Ext'].toDouble(),
      primaPlanBs: json['Prima Plan Bs'].toDouble(),
      primaPlanExt: json['Prima Plan EXT'].toDouble(),
    );
  }
}