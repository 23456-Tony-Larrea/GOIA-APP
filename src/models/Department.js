import { DataTypes } from "sequelize";
import {sequelize} from '../database/database.js'

export const Department= sequelize.define('department',{
    id:{
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    name: {
        type: DataTypes.STRING,
    },
    state:{
        type:DataTypes.BOOLEAN,
    }
},
{
    timestamps: false
}
)

