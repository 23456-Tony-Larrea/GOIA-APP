import { Router } from "express";
import {getRole_permissionsById,updateRole_permissionState} from '../controllers/RolePermissionController.js'
const router = Router();
router.get('/role_permissions/:id',getRole_permissionsById);
router.put('/roles/:roleId/permissions/:permissionId/state', updateRole_permissionState);


export default router;