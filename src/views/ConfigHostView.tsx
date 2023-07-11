import React, { useState } from 'react';
import { View, StyleSheet, Text, TextInput, Button } from 'react-native';
import axiosInstance from '../../axios/axios2';
import { Toast, ALERT_TYPE , AlertNotificationRoot} from 'react-native-alert-notification';
import AsyncStorage from '@react-native-async-storage/async-storage';


const Config = () => {
  const [host, setHost] = useState('');
  const [data, setData] = useState(null);

  const fetchData = async () => {
    try {
      const response = await axiosInstance.post('/datoEstacion', {
        host: `${host}`,
      });

      setData(response.data);
      if (response.data.length === 0) {
        Toast.show({
          title: 'HOST',
          textBody: 'El host no ha sido encontrado.',
          type: ALERT_TYPE.DANGER,
        });
      }else {
        const estaIp = response.data[0].esta_ip;
        const estaHost = response.data[0].esta_host;
        const host = "http://192.168.2.68:8080"
        await AsyncStorage.setItem('esta_ip', estaIp);
        await AsyncStorage.setItem('esta_host', estaHost);
        await AsyncStorage.setItem('host', host);
          Toast.show({
            title: 'HOST',
            textBody: 'El host ha sido encontrado y guardado.',
            type: ALERT_TYPE.SUCCESS,
          })
      }
    } catch (error) {
      console.error(error);
      Toast.show({
        title: 'Error',
        textBody: 'Ha ocurrido un error al obtener los datos.',
        type: ALERT_TYPE.DANGER,
      });
    }
  };

  return (
    <AlertNotificationRoot>
    <View style={styles.container}>
      <View style={styles.centeredContainer}>
        <Text style={styles.title}>HOST</Text>
        <TextInput
          style={styles.input}
          placeholder="Ingrese el host"
          value={host}
          onChangeText={(text) => setHost(text)}
        />
        <Button title="Obtener Datos" onPress={() => fetchData()} />
      </View>
    </View>
    </AlertNotificationRoot>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  centeredContainer: {
    width: '80%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  input: {
    width: '80%',
    height: 40,
    borderWidth: 1,
    borderColor: 'gray',
    marginBottom: 20,
    paddingHorizontal: 10,
  },
  dataText: {
    marginTop: 20,
    fontSize: 16,
    textAlign: 'center',
  },
});

export default Config;
