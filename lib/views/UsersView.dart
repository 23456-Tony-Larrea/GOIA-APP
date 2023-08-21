import 'package:flutter/material.dart';
import 'package:rtv/controllers/UsersControllers.dart';
import 'package:rtv/class/Users.dart';
import 'package:rtv/class/Role.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final UsersController _controller = UsersController();
  late Future<List<Users>> _users;
  late Future<List<Role>> _roles;

  @override
  void initState() {
    super.initState();
    _users = _controller.getUsers();
    _loadUsers();
    _roles = _controller.getRoles();
    _loadRoles();

  }

  void _loadUsers() async {
    List<Users> users = await _controller.getUsers();
    setState(() {
      _users = Future.value(users);
    });
  }
  void _loadRoles() async {
    List<Role> roles = await _controller.getRoles();
    setState(() {
      _roles = Future.value(roles);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddUserDialog(context);
              },
              child: const Text('Agregar Usuario'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Users>>(
                future: _users,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _buildUserItem(snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(Users user) {
    return Card(
      child: ListTile(
        title: Text(user.username),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditUserDialog(context, user);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteUserDialog(context, user);
              },
            ),
          ],
        ),
      ),
    );
  }


void _showAddUserDialog(BuildContext context) async {
  List<Role> roles = await _roles;
  Role selectedRole = roles[0];
   showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Agregar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller.nameUserController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            SizedBox(height: 20), // Espacio entre TextField y DropdownButton
            DropdownButton<Role>(
              value: selectedRole,
              onChanged: (newValue) {
                setState(() {
                  selectedRole = newValue!;
                });
              },
              items: roles.map((role) {
                return DropdownMenuItem<Role>(
                  value: role,
                  child: Text(role.name),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Aquí puedes usar selectedRole para obtener el rol seleccionado
              // Ejecutar las acciones necesarias al presionar el botón Aceptar
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}


  void _showDeleteUserDialog(BuildContext context, Users user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content:
              Text('¿Está seguro de eliminar el usuario ${user.username}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _controller.deleteUsers(user.id);
                Navigator.of(context).pop();
                _loadUsers();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, Users user) {
    TextEditingController usernameController =
        TextEditingController(text: user.username);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _controller.updateUsers(user.id, usernameController.text);
                Navigator.of(context).pop();
                _loadUsers();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
