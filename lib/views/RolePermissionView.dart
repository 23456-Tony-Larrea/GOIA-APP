import 'package:flutter/material.dart';
import 'package:rtv/controllers/RolePermissionController.dart';
import 'package:rtv/class/Role.dart';
import 'package:rtv/class/Permission.dart';

import 'package:fluttertoast/fluttertoast.dart';

class RolesView extends StatefulWidget {
  @override
  _RolesViewState createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  final RolePemrissionController _controller = RolePemrissionController();
  late Future<List<Role>> _roles;

  @override
  void initState() {
    super.initState();
    _roles = _controller.getRoles();
    _loadRoles();
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
                _showAddRoleDialog(context);
              },
              child: const Text('Agregar Rol'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Role>>(
                future: _roles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _buildRoleItem(snapshot.data![index]);
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

  Widget _buildRoleItem(Role role) {
    return Card(
      child: ListTile(
        title: Text(role.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit,
                  color: const Color.fromARGB(255, 134, 134, 79)),
              onPressed: () {
                _showEditRoleDialog(context, role);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(context, role);
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permisos del Rol:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<List<Permission>>(
              future: _controller.getPermissionByRoleId(role.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      for (Permission permission in snapshot.data!)
                        _buildPermissionToggle(permission, true, (value) {
                          _updatePermission(role.id, permission, value);
                        }),
                    ],
                  );
                } else {
                  return Text('No se encontraron permisos para este rol.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updatePermission(
      int roleId, Permission permission, bool newState) async {
    permission.state = newState; // Actualiza el estado del permiso localmente

    bool success = await _controller.updateRolePermissionState(
        roleId, permission.id, newState);

    if (success) {
      Fluttertoast.showToast(
        msg: "El permiso se actualizó con éxito",
        // Otras opciones de Toast
      );
    } else {
      Fluttertoast.showToast(
        msg: "No se pudo actualizar el permiso",
        // Otras opciones de Toast
      );
      // Revierte el cambio local si no se actualiza en el backend
      permission.state = !newState;
    }

    setState(() {
      // Actualizar la UI según sea necesario
    });
  }

  Widget _buildPermissionToggle(
      Permission permission, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(permission.name)),
        Switch(
          value: permission.state,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showAddRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nuevo Rol'),
          content: TextField(
            controller: _controller.nameRoleController,
            decoration: InputDecoration(
              hintText: 'Nombre del rol',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Llama a la lógica de agregar rol en el controlador
                await _controller.addrole(context);
                Navigator.pop(context); // Cierra el diálogo
                _loadRoles(); // Actualiza la lista de roles después de agregar uno nuevo
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo sin agregar el rol
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRoleDialog(BuildContext context, Role role) {
    TextEditingController _editController =
        TextEditingController(text: role.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Rol'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              labelText: 'Nuevo Nombre del Rol',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newName = _editController.text;
                bool updated = await _controller.updateRole(role.id, newName);

                if (updated) {
                  Fluttertoast.showToast(
                    msg: "El rol se actualizó con éxito",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "No se pudo actualizar el rol",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                }

                Navigator.pop(context); // Cierra el diálogo
                setState(() {
                  _roles = _controller.getRoles();
                });
              },
              child: Text('Guardar Cambios'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Role role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Rol'),
          content: Text('¿Estás seguro que deseas eliminar este rol?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                bool deleted = await _controller.deleteRole(role.id);

                if (deleted) {
                  Fluttertoast.showToast(
                    msg: "El rol se eliminó con éxito",
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "No se pudo eliminar el rol",
                  );
                }

                setState(() {
                  _roles = _controller.getRoles();
                });
              },
              child: Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
