import {Cars} from '../models/Car.js'

export const createCars = async (req,res)=>{
    const {identityCar,marca,client,model,identity}=req.body
    try{
        let newCar= await Cars.create({
            identityCar,
            marca,
            client,
            model,
            identity
        })
        if(newCar){
            res.status(201).json({
                message:'Car created successfully',
                car:newCar
            })
        }else{
            res.status(400).json({
                message:'Error creating car'
            })
        }
        
    }catch(err){
        res.status(500).json({
            message:err.message
        })
    }
}

export const getCars = async (req,res)=>{
    try{
        let cars=await Cars.findAll()
        if(cars){
            res.status(200).json({
                cars
            })
        }else{
            res.status(404).json({
                message:'Cars not found'
            })
        }
    }catch(err){
        res.status(500).json({
            message:err.message
        })
    }
}

//search by identityCar

export const searchCars = async (req, res) => {
    try {
      const { identityCar } = req.params;
  
      // Buscar carros que coincidan con la identityCard en la base de datos
      const cars = await Cars.findAll({
        where: {
          identityCar: identityCar
        },
      });
  
      res.status(200).json(cars);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al buscar los carros' });
    }
  };
  