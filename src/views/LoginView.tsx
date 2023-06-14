import React, { useState } from 'react';
import { View } from 'react-native';
import { Input, Button } from 'react-native-elements';
import axios from '../../axios/axios';
import Toast from 'react-native-toast-message';
import { NavigationProp } from '@react-navigation/native';
import Icon from 'react-native-vector-icons/FontAwesome'; // Importar el componente Icon



const LoginView = ({ navigation }: { navigation: NavigationProp<any> }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = () => {
    const data = {
      username: username,
      password: password,
    };

    axios.post('/login', data)
      .then(response => {
        // Manejar la respuesta exitosa
        if (response.status === 200) {
          Toast.show({
            type:'success',
            text1: 'Bienvenido',
            text2: response.data.message,
          });
          navigation.navigate('Home');
        } else {
          Toast.show({
            type: 'error',
            text1: 'Error',
            text2: response.data.message,
          });
        }
      })
      .catch(error => {
        // Manejar el error
/*         console.error(error);
 */        Toast.show({
            type: 'error',
            text1: 'Error de inicio de sesión',
            text2: 'Usuario o contraseña incorrectos',
          });
      });
  };
  

  return (
    <View>
      <Input
        placeholder="Nombre de usuario"
        value={username}
        onChangeText={text => setUsername(text)}
        leftIcon={<Icon name="user" size={24} color="black" />} // Agregar el icono al componente Input
      />
      <Input
        placeholder="Contraseña"
        value={password}
        onChangeText={text => setPassword(text)}
        secureTextEntry
        leftIcon={<Icon name="lock" size={24} color="black" />} // Agregar el icono al componente Input
      />
      <Button title="Iniciar sesión" onPress={handleLogin} icon={<Icon name="sign-in" size={20} color="white" />} /> 
      <Button
        title="Registrarse"
        type="clear"
        onPress={() => navigation.navigate('Register')}
        icon={<Icon name="user-plus" size={20} color="black" />} // Agregar el icono al componente Button
      />
      <Toast />
    </View>
  );
};

export default LoginView;