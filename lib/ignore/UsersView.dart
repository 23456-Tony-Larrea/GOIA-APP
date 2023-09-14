import 'package:flutter/material.dart';
import 'package:rtv/ignore/controllers/UsersControllers.dart';
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
  int selectedRoleId = 0;
  late Role selectedRole; // Declaración de la variable selectedRole

  @override
  void initState() {
    super.initState();
    _users = _controller.getUsers();
    _loadUsers();
    _roles = _controller.getRoles();
    _loadRoles();
    selectedRole = Role(id: 0, name: '');
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
       appBar: AppBar(
        title: Text('Usuarios'), // Cambia el título del AppBar
      ),
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
        subtitle: RichText(
  text: TextSpan(
    text: 'Rol del usuario ',
    style: DefaultTextStyle.of(context).style,
    children: <TextSpan>[
      TextSpan(
        text: user.role,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<Role>>(
              future:
                  _roles, // La variable _roles debe ser un Future<List<Role>>
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Muestra un indicador de carga mientras espera la resolución del Future
                } else if (snapshot.hasError) {
                  return Text('Error al cargar los roles');
                } else if (snapshot.hasData) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditUserDialog(context, user);
                    },
                  );
                } else {
                  return SizedBox(); // En caso de que no haya datos aún
                }
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

    Role selectedRole = roles[0]; // Valor predeterminado

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
              SizedBox(height: 20),
              DropdownButton<Role>(
                value: selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    selectedRole = newValue!;
                    selectedRoleId =
                        newValue.id; // Actualizar el ID seleccionado
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
              onPressed: () async {
                // Aquí puedes usar selectedRoleId para obtener el ID del rol seleccionado
                // Llamar a la función addUser y enviar el ID
                await _controller.addUser(context, selectedRoleId);
                _loadUsers(); // Actualiza la lista de usuarios después de agregar
                Navigator.pop(context); // Cerrar el diálogo
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

  void _showEditUserDialog(BuildContext context, Users user) async {
    List<Role> roles = await _roles;

    Role selectedRole = roles.firstWhere((role) => role.id == user.role_id);
    TextEditingController nameController =
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
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 20),
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
                // Here you can call your updateUsers function
                _controller.updateUsers(
                    context, user.id, nameController.text, selectedRole.id);
                _loadUsers();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
