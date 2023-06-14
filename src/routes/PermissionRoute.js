import { Router } from "express";
import {createPermission,getPermissions,} from '../controllers/PermissionController.js'

const router = Router();
router.post('/permissions',createPermission);
router.get('/permissions',getPermissions);


export default router;