import { DataTypes } from "sequelize";
import {sequelize} from '../database/database.js'
import { Evidence } from "./Evidence.js";

export const Cars= sequelize.define('Cars',{
    id:{
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    identityCar:{
        type: DataTypes.STRING,
    },
    marca: {
        type: DataTypes.STRING,
    },
    client:{
        type:DataTypes.STRING,
    },
    model:{
        type:DataTypes.STRING,
    },
    identity:{
        type:DataTypes.STRING,
    },
    id_evidence:{
        type:DataTypes.INTEGER,
        references:{
            model:Evidence,
            key:'id'
        }
    }
},
{
    timestamps: false
}
)

