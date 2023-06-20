import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Text } from 'react-native';
import { Input, Button, Icon } from 'react-native-elements';
import axios from '../../axios/axios';
import { Toast, ALERT_TYPE, AlertNotificationRoot } from 'react-native-alert-notification';
import { NavigationProp } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';

const LoginView = ({ navigation }: { navigation: NavigationProp<any> }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showConfigMenu, setShowConfigMenu] = useState(false);
  const [hostFound, setHostFound] = useState(false);

  useEffect(() => {
    checkHostStatus();
  }, []);

  const checkHostStatus = async () => {
    try {
      const estaIp = await AsyncStorage.getItem('esta_ip');
      const estaHost = await AsyncStorage.getItem('esta_host');

      if (estaIp && estaHost) {
        Toast.show({
          title: 'Bienvenido!',
          textBody: 'El host ha sido encontrado.',
          type: ALERT_TYPE.SUCCESS,
        });
        setHostFound(true);
      } else {
        Toast.show({
          title: 'Error!',
          textBody: 'Por favor, configura el host.',
          type: ALERT_TYPE.WARNING,
        });
        setHostFound(false);
      }
    } catch (error) {
      console.error(error);
    }
  };

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
          title: 'Bienvenido!',
          textBody: 'Inicio de sesión exitoso.',
          type: ALERT_TYPE.SUCCESS,
        });
        navigation.navigate('Inicio');
      } else {
        Toast.show({
          title: 'Error!',
          textBody: 'Credenciales incorrectas.',
          type: ALERT_TYPE.DANGER,
        });
      }
    } catch (error) {
      console.error(error);
      Toast.show({
        title: 'Error!',
        textBody: 'Credenciales incorrectas.',
        type: ALERT_TYPE.DANGER,
      });
    }
  };

  const handleConfigHost = () => {
    setShowConfigMenu(false);
    navigation.navigate('Configuracion Host');
  };

  return (
    <View style={styles.container}>
      <AlertNotificationRoot>
        <View style={styles.header}>
          <Text style={styles.title}>RTV SYSTEM GOIA-APP</Text>
          {!hostFound && (
            <Icon
              name="cog"
              type="font-awesome"
              size={24}
              color="black"
              onPress={() => setShowConfigMenu(!showConfigMenu)}
            />
          )}
          {showConfigMenu && (
            <View style={styles.configMenu}>
              <Text style={styles.configOption} onPress={handleConfigHost}>
                Configurar host
              </Text>
            </View>
          )}
        </View>

        <Input
          placeholder="Nombre de usuario"
          value={username}
          onChangeText={(text) => setUsername(text)}
          leftIcon={<Icon name="user" type="font-awesome" size={24} color="black" />}
        />
        <Input
          placeholder="Contraseña"
          value={password}
          onChangeText={(text) => setPassword(text)}
          secureTextEntry
          leftIcon={<Icon name="lock" type="font-awesome" size={24} color="black" />}
        />
        <Button
          title="Iniciar sesión"
          onPress={handleLogin}
          icon={<Icon name="sign-in" type="font-awesome" size={20} color="white" />}
        />
      </AlertNotificationRoot>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 10,
    marginBottom: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  configMenu: {
    position: 'absolute',
    bottom: 0,
    right: 10,
    backgroundColor: 'white',
    padding: 10,
    borderRadius: 5,
    elevation: 3,
  },
  configOption: {
    fontSize: 16,
    marginBottom: 5,
    textDecorationLine: 'underline',
  },
});

export default LoginView;
