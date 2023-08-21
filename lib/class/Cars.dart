class Cars {
  final int id;
  final String identitiyCar;
  final String marca;
  final String modelo;
  final String cedula;
  final String cliente;
  final String codigo;
Cars({
  required this.id,
  required this.identitiyCar,
  required this.marca,
  required this.modelo,
  required this.cedula,
  required this.cliente,
  required this.codigo,
});

factory Cars.fromJson(Map<String, dynamic> json) {
  return Cars(
    id: json['id'] as int,
    identitiyCar: json['identitiyCar'] as String,
    marca: json['marca'] as String,
    modelo: json['modelo'] as String,
    cedula: json['cedula'] as String,
    cliente: json['cliente'] as String,
    codigo: json['codigo'] as String,
  );
}
}