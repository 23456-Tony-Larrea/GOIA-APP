import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rtv/class/Permission.dart'; // Importa el modelo de Permission
import 'package:rtv/constants/url.dart';

class PermissionController {
  final List<String> _allowedRoles = ['superAdministrador']; // Roles permitidos
  late String _userRole;
  List<Permission> _userPermissions = [];

  Future<void> getUserRoleAndPermissions() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'FlutterSecureStorage.helllo_token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      _userRole = decodedToken['nameRole'];
      int roleId = decodedToken['role_id'];
      if (_allowedRoles.contains(_userRole)) {
        await getUserPermissions(roleId); // Pasa el roleId a getUserPermissions
      }
    }
  }

  Future<void> getUserPermissions(int roleId) async {
    // Añade el parámetro roleId
    final response = await http.get(Uri.parse('${url}/role_permissions/$roleId'));
    if (response.statusCode == 200) {
      final List<dynamic> permissionsData = jsonDecode(response.body)['data'];
      _userPermissions = permissionsData.map((json) => Permission.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load role permissions');
    }
  }

  bool isPermissionAllowed(String permissionName) {
    return _userPermissions.any((permission) => permission.name == permissionName);
  }
}
