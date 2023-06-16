import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image, Modal } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { ICars } from '../Interface/ICars';
import jwtDecode from 'jwt-decode';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Camera } from 'expo-camera';
import { IDecodedToken } from '../Interface/IDecodedToken';
import {IPhoto} from '../Interface/IPhoto'

const IdentificationCard = () => {
  const [idRole, setIdRole] = useState(Number);
  const [plateNumber, setPlateNumber] = useState('');
  const [vehicleInfo, setVehicleInfo] = useState<ICars[]>([]);
  const [searched, setSearched] = useState(false);
  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null);
  const [seeSearch, setSeeSearch] = useState(false);
  const [modalVisiblePicture, setModalVisiblePicture] = useState(false);
  const [capturedPhoto, setCapturedPhoto] = useState<IPhoto | string>('');
  const [idPicture, setIdPicture]= useState(Number);
  const cameraRef = useRef<any>(null); // Asegúrate de que el tipo sea correcto

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
      const viewSearch = permissions.find((permission: any) => permission.name === 'insertar usuarios');
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
    getPermissions();
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
    setModalVisiblePicture(true);
    setIdPicture(id)
  };

  if (hasCameraPermission === false) {
    return <Text>No tienes acceso a la cámara</Text>;
  }
  
  const takePicture = async (id: number) => {
    if (cameraRef.current) {
      const photo: IPhoto = await cameraRef.current.takePictureAsync();
      setCapturedPhoto(photo.uri);
      console.log('URI de la foto:', photo.uri);
  
      try {
        const response = await fetch(photo.uri);
        const blob = await response.blob();
        console.log('Blob de la foto:', blob);
  
        const file = new File([blob], 'photo.jpg', { type: 'image/jpeg' });
        console.log("eror o no",file)
  
      /*   const formData = new FormData();
        formData.append('document', file);
        console.log('FormData:', formData);
  
        const axiosConfig = {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        };
  
        const axiosResponse = await axios.post(
          `/takePhoto/${id}/evidence`,
          formData,
          axiosConfig
        );
  
        console.log('La foto se ha enviado correctamente');
        // Realizar cualquier acción adicional con la respuesta del servidor si es necesario
       */} catch (error) {
        console.log('Error al enviar la foto:', error);
      }
    }
  };

  
  return (
    <View style={styles.container}>
      <View style={styles.card}>
        <View>
          <Text style={styles.cardTitle}>Identificación</Text>
        </View>
        <View>
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
          <TouchableOpacity style={styles.searchButton} onPress={searchVehicle}>
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

      <Modal visible={modalVisiblePicture} transparent>
        <Camera style={styles.camera} ref={cameraRef} />
        <TouchableOpacity style={styles.captureButton} onPress={() => {/* setModalVisiblePicture(false) */
          takePicture(idPicture)
        }}>
          <Text style={styles.captureButtonText}>Tomar foto</Text>
        </TouchableOpacity>
      </Modal>

      <View style={styles.emptyDiv}></View>
    </View>
  );
};

const styles = StyleSheet.create({
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
  infoContainer: {
    marginTop: 10,
    marginBottom: 10,
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
  captureButton: {
    position: 'absolute',
    bottom: 20,
    left: '50%',
    transform: [{ translateX: -50 }],
    backgroundColor: '#FF3B30',
    borderRadius: 3,
    padding: 10,
  },
  captureButtonText: {
    color: '#FFF',
  },
  camera: {
    flex: 1,
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  emptyDiv: {
    marginBottom: 100,
  },
});

export default IdentificationCard;
