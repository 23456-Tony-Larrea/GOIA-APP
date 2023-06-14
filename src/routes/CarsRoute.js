import { Router } from "express";
import {createCars,getCars,searchCars}from '../controllers/CarsController.js'


const router = Router();
router.get('/cars',getCars)

router.post('/cars',createCars)

router.get('/cars/:identityCar',searchCars)


export default router;