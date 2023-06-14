import jwt from 'jsonwebtoken';
import bycript from 'bcrypt'
import {Users} from '../models/Users.js';

export const login = async (req, res) => {

    const { username, password } = req.body;
  
    Users.findOne({
      where: {
        username
      },
      
    })
      .then((user) => {
        if (!user) {
          return res.status(401).send({ error: 'Invalid username or password' });
        }
  
        // Compare password
        const validPassword = bycript.compareSync(password, user.password);
        if (!validPassword) {
          return res.status(401).send({ error: 'Invalid username or password' });
        }
  
        // Generate token
        const token = jwt.sign(
          { id: user.id, username: user.username },
          'secretkey',
          {
            expiresIn: 60 * 60 * 24,
          }
        );
        console.log(token);
        Users.update(
          { token ,token_type: 'Bearer'},
          {
            where: {
              id: user.id,
            },
          }
        );
    res.status(200).send({ token });
      })
      .catch((err) => {
        console.error(err);
      });
  };

  export const register = async (req, res) => {
    const {username} = req.body;
    const password = bycript.hashSync(req.body.password, 10);
    Users.create({
        username,
        password,
    }).then((user) => {
        const token = jwt.sign({id: user.id, username: user.username}, 'secretkey', {
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
              message: 'Username or email already exists',
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