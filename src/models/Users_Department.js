import { DataTypes } from 'sequelize';
import { sequelize } from '../database/database.js';
import { Users } from './Users.js';
import { Department } from './Department.js';

export const Users_Departments=sequelize.define("Users_Departments",{
    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true
    },
    user_id:{
        type:DataTypes.INTEGER,
    },
    department_id:{
        type:DataTypes.INTEGER,
    },
    selectDepartment :{
        type:DataTypes.STRING
    }
},{
    timestamps:false
});

//Relations
Users.belongsToMany(Department, {
    through: 'Users_Departments',
    foreignKey: 'user_id',
    otherKey: 'department_id', // Agregar esto si Sequelize no lo infiere automáticamente
    as: 'departments', // Opcional: Puedes establecer un alias para la relación
    // Puedes agregar más opciones aquí si es necesario
  });
  
  Department.belongsToMany(Users, {
    through: 'Users_Departments',
    foreignKey: 'department_id',
    otherKey: 'user_id', // Agregar esto si Sequelize no lo infiere automáticamente
    as: 'users', // Opcional: Puedes establecer un alias para la relación
    // Puedes agregar más opciones aquí si es necesario
  });