import { DataTypes } from 'sequelize';
import { sequelize } from '../database/database.js';

export const Permission = sequelize.define('permission', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    name: {
        type: DataTypes.STRING,
    }
}, {
    timestamps: false
});