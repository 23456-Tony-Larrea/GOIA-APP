import { Router } from "express";
import {getDepartment,getDepartmentById,createDepartment,changeStateDepartment,updateDepartment} from '../controllers/DepartmentsController.js'

const router = Router();

router.get('/departments',getDepartment);

router.get('/departments/:id',getDepartmentById);

router.post('/departments/',createDepartment);
router.put('/departments/:id',updateDepartment);

router.put('/departments/:id/state',changeStateDepartment);

export default router;