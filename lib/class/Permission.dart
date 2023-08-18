class Permission {
  final int id;
  final String name;
  bool state; // Nuevo atributo para el estado

  Permission({required this.id, required this.name, required this.state});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int,
      name: json['name'] as String,
      state: json['state'] as bool, // Asegúrate de tener isActive en tu API o asigna un valor predeterminado aquí
    );
  }
}