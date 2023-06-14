import { Router } from "express";
import {getUsers,UpdateStateUser,updateUser,getUsersById,createUsers}from "../controllers/UsersController.js"

const router = Router();
router.get('/users',getUsers)
router.post('/users',createUsers)
router.get('/users/:id',getUsersById)
router.put('/users/:id',updateUser)
router.put('/users/activate/:id',UpdateStateUser)


export default router;

