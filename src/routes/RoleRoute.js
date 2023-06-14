import { Router } from "express";
import  {createRole,getRoles,deleteRoleById,getRoleById,updateRoleById} from '../controllers/RoleController.js' 

const router = Router();

router.post('/roles',createRole);
router.get('/roles',getRoles);
router.delete('/roles/:id',deleteRoleById);
router.get('/roles/:id',getRoleById);
router.put('/roles/:id',updateRoleById);


export default router;