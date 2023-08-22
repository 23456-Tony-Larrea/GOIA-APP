import 'package:rtv/class/Defecto.dart';  // Import your Defecto class

class ListProcedure {
  final int codigo;
  final int numero;
  final int familia;
  final String subFamilia;
  final String abreviatura;
  final String abreviatura_descripcion;
  final String categoria;
  final String categoria_abreviatura;
  final String categoria_descripcion;
  final String procedimiento;
  final List<Defecto> defectos;  // Use your Defecto class here
  
  // Constructor
  ListProcedure({
    required this.codigo,
    required this.numero,
    required this.familia,
    required this.subFamilia,
    required this.abreviatura,
    required this.abreviatura_descripcion,
    required this.categoria,
    required this.categoria_abreviatura,
    required this.categoria_descripcion,
    required this.procedimiento,
    required this.defectos,
  });

  // Factory method to create a ListProcedure instance from a JSON map
  factory ListProcedure.fromJson(Map<String, dynamic> json) {
    return ListProcedure(
      codigo: json['codigo'],
      numero: json['numero'],
      familia: json['familia'],
      subFamilia: json['subfamilia'],
      abreviatura: json['abreviatura'],
      abreviatura_descripcion: json['abreviatura_descripcion'],
      categoria: json['categoria'],
      categoria_abreviatura: json['categoria_abreviatura'],
      categoria_descripcion: json['categoria_descripcion'],
      procedimiento: json['procedimiento'],
      defectos: List<Defecto>.from(json['defectos'].map((defectoJson) => Defecto.fromJson(defectoJson))),
    );
  }
}
