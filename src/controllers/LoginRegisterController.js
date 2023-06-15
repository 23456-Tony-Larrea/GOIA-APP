import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import { Users } from '../models/Users.js';
import { Role } from '../models/Role.js'; // Importa el modelo de tu tabla de roles

export const login = async (req, res) => {
  const { username, password } = req.body;

  Users.findOne({
    where: {
      username
    },
  })
    .then((user) => {
      if (!user) {
        return res.status(401).send({ error: 'Invalid name or password' });
      }

      // Comparar contraseña
      const validPassword = bcrypt.compareSync(password, user.password);
      if (!validPassword) {
        return res.status(401).send({ error: 'Invalid name or password' });
      }

      // Obtener el rol asociado al user
      Role.findOne({ where: { id: user.role_id } })
        .then((role) => {
          // Verificar si se encontró el rol
          if (!role) {
            return res.status(404).send({ error: 'Role not found' });
          }

          // Generar token con el nombre del rol incluido
          const token = jwt.sign(
            { id: user.id, name: user.username, nameRole: role.name ,role_id:role.id }, // Incluye el nombre del rol en el token
            'secretkey',
            {
              expiresIn: 60 * 60 * 24,
            }
          );
          console.log(token);
          Users.update(
            { token, token_type: 'Bearer' },
            {
              where: {
                id: user.id,
                token: token
              },
            }
          );

          // Agregar el nombre del rol al objeto de respuesta
          const response = {
            id: user.id,
            username: user.username,
            role: role.name, // Agrega el nombre del rol al objeto de respuesta
            token
          };
          res.status(200).send(response);
        })
        .catch((err) => {
          console.error(err);
          return res.status(500).send({ error: 'Server error' });
        });
    })
    .catch((err) => {
      console.error(err);
    });
};
//register user
export const register = async (req, res) => {
    const {username,role_id} = req.body;
    const password = bcrypt.hashSync(req.body.password, 10);
    Users.create({
        username,
        password,
        role_id,
        state:true
        }).then((user) => {
        const token = jwt.sign({id: user.id, username: user.username,role_id}, 'secretkey', {
            expiresIn: 60 * 60 * 24
        } 
        );
        Users.update({token,
        token_type: 'Bearer'
        }, {
            where: {
                id: user.id
            }
        })
        res.status(200).send({token,
            token_type: 'Bearer',
            message: 'User created successfully'  
        })
        
    }).catch((err) => {
     if(err.name==='SequelizeUniqueConstraintError'){
          res.status(500).json({
              message: 'username already exists',
              data: {}
          });
      }else{
      console.error(err);
        res.status(500).json({
        message: 'Something goes wrong',
        data: {}
      
    });
  }
    })
}