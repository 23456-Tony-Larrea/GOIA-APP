import React, { useState } from 'react';
import { View } from 'react-native';
import { Input, Button } from 'react-native-elements';
import axios from '../../axios/axios';
import Toast from 'react-native-toast-message';

const RegisterView = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = () => {
    const data = {
      username: username,
      password: password,
    };

    axios.post('/register', data)
      .then(response => {
        // Manejar la respuesta exitosa
        console.log(response.data);
        Toast.show({
          type: 'success',
          text1: '¡Registro exitoso!',
          text2: 'Has creado una nueva cuenta',
        });
      })
      .catch(error => {
        // Manejar el error
        console.error(error);
        Toast.show({
          type: 'error',
          text1: 'Error de registro',
          text2: 'No se pudo crear la cuenta',
        });
      });
  };

  return (
    <View>
      <Input
        placeholder="Nombre de usuario"
        value={username}
        onChangeText={text => setUsername(text)}
      />
      <Input
        placeholder="Contraseña"
        value={password}
        onChangeText={text => setPassword(text)}
        secureTextEntry
      />
      <Button title="Registrar" onPress={handleRegister} />
      <Toast  />
    </View>
  );
};

export default RegisterView;
