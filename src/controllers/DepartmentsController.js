import { Department } from "../models/Department.js";

export const getDepartment = async (req,res)=>{
    try{
        const departments = await Department.findAll();
        res.status(200).json(departments);
    }
    catch(err){
        res.status(500).json(err);
    }
}


export const createDepartment= async(req,res)=>{
        const {name}=req.body;
        try{
            let newDepartment= await Department.create({
                name,
                state:true
            },{
                fields:['name','state']
            })
            if(newDepartment){
                return res.json({
                    message:'Department created successfully',
                    data:newDepartment
                })
            }
        } catch(e){
            console.log("the error is: ", e);
            res.status(500).json({
                message: 'Something goes wrong',
                data: {}
            });
        }
}

export const updateDepartment= async(req,res)=>{
    const {id} = req.params;
    const {name} = req.body;
    try{
        const departments = await Department.findAll({
            attributes: ['id', 'name'],
            where: {
                id
            }
        });
        if(departments.length > 0){
            departments.forEach(async user => {
                await user.update({
                    name
                });
            });
        } 
        return res.json({
            message: 'User updated successfully',
            data: departments
        });
    }catch(e){
        console.log("the error is: ", e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}
export const changeStateDepartment = async (req,res)=>{
    try {
        const {id} = req.params;
        try {
            const departments = await Department.findOne({
                where: {id}
            });
            if(departments.state){
                departments.state=false;
            }else{
                departments.state=true;
            }
            await departments.save();
            res.json({
                data: departments
            });
        } catch (error) {
            console.log(error);
        }
}
    catch(err){
        res.status(500).json(err);
    }
}
export const getDepartmentById = async (req,res)=>{
    const {id} = req.params;
    try{
        const department = await Department.findAll({
            where:{
                id
            }
        })
        if(department.length>0){
            res.status(200).json(department);
        }
    }
    catch(err){
        res.status(500).json(err);
    }
}