import { DataTypes } from 'sequelize';
import { sequelize } from '../database/database.js';
import { Role } from './Role.js';
import { Permission } from './Permissions.js';
export const RolePermission = sequelize.define('Role_Permission', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    role_id: {
        type: DataTypes.INTEGER,
       
    },
    permission_id: {
        type: DataTypes.INTEGER,
    },
    state:{
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
  timestamps: false
});

// Relación muchos a muchos entre Permission y Role a través de RolePermission
Permission.belongsToMany(Role, { through: RolePermission, foreignKey: 'permission_id' });
Role.belongsToMany(Permission, { through: RolePermission, foreignKey: 'role_id' });

// Establecer la relación muchos a muchos con el campo adicional state en RolePermission
RolePermission.belongsTo(Permission, { foreignKey: 'permission_id' });
RolePermission.belongsTo(Role, { foreignKey: 'role_id' });