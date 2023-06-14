import express from 'express';
import cors from 'cors';
import UsersRoute from './routes/UserRoute.js'
import DepartmentRoute  from './routes/DepartmentRoute.js';
import LoginRegisterRoute from './routes/LoginRegisterRoute.js'
import path from 'path';
import dotenv from 'dotenv';
import CarsRoute from './routes/CarsRoute.js'
import RoleRoute from './routes/RoleRoute.js'
import RolePermission from './routes/RolePermission.js'
import PermissionRoute from './routes/PermissionRoute.js'


const app = express();
app.use(cors())

const __dirname = path.resolve(path.dirname(''));
dotenv.config(__dirname,'../.env')
app.set('port', process.env.PORT);
app.use(express.json());
app.use(UsersRoute)
app.use(DepartmentRoute)
app.use(LoginRegisterRoute)
app.use(CarsRoute)
app.use(RoleRoute)
app.use(RolePermission)
app.use(PermissionRoute)
app.use('/uploads', express.static(path.join(__dirname,'src','public','uploads')));
export default app
