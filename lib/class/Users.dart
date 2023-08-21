class Users {
  final int id;
  final String username;
  final int role_id; 
  final String password;

  Users({
    required this.id,
    required this.username,
    required this.role_id,
    required this.password,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      username: json['username'] as String,  // Cambio aquí: 'username' en lugar de 'name'
      role_id: json['role_id'] as int,
      password: json['password'] as String,  // Cambio aquí: Puede ser nulo
    );
  }
}
