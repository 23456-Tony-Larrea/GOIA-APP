import { Router } from "express";
import {createEvidence} from '../controllers/EvidenceController.js'
import { upload } from "../middlewares/multer.js";

const router = Router();

router.post('/takePhoto/:id/evidence', upload,createEvidence);

export default router;