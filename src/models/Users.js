import { DataTypes } from "sequelize";
import {sequelize} from '../database/database.js'
import { Role } from "./Role.js";

export const Users= sequelize.define('users',{
    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true
        },
    username:{
        type:DataTypes.STRING,
        
    },
    role_id: {
        type: DataTypes.INTEGER,
        defaulValue:1,
        references: {
            model:Role,
            key: 'id'
        },
        allowNull: true    
    },
    password: {
        type: DataTypes.TEXT
    },
    state:{
        type:DataTypes.BOOLEAN,
    },
    token: {
        type: DataTypes.TEXT
    },
    token_type: {
        type: DataTypes.TEXT
    }
  
},{
    timestamps:false
})

Users.belongsTo(Role, {foreignKey: 'role_id'});
Role.hasOne(Users, {foreignKey: 'role_id'});
