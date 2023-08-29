class Users {
  final int id;
  final String username;
  final int role_id; 
  final String password;
  final String role;  // Cambio aquí: Cambiar el tipo de dato a String para almacenar el nombre del rol


  Users({
    required this.id,
    required this.username,
    required this.role_id,
    required this.password,
    required this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      username: json['username'] as String,  // Cambio aquí: 'username' en lugar de 'name'
      role_id: json['role_id'] as int,
      password: json['password'] as String,
      role: json['role']['name'] as String,  // Cambio aquí: Acceder al campo 'name' dentro de 'role'
    );
  }
}
