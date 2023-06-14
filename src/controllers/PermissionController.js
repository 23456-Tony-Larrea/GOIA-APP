import { Permission } from "../models/Permissions.js";

export const createPermission = async (req, res) => {
    try {
        const  {name}=req.body
        let newPermission = await Permission.create({
            name
        },{
            fields: ['name']
        });
        if (newPermission) {
            return res.json({
                message: 'Permission created successfully',
                data: newPermission
            });
        }
    }
    catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}  
export const getPermissions = async (req, res) => {
    try {
        const permissions = await Permission.findAll();
        res.json({
            data: permissions
        });
    } catch (e) {
        console.log(e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}
