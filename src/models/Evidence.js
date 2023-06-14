import { DataTypes } from "sequelize";
import {sequelize} from '../database/database.js'

export const Evidence= sequelize.define('Evidence',{
    id:{
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    image:{
        type: DataTypes.STRING
    }
},
{
    timestamps: false
}
)

