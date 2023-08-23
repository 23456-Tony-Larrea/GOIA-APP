class Cars {
  final String marca;
  final String modelo;
  final String cedula;
  final String cliente;
  final int codigo;
Cars({
  required this.marca,
  required this.modelo,
  required this.cedula,
  required this.cliente,
  required this.codigo,
});

factory Cars.fromJson(Map<String, dynamic> json) {
  return Cars(
    marca: json['marca'] as String,
    modelo: json['modelo'] as String,
    cedula: json['cedula'] as String,
    cliente: json['cliente'] as String,
    codigo: json['codigo'] as int,
  );
}
}