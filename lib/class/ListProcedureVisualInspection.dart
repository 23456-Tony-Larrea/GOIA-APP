class ListProcedureInspection {
  final int codigo;
  final int numero;
  final int familia;
  final String subfamilia;
  final String abreviatura;
  final String abreviaturaDescripcion;
  final String subfamiliaDescripcion;
  final String categoria;
  final String categoriaAbreviatura;
  final String categoriaDescripcion;
  final String procedimiento;
  bool isExpanded = false;
  bool isRated = false;

  final List<Defecto> defectos;
  final DefectoEncontrado defectoEncontrado;

  ListProcedureInspection({
    required this.codigo,
    required this.numero,
    required this.familia,
    required this.subfamilia,
    required this.abreviatura,
    required this.abreviaturaDescripcion,
    required this.subfamiliaDescripcion,
    required this.categoria,
    required this.categoriaAbreviatura,
    required this.categoriaDescripcion,
    required this.procedimiento,
    required this.defectos,
    required this.defectoEncontrado,
  });

  factory ListProcedureInspection.fromJson(Map<String, dynamic> json) {
    return ListProcedureInspection(
      codigo: json['codigo'],
      numero: json['numero'],
      familia: json['familia'],
      subfamilia: json['subfamilia'],
      abreviatura: json['abreviatura'],
      abreviaturaDescripcion: json['abreviatura_descripcion'],
      subfamiliaDescripcion: json['subfamilia_descripcion'],
      categoria: json['categoria'],
      categoriaAbreviatura: json['categoria_abreviatura'],
      categoriaDescripcion: json['categoria_descripcion'],
      procedimiento: json['procedimiento'],
      defectos: List<Defecto>.from(json['defectos'].map((defecto) => Defecto.fromJson(defecto))),
      defectoEncontrado: DefectoEncontrado.fromJson(json['defectoEncontrado']),
    );
  }
   @override
  String toString() {
    return '''
    Código: $codigo
    Número: $numero
    Familia: $familia
    Subfamilia: $subfamilia
    Abreviatura: $abreviatura
    Descripción Abreviatura: $abreviaturaDescripcion
    Descripción Subfamilia: $subfamiliaDescripcion
    Categoría: $categoria
    Abreviatura Categoría: $categoriaAbreviatura
    Descripción Categoría: $categoriaDescripcion
    Procedimiento: $procedimiento
    Defectos: $defectos
    Defecto Encontrado: $defectoEncontrado
    ''';
  }
}

class Defecto {
  final int codigo;
  final String abreviatura;
  final String descripcion;
  final String numero;
  final String codigoAs400;

  Defecto({
    required this.codigo,
    required this.abreviatura,
    required this.descripcion,
    required this.numero,
    required this.codigoAs400,
  });

  factory Defecto.fromJson(Map<String, dynamic> json) {
    return Defecto(
      codigo: json['codigo'],
      abreviatura: json['abreviatura'],
      descripcion: json['descripcion'],
      numero: json['numero'],
      codigoAs400: json['codigo_as400'],
    );
  }
   @override
  String toString() {
    return '''
    Código: $codigo
    Abreviatura: $abreviatura
    Descripción: $descripcion
    Número: $numero
    Código AS400: $codigoAs400
    ''';
  }
}

class DefectoEncontrado {
  String numero;
  String abreviatura;
  String descripcion;
  String codigoAs400;
  String calificacion;
  String ubicacion;
  String observacion;

  DefectoEncontrado({
    this.numero = "",
    this.abreviatura = "",
    this.descripcion = "",
    this.codigoAs400 = "",
    this.calificacion = "",
    this.ubicacion = "",
    this.observacion = "",
  });

  factory DefectoEncontrado.fromJson(Map<String, dynamic> json) {
    return DefectoEncontrado(
      numero: json['numero'],
      abreviatura: json['abreviatura'],
      descripcion: json['descripcion'],
      codigoAs400: json['codigo_as400'],
      calificacion: json['calificacion'],
      ubicacion: json['ubicacion'],
      observacion: json['observacion'],
    ); 
  }
    @override
  String toString() {
    return '''
    Número: $numero
    Abreviatura: $abreviatura
    Descripción: $descripcion
    Código AS400: $codigoAs400
    Calificación: $calificacion
    Ubicación: $ubicacion
    Observación: $observacion
    ''';
  }
}
