import { Users } from "../models/Users.js";
import { Role } from "../models/Role.js";
export const getUsers = async (req, res) => {
    try {
        const users = await Users.findAll({
            include:[{ model: Role, attributes: ['name'] }],
            where:{
                state:true
            }
        });
        
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const createUsers= async(req,res)=>{
    const {username,role_id}=req.body;
    try {
        let newUser = await Users.create({
            username,
            role_id,
            state:true
        },{
            fields: ['username','role_id']
        });
        if (newUser) {
            return res.json({
                message: 'User created successfully',
                data: newUser
            });
        }
    }catch(e){
        console.log("the error is: ", e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}


export const getUsersById = async (req, res) => {
    const {id} = req.params;
    try {
        const user = await Users.findOne(
            {
                where: {id}
            }
        );
        res.json({
            data: user
        });
    } catch (error) {
        console.log(error);
    }

};

export const updateUser = async (req, res) => {
    const {id} = req.params;
    const {username,role_id} = req.body;
    try{
        const users = await Users.findAll({
            attributes: ['id', 'username','role_id'],
            where: {
                id
            }
        });
        if(users.length > 0){
            users.forEach(async user => {
                await user.update({
                    username,
                    role_id
                });
            });
        } 
        return res.json({
            message: 'User updated successfully',
            data: users
        });
    }catch(e){
        console.log("the error is: ", e);
        res.status(500).json({
            message: 'Something goes wrong',
            data: {}
        });
    }
}

export const UpdateStateUser= async (req,res)=>{
    const {id} = req.params;
    try {
        const user = await Users.findOne({
            where: {id}
        });
        if(user.state){
            user.state=false;
        }else{
            user.state=true;
        }
        await user.save();
        res.json({
            data: user
        });
    } catch (error) {
        console.log(error);
    }
}
