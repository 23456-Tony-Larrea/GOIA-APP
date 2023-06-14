import  Sequelize  from "sequelize";
import dotenv from "dotenv";
import path from "path";
const __dirname = path.resolve(path.dirname(""));
dotenv.config(__dirname, "../.env");
export const sequelize =new Sequelize(
    process.env.DB_DATABASE,
    process.env.DB_USERNAME,
    process.env.DB_PASSWORD,   
    {
            host:'localhost',
            dialect: 'mysql',
            }
)
