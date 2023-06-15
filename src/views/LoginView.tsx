import React, { useState,useEffect } from 'react';
import { View, StyleSheet , Text } from 'react-native';
import { Input, Button } from 'react-native-elements';
import axios from '../../axios/axios';
import Toast from 'react-native-toast-message';
import { NavigationProp } from '@react-navigation/native';
import Icon from 'react-native-vector-icons/FontAwesome'; // Importar el componente Icon
import AsyncStorage from '@react-native-async-storage/async-storage';



const LoginView = ({ navigation }: { navigation: NavigationProp<any> }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');


  const data = {
    username: username,
    password: password,
  };
    const handleLogin = async () => {
      try {
        const response = await axios.post('/login', data);
        if (response.status === 200) {
          const token = response.data.token;
          await AsyncStorage.setItem('token', token);
          Toast.show({
            type: 'success',
            text1: 'Bienvenido',
            text2: response.data.message,
          });
          navigation.navigate('Inicio');
        } else {
          Toast.show({
            type: 'error',
            text1: 'Error',
            text2: response.data.message,
          });
        }
      } catch (error) {
        console.error(error);
        Toast.show({
          type: 'error',
          text1: 'Error de inicio de sesión',
          text2: 'Usuario o contraseña incorrectos',
        });
      }
    };

  return (
    <View>
          <Text style={styles.title}>RTV SYSTEM GOIA-APP</Text>

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
      <Toast />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
  },
});

export default LoginView;