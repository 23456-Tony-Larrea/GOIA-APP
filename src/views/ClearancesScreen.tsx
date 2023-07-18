import React, { useEffect, useState } from 'react';
import { View, Button, PermissionsAndroid, Text, Modal, TextInput } from 'react-native';
import BleManager from 'react-native-ble-manager';
import { NativeModules, NativeEventEmitter } from 'react-native';
import { Buffer } from 'buffer';



const BluetoothScreen: React.FC = () => {
  const [bondedDevices, setBondedDevices] = useState<any[]>([]);
  const [scannedDevices, setScannedDevices] = useState<any[]>([]);
  const [isModalVisible, setIsModalVisible] = useState<boolean>(false);
  const [inputText, setInputText] = useState<string>('');
  const [sendMessageId,setSendMessageId]=useState<string>('');
  const BleManagerModule = NativeModules.BleManager;
  const bleManagerEmitter = new NativeEventEmitter(BleManagerModule);
  const [lastService, setLastService] = useState<null | string>(null);
  const [lastCharacteristic, setLastCharacteristic] = useState<null | string>(null);
  


  useEffect(() => {
    initializeBluetooth();
    requestLocationPermission();
    requestBluetoothConnectPermission();
    getBondedDevices();
  }, []);

  const initializeBluetooth = async () => {
    try {
      await BleManager.start({ showAlert: false });
      console.log('Bluetooth inicializado');
    } catch (error) {
      console.error('Error al inicializar Bluetooth:', error);
    }
  };

  const requestLocationPermission = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION,
        {
          title: 'Permiso de ubicación',
          message: 'La aplicación necesita acceso a su ubicación para escanear dispositivos Bluetooth.',
          buttonNeutral: 'Preguntar luego',
          buttonNegative: 'Cancelar',
          buttonPositive: 'Aceptar',
        }
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        console.log('Permiso de ubicación concedido');
      } else {
        console.warn('Permiso de ubicación denegado');
      }
    } catch (error) {
      console.error('Error al solicitar permiso de ubicación:', error);
    }
  };

  const getBondedDevices = async () => {
    try {
      const devices = await BleManager.getBondedPeripherals();
      console.log('Dispositivos vinculados:', devices);
      setBondedDevices(devices);
    } catch (error) {
      console.error('Error al obtener dispositivos vinculados:', error);
    }
  };

  const scanDevices = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.BLUETOOTH_SCAN,
        {
          title: 'Permiso de escaneo de Bluetooth',
          message: 'Esta aplicación necesita permiso para escanear dispositivos Bluetooth.',
          buttonNeutral: 'Preguntar luego',
          buttonNegative: 'Cancelar',
          buttonPositive: 'Aceptar',
        }
      );

      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        console.log('Permiso de escaneo de Bluetooth concedido');
        BleManager.scan([], 10, true).then(() => {
          console.log('Escaneo de dispositivos Bluetooth iniciado');

          setTimeout(() => {
            BleManager.stopScan().then(() => {
              console.log('Escaneo de dispositivos Bluetooth detenido');

              BleManager.getDiscoveredPeripherals().then((devices) => {
                console.log('Dispositivos encontrados:', devices);
                setScannedDevices(devices);
              });
            });
          }, 10000); // 10 segundos de escaneo, puedes ajustar el tiempo según tus necesidades
        });
      } else {
        console.log('Permiso de escaneo de Bluetooth denegado');
      }
    } catch (error) {
      console.error('Error al solicitar permiso de escaneo de Bluetooth:', error);
    }
  };

  const connectToDevice = async (deviceId: string) => {
    try {
      // Conectar al dispositivo
      await BleManager.connect(deviceId);
      console.log("Conectado al dispositivo:", deviceId);
      setSendMessageId(deviceId);
      setIsModalVisible(true);
  
      // Obtener las características del dispositivo Bluetooth
      const services = await BleManager.retrieveServices(deviceId);
  
      // Verificar si 'services' contiene la propiedad 'characteristics'
      if (services && services.characteristics) {
        const { characteristics } = services;
        let lastService;
        let lastCharacteristic;
  
        // Iterar sobre las características
        characteristics.forEach((characteristic: any) => {
          const { service, characteristic: characteristicUUID } = characteristic;
          lastService = service;
          lastCharacteristic = characteristicUUID;
  
          console.log("serviceUUID:", service);
          console.log("characteristicUUID:", characteristicUUID);
        });
  
        console.log("Último servicio:", lastService);
        
        console.log("Última característica:", lastCharacteristic);
        setLastService(lastService?? null);
        setLastCharacteristic(lastCharacteristic?? null);
      }
    } catch (error) {
      console.error("Error al conectar al dispositivo:", error);
    }
  };

  const handleInputChange = (text: string) => {
    setInputText(text);
  };
  
  
  const sendInputText = async () => {
    try {
      if (!sendMessageId) {
        console.error('Ningún dispositivo seleccionado');
        return;
      }  
      
      const services = await BleManager.retrieveServices(sendMessageId);
      const serviceUUIDs = Object.keys(services);
  
      if (serviceUUIDs.length === 0) {
        console.error('No se encontraron servicios para el dispositivo seleccionado');
        return;
      }
      const data = new Uint8Array([36, 49, 49, 49, 49, 49, 35]);
      const dataArray = Array.from(data); // Convertir Uint8Array a array de números

     
      // Realiza el envío de datos al dispositivo
      console.log(dataArray);

      if (lastService && lastCharacteristic) {
        BleManager.write(
          sendMessageId,
          lastService,
          lastCharacteristic,
          dataArray,
        )
        .then(() => {
          console.log('Datos enviados correctamente'+dataArray);
         })
        .catch((error) => {
          console.error('Error al enviar los datos:', error);
        });
      } else {
        console.error('Error: lastService o lastCharacteristic es null');
      }
    } catch (error) {
      console.error('Error al enviar la trama:', error);
    }
  };
  const requestBluetoothConnectPermission = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.BLUETOOTH_CONNECT,
        {
          title: 'Permiso de conexión Bluetooth',
          message: 'Esta aplicación necesita permiso para conectarse a dispositivos Bluetooth.',
          buttonNeutral: 'Preguntar luego',
          buttonNegative: 'Cancelar',
          buttonPositive: 'Aceptar',
        }
      );

      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        console.log('Permiso de conexión Bluetooth concedido');
      } else {
        console.log('Permiso de conexión Bluetooth denegado');
      }
    } catch (error) {
      console.error('Error al solicitar permiso de conexión Bluetooth:', error);
    }
  };

  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>¡Página de Bluetooth!</Text>
      <Button title="Obtener dispositivos vinculados" onPress={getBondedDevices} />
      {bondedDevices.map((device) => (
        <Button
          key={device.id}
          title={`Conectar a ${device.name}`}
          onPress={() => connectToDevice(device.id)}
        />
      ))}

      <Button title="Escanear dispositivos" onPress={scanDevices} />
      {scannedDevices.map((device) => (
        <Button
          key={device.id}
          title={`Conectar a ${device.name}`}
          onPress={() => connectToDevice(device.id)}
        />
      ))}

      <Modal visible={isModalVisible} animationType="slide">
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <Text>Enviar información al dispositivo</Text>

          <Button title="Enviar" onPress={sendInputText} />
        </View>
      </Modal>
    </View>
  );
};

export default BluetoothScreen;
