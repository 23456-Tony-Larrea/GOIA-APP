import { Router } from "express";
import {createEvidence} from '../controllers/EvidenceController'
import { upload } from "../middlewares/multer";

const router = Router();

router.post('takePhoto/:id/evidence', upload,createEvidence);
