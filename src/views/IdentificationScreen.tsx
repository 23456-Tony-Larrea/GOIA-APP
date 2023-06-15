import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { Camera } from 'expo-camera';

interface ICars {
  id: number;
  identityCar: string;
  marca: string;
  model: string;
  identity: string;
  client: string;
}

const IdentificationCard = () => {
  const [plateNumber, setPlateNumber] = useState('');
  const [vehicleInfo, setVehicleInfo] = useState<ICars[]>([]);
  const [searched, setSearched] = useState(false);
  const [cameraRef, setCameraRef] = useState<Camera | null>(null);
  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null); // Asegura que el estado sea del tipo correcto



    useEffect(() => {
        (async () => {
          const { status } = await Camera.requestCameraPermissionsAsync();
          setHasCameraPermission(status === 'granted');
        })();
      }, []);


  const searchVehicle = async () => {
    try {
      const response = await axios.get(`/cars/${plateNumber}`);
      setVehicleInfo(response.data);
      setSearched(true);
    } catch (error) {
      console.error(error);
    }
  };

  const takePhoto = async (id: number) => {
    
    console.log(`Foto tomada del vehículo con ID: ${id}`);
     
    if (cameraRef) {
      const photo = await cameraRef.takePictureAsync();
      console.log(`Foto tomada del vehículo con ID: ${id}`);
    }
  };

  return (
    
    <View style={styles.container}>
      <View style={styles.card}>
        <Text style={styles.cardTitle}>Identificación del vehículo</Text>
        <View style={styles.inputContainer}>
          <Icon name="car" size={24} color="#999" style={styles.inputIcon} />
          <TextInput
            placeholder="Ingrese la placa del vehículo a buscar"
            style={styles.input}
            value={plateNumber}
            onChangeText={text => setPlateNumber(text)}
          />
          <TouchableOpacity onPress={searchVehicle}>
            <Icon name="search" size={24} color="#007AFF" style={styles.searchIcon} />
          </TouchableOpacity>
        </View>
      </View>

      {searched && (
        <>
          {vehicleInfo.length === 0 ? (
            <Text>No se encontraron resultados para este vehículo.</Text>
          ) : (
            vehicleInfo.map((vehicle, index) => (
              <View key={index} style={styles.card}>
                <Text style={styles.cardTitle}>Información del vehículo</Text>
                <View style={styles.infoContainer}>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>Marca:</Text>
                    <Text style={styles.value}>{vehicle.marca}</Text>
                  </View>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>Cliente:</Text>
                    <Text style={styles.value}>{vehicle.client}</Text>
                  </View>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>Modelo:</Text>
                    <Text style={styles.value}>{vehicle.model}</Text>
                  </View>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>No. Cédula:</Text>
                    <Text style={styles.value}>{vehicle.identity}</Text>
                  </View>
                </View>

                <TouchableOpacity style={styles.cameraButton} onPress={() => takePhoto(vehicle.id)}>
                  <Icon name="camera" size={24} color="#FFF" />
                  <Text style={styles.cameraText}>Tomar foto</Text>
                </TouchableOpacity>
              </View>
            ))
          )}
        </>
      )}

      <View style={styles.emptyDiv}></View>
    </View>
  );
};

export default function App() {
  return (
    <View style={styles.appContainer}>
      <IdentificationCard />
    </View>
  );
}

const styles = StyleSheet.create({
  appContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  container: {
    width: '100%',
    alignItems: 'center',
    marginBottom: 20,
  },
  card: {
    backgroundColor: '#FFF',
    borderRadius: 5,
    padding: 20,
    marginBottom: 10,
    width: '100%',
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#999',
    borderRadius: 5,
    paddingHorizontal: 10,
    marginBottom: 10,
  },
  inputIcon: {
    marginRight: 10,
  },
  input: {
    flex: 1,
  },
  searchIcon: {
    marginLeft: 10,
  },
  copyIcon: {
    marginLeft: 10,
  },
  infoContainer: {
    marginTop: 10,
  },
  labelRow: {
    flexDirection: 'row',
    marginBottom: 5,
  },
  label: {
    fontWeight: 'bold',
    marginRight: 5,
  },
  value: {
    flex: 1,
  },
  cameraButton: {
    flexDirection: 'row',
    backgroundColor: '#FF3B30',
    borderRadius: 3,
    padding: 7,
    alignItems: 'center',
  },
  cameraText: {
    color: '#FFF',
    marginLeft: 10,
  },
  emptyDiv: {
    height: 200,
    width: '100%',
  },
});
