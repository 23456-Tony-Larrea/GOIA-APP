class Defecto {
  final int codigo;
  final String descripcion;
  final String abreviatura;
  final String numero;
  final String codigo_as400;

  Defecto({
    required this.codigo,
    required this.descripcion,
    required this.abreviatura,
    required this.numero,
    required this.codigo_as400,
  });

  factory Defecto.fromJson(Map<String, dynamic> json) {
    return Defecto(
      codigo: json['codigo'] as int,
      descripcion: json['descripcion'] as String,
      abreviatura: json['abreviatura'] as String,
      numero: json['numero'] as String,
      codigo_as400: json['codigo_as400'] as String,
    );
  }
}
