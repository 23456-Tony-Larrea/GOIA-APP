import { Permission } from '../models/Permissions.js';
import { Role } from '../models/Role.js';
import { RolePermission } from '../models/RolePermission.js';

export const createRole_permission = async (req, res) => {
    try {
        const { role_id, permission_ids } = req.body; // Obtener role_id y permission_ids del cuerpo de la solicitud
        
        if(!role_id||permission_ids) {
            return res.status(400).json({
                message: 'role_id and permission_ids are required',
                data: {}
            });
        }
        let newRole_permissions = []; // Crear un array para almacenar los nuevos registros de Role_permission

        // Iterar sobre los permission_ids recibidos en el array
        for (const permission_id of permission_ids) {
            const newRole_permission = await RolePermission.create({
                role_id,
                permission_id
            }, {
                fields: ['role_id', 'permission_id']
            });
            newRole_permissions.push(newRole_permission); // Agregar el nuevo registro al array
        }

        if (newRole_permissions.length > 0) {
            return res.json({
                message: 'Role_permissions created successfully',
                data: newRole_permissions
            });
        }
    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something went wrong',
            data: {}
        });
    }
}

export const getRole_permissions = async (req, res) => {
    try {
      const role_permissions = await RolePermission.findAll({
        //join permission and role
        include: [{
            model: Permission,
            attributes: [ 'name'],  
        },
        {
            model: Role,
            attributes: ['name'],
        }]
      });
      res.status(200).json({
        data: role_permissions,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  export const getRole_permissionsById = async (req, res) => {
    try {
      const role_permissions = await RolePermission.findAll({
        where: {
          role_id: req.params.id
        },
        include: [{
          model: Permission,
          attributes: ['id','name'] // Solo incluimos el atributo "name" de la tabla Permission
        },
        {
          model: Role,
          attributes:['id','name']
        }
      ],
        attributes: ['state'] // Incluimos el atributo "state" de la tabla RolePermission
      });
  
      // Mapeamos los resultados para obtener un objeto con el nombre y el estado de cada permiso
      const permissions = role_permissions.map(rp => ({
        id:rp.permission.id,
        name: rp.permission.name,
        state: rp.state
      }));
  
      res.status(200).json({
        data: permissions // Enviamos los nombres y estados de los permisos en la respuesta JSON
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
  

export const deleteRole_permissionById = async (req, res) => {
    try {
        const {id} = req.params;
        const deleteRowCount = await RolePermission.destroy({
            where: {
                id
            }
        });
        res.json({
            message: 'Role_permission deleted successfully',
            count: deleteRowCount
        });
    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}

/* export const updateRole_permissionById = async (req, res) => {
    try {
        const {id} = req.params;
        const {role_id, permission_id, state } = req.body 
        const role_permission = await Role_permission.findByPk(id); 
        if (role_permission) {
            await role_permission.update({
                role_id,
                permission_id,
                state 
            });
            return res.json({
                message: 'Role_permission updated successfully',
                data: role_permission
            });
        } else {
            return res.status(404).json({
                message: 'Role_permission not found',
                data: {}
            });
        }
    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}
 */
export const updateRole_permissionState = async (req, res) => {
  try {
    const { id } = req.params; // ID del RolePermission que deseas actualizar
    const { newState } = req.body; // Nuevo estado que deseas asignar (en este caso, `false`)

    // Buscar el RolePermission por ID
    const role_permission = await RolePermission.findByPk(id);

    if (!role_permission) {
      return res.status(404).json({ error: 'RolePermission no encontrado' });
    }

    // Actualizar el estado del RolePermission
    role_permission.state = newState;
    await role_permission.save();

    res.status(200).json({
      message: 'Estado de RolePermission actualizado correctamente',
      data: {
        id: role_permission.id,
        state: role_permission.state,
      },
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};