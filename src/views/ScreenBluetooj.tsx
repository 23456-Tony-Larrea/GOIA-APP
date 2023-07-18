import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, PermissionsAndroid, Button } from 'react-native';
import { BleManager, Device, Subscription } from 'react-native-ble-plx';

const BLEScanner = () => {
  const [scanning, setScanning] = useState(false);
  const [devices, setDevices] = useState<Device[]>([]);
  const bleManager = new BleManager();

  useEffect(() => {
    const subscription: Subscription = bleManager.onStateChange((state) => {
      if (state === 'PoweredOn') {
        if (scanning) {
          startScan();
        }
      } else if (state === 'PoweredOff') {
        stopScan();
      }
    }, true);

    return () => {
      subscription.remove();
      stopScan();
    };
  }, [scanning]);

  const startScan = async () => {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        {
          title: 'Permiso de Ubicación',
          message: 'La aplicación necesita acceso a tu ubicación para escanear dispositivos Bluetooth.',
          buttonPositive: 'OK',
          buttonNegative: 'Cancelar',
        },
      );

      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        bleManager.startDeviceScan(null, null, (error, scannedDevice) => {
          if (error) {
            console.error('Error en el escaneo:', error);
            return;
          }

          if (scannedDevice && !devices.some((device) => device.id === scannedDevice.id)) {
            setDevices((prevDevices) => [...prevDevices, scannedDevice]);
          }
        });

        setScanning(true);
      } else {
        console.warn('Permiso de ubicación denegado.');
      }
    } catch (error) {
      console.error('Error al iniciar el escaneo:', error);
    }
  };

  const stopScan = () => {
    bleManager.stopDeviceScan();
    setScanning(false);
  };

  const connectToDevice = async (device: Device) => {
    try {
      await device.connect(); // Conexión al dispositivo
      console.log('Conexión exitosa:', device.id);
      const connectedDevice = await device.discoverAllServicesAndCharacteristics();

      console.log('Conexión exitosa:', connectedDevice.id);

    


      // Aquí puedes realizar cualquier acción que necesites después de la conexión.
      // Por ejemplo, descubrir servicios, leer características, escribir datos, etc.
    } catch (error) {
      console.error('Error al conectarse al dispositivo:', error);
    }
  };

  return (
    <View>
      <Button
        title={scanning ? 'Detener escaneo' : 'Iniciar escaneo'}
        onPress={() => (scanning ? stopScan() : startScan())}
      />
      <FlatList
        data={devices}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View>
            <Text>{item.name || 'Dispositivo sin nombre'}</Text>
            <Button title="Conectar" onPress={() => connectToDevice(item)} />
          </View>
        )}
      />
    </View>
  );
};

export default BLEScanner;
