import { Department } from '../../models/Department.js';
import { User } from '../../models/User.js';
import { Users_Departments } from '../../models/Users_Departments.js';

export const createUserWithDepartments = async (req, res) => {
    try {
        const { name, department_id } = req.body; // Obtener name y department_ids del cuerpo de la solicitud
        
        if (!name || !department_ids) {
            return res.status(400).json({
                message: 'name and department_ids are required',
                data: {}
            });
        }
        
        let newUserDepartments = []; // Crear un array para almacenar los nuevos registros de Users_Departments

        // Crear el usuario
        const user = await User.create({ name });

        // Iterar sobre los department_ids recibidos en el array
        for (const department_id of department_id) {
            const newDepartmentsUser = await Users_Departments.create({
                user_id: user.id,
                department_id
            }, {
                fields: ['user_id', 'department_id']
            });
            newUserDepartments.push(newDepartmentsUser); // Agregar el nuevo registro al array
        }

        if (newUserDepartments.length > 0) {
            return res.json({
                message: 'User with departments created successfully',
                data: newUserDepartments
            });
        }
    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something went wrong',
            data: {}
        });
    }
}

export const getUserDepartments = async (req, res) => {
    try {
        const user_departments = await Users_Departments.findAll({
            where: {
                user_id: req.params.id
            },
            include: [{
                model: User,
                attributes: ['name', 'id'],
            },
            {
                model: Department,
                attributes: ['name', 'id'],
            }],
            attributes: []
        });

        // Mapeamos los resultados para extraer solo los departamentos
        const departments = user_departments.map(ud => ud.department);

        res.status(200).json({
            data: departments, // Enviamos solo los departamentos en la respuesta JSON
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

export const updateUserDepartments = async (req, res) => {
    try{
    const {user_id,department_id} = req.body;
    if(!user_id ||!department_id){
        return res.status(400).json({
            message: 'user_id and department_id are required',
            data: {}
        });
    }
    const userDepartments = await Users_Departments.findOne({
        where: {
            user_id: user_id,
            department_id: department_id
        }
    });
    if(!userDepartments){
        return res.status(400).json({
            message: 'user_id and department_id are required',
            data: {}
        });
    }
    const updatedUserDepartments = await userDepartments.update(req.body);
    if(!updatedUserDepartments){
        return res.status(400).json({
            message: 'user_id and department_id are required',
            data: {}
        });
    }
    res.status(200).json({
        message: 'user_id and department_id updated successfully',
        data: updatedUserDepartments
    });
    }catch(e){
        console.log(e);
        res.status(500).json({
            message: 'Something went wrong',
            data: {}
        });
    }
}