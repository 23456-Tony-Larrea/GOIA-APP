import { Router } from "express";
import {createUserWithDepartments,getUserDepartments,updateUserDepartments} from '../controllers/UserDepartmentsController.js'

const router = Router();

router.post('/createUserWithDepartments',createUserWithDepartments);

router.get('/getUserDepartments',getUserDepartments);

router.put('/updateUserDepartments',updateUserDepartments);