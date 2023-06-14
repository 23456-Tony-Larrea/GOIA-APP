import { Router } from "express";
import {createRole_permission,getRole_permissions,deleteRole_permissionById,getRole_permissionsById,updateRole_permissionState} from '../controllers/RolePermissionController.js'
const router = Router();
router.post('/role_permissions',createRole_permission);
router.get('/role_permissions',getRole_permissions);
router.delete('/role_permissions/:id',deleteRole_permissionById);
router.get('/role_permissions/:id',getRole_permissionsById);
router.put('/role_permissions/:id/state',updateRole_permissionState);

export default router;