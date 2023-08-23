class CarsRTV {
  final int codigo;
  final String inicio;
  CarsRTV({
    required this.codigo,
    required this.inicio,
  });
  factory CarsRTV.fromJson(Map<String, dynamic> json) {
    return CarsRTV(
      codigo: json['codigo'] as int,
      inicio: json['inicio'] as String,
    );
  }
}
