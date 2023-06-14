import {Role} from '../models/Role.js';
import {Permission} from '../models/Permissions.js';

export const createRole = async (req, res) => {
    try {
        const  {name }=req.body
        let newRole = await Role.create({
            name
        },{
            fields: ['name']
        });
        //crete all permission when create one role
        const permissions = await Permission.findAll();
        permissions.forEach(async (permission) => {
            await newRole.addPermission(permission);
        }
        );
        if (newRole) {
            return res.json({
                message: 'Role created successfully',
                data: newRole
            });
        }
        return res.status(400).send({
            message: 'Role not created'
        });
        } catch (err) {
            console.log(err);
            return res.status(500).send({
                message: 'Something went wrong'
            });
        }
        };

export const getRoles = async (req, res) => {
    try {
      const roles = await Role.findAll({
      /*   include: [{
          model: Permission,
          attributes: ['id', 'name'],
          through: {
            attributes: []
          }
        }] */
      });
      res.status(200).json(roles);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
  

export const getRoleById = async (req, res) => {
    try {
        const {id} = req.params;
        const role = await Role.findOne({
            where: {
                id
            }
        });
        res.json({
            data: role
        });
    }
    catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}

export const deleteRoleById = async (req, res) => {
    try {
        const {id} = req.params;
        const deleteRowCount = await Role.destroy({
            where: {
                id
            }
        });
        res.json({
            message: 'Role deleted successfully',
            count: deleteRowCount
        });
    }
    catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}

export const updateRoleById = async (req, res) => {
    try {
        const {id} = req.params;
        const {name} = req.body;

        const roles = await Role.findAll({
            attributes: ['id', 'name'],
            where: {
                id
            }
        });

        if (roles.length > 0) {
            roles.forEach(async role => {
                await role.update({
                    name
                });
            })
        }

        return res.json({
            message: 'Role updated successfully',
            data: roles
        });

    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}