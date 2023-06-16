import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { Camera } from 'expo-camera';
import {ICars} from '../Interface/ICars'
import jwtDecode from 'jwt-decode';
import { IDecodedToken } from '../Interface/IDecodedToken';
import AsyncStorage from '@react-native-async-storage/async-storage';
import CameraScreem from '../views/CameraScreen'

const getToken = async () => {
  try {
    const token = await AsyncStorage.getItem('token');
    return token;
  } catch (error) {
    console.error('Error al obtener el token:', error);
    return null;
  }
};

const decodeToken = async () => {
  try {
    const token = await getToken();
    if (token) {
      const decodedToken = jwtDecode<IDecodedToken>(token);
      console.log('Decoded token:', decodedToken);
      return decodedToken;
    } else {
      console.log('No se encontró un token');
      return null;
    }
  } catch (error) {
    console.error('Error al decodificar el token:', error);
    return null;
  }
};
const IdentificationCard = () => {
  const [idRole,setIdRole]= useState(Number);
  const [plateNumber, setPlateNumber] = useState('');
  const [vehicleInfo, setVehicleInfo] = useState<ICars[]>([]);
  const [searched, setSearched] = useState(false);
  const [cameraRef, setCameraRef] = useState<Camera | null>(null);
  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null); // Asegura que el estado sea del tipo correcto
  const [seeSearch,setSeeSearch]= useState(false);
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [photoUri, setPhotoUri] = useState<string | null>(null);

  const fetchRoleId = async () => {
    const decodedToken = await decodeToken();
    if (decodedToken && decodedToken.role_id) {
      setIdRole(decodedToken.role_id);
    }
  };

    
  const getPermissions = async () => {
    try {
      const response = await axios.get(`/role_permissions/${idRole}`);
      const permissions = response.data.data;
      const viewSearch = permissions.find((permission: any) => permission.name ==='insertar usuarios');
      if (viewSearch && viewSearch.state === false) {
        setSeeSearch(false);
      } else {
        setSeeSearch(true);
      }
    } catch (error) {
      console.error('Error al obtener los permisos:', error);
    }
  };

  useEffect(() => {
        (async () => {
          const { status } = await Camera.requestCameraPermissionsAsync();
          setHasCameraPermission(status === 'granted');
        })();
       fetchRoleId();
       getPermissions()
      },
      []);

    

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
      setPhotoUri(photo.uri);
    }
    if(`Foto tomada del vehículo con ID: ${id}`){
        return (
          <CameraScreem/>
        )
    }

  };
  /* 
   const takePhoto = async () => {
    if (cameraRef) {
      const photo = await cameraRef.takePictureAsync();
      setPhotoUri(photo.uri);
    }
  };
  */
  

  if (hasPermission === false) {
    return <Text>No access to camera</Text>;
  }
 
  {hasPermission && (
    <Camera style={styles.camera} ref={(ref) => setCameraRef(ref)} />
  )}

  return (
    <View style={styles.container}>
      
 <View style={styles.card}>
    <View >
      <Text style={styles.cardTitle}>Identificación</Text>
    </View>
    <View >
      <View style={styles.search}>
        <Icon name="search" size={20} color="#000000" />
        <TextInput
          style={styles.searchInput}
          placeholder="Ingrese el número de placa"
          placeholderTextColor="#000000"
          value={plateNumber}
          onChangeText={setPlateNumber}
        />
      </View>
      <TouchableOpacity
        style={styles.searchButton}
        onPress={searchVehicle}
      >
        <Text style={styles.searchButtonText}>Buscar</Text>
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
  search: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  searchInput: {
    flex: 1,
    marginLeft: 10,
    marginRight: 10,
  },
  searchButton: {
    backgroundColor: '#FF3B30',
    borderRadius: 3,
    padding: 7,
    alignItems: 'center',
  },
  searchButtonText: {
    color: '#FFF',
  },
  camera: {
    flex: 1,
    width: '100%',
  },
});
