import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image, Modal } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import { ICars } from '../Interface/ICars';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Camera } from 'expo-camera';
import {IPhoto} from '../Interface/IPhoto'
import axiosInstance from '../../axios/axios2';
import { Toast, ALERT_TYPE, AlertNotificationRoot } from 'react-native-alert-notification';




const IdentificationCard = () => {
  const [plateNumber, setPlateNumber] = useState('');
  const [vehicleInfo, setVehicleInfo] = useState<ICars[]>([]);
  const [searched, setSearched] = useState(false);
  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null);
  const [modalVisiblePicture, setModalVisiblePicture] = useState(false);
/*   const [capturedPhoto, setCapturedPhoto] = useState<IPhoto | string>('');
 */  const [idPicture, setIdPicture]= useState(Number);
  const cameraRef = useRef<any>(null); // Asegúrate de que el tipo sea correcto
  const [capturedImageURL, setCapturedImageURL] = useState('');
  const [captureCodeVehi, setCaptureCodeVehi] = useState('');


 
 
  useEffect(() => {
    (async () => {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasCameraPermission(status === 'granted');
    })();

    }, []);

  const clearData=()=>{
    setVehicleInfo([])
    setPlateNumber('')
    setSearched(false)
  }
  const clearStorage =()=>{
      AsyncStorage.removeItem('codeRTV')
  }

 
  const searchVehicle = async () => {
   
    try {
      const response = await axiosInstance.post('/GetCodVehiculo',{
            "placa":`${plateNumber}`
      });
      setSearched(true);
      if ( response.data[0] && response.data[0].vehi_codigo) {
      setCaptureCodeVehi(response.data[0].vehi_codigo)
      getInformationCar(response.data[0].vehi_codigo)
      getRegisterRTV(response.data[0].vehi_codigo)
      } else{
        Toast.show({
          title: 'Codigo',
          textBody: 'No tienes codigo.',
          type: ALERT_TYPE.DANGER,
        })
     
      }
    } catch (error) {
      console.error(error);
     
    }
  };

  const getInformationCar = async (captureCodeVehi:number) => {
    try {
      setSearched(true);
      const response = await axiosInstance.post('/GetDatoVehiculo',{
            "vehi_codigo":`${captureCodeVehi}`
      });
      setVehicleInfo(response.data);
    } catch (error) {
      console.error(error);
    }
  };
  const saveCodeRtvToStorage = async (codeRtv: number) => {
    try {
      const codeRtvString = codeRtv.toString(); // Convertir el número a una cadena de texto
      await AsyncStorage.setItem('codeRTV', codeRtvString);
      console.log('Código RTV guardado correctamente en AsyncStorage.');
    } catch (error) {
      console.error('Error al guardar el código RTV en AsyncStorage:', error);
    }
  };
   const getRegisterRTV = async (captureCodeVehi:number) => {
    try {
      setSearched(true);
      const response = await axiosInstance.post('/ObtenerRegistroRTV',{
        "vehi_codigo":`${captureCodeVehi}`
        })
        if (response.data.length === 0) {
          Toast.show({
            title: 'RTV',
            textBody: 'No se tienen registros.',
            type: ALERT_TYPE.DANGER,
          });
        } else {
          Toast.show({
            title: 'RTV',
            textBody: 'Si tienes registros del RTV.',
            type: ALERT_TYPE.SUCCESS,
          });
        
          // Llamar a la función para guardar el código RTV en AsyncStorage
          (async () => {
            const codeRtv = response.data[0].codigo;
            await saveCodeRtvToStorage(codeRtv);
          })();
          
        }
    } catch (error) {
      console.error(error);
  
      Toast.show({
        title: 'Error',
        textBody: 'Ha ocurrido un error al obtener los datos.',
        type: ALERT_TYPE.DANGER,
      });
    }
  } 
  
  
    const takePhoto = async (id: number) => {
    setModalVisiblePicture(true);
    setIdPicture(id)
  };

  if (hasCameraPermission === false) {
    return <Text>No tienes acceso a la cámara</Text>;
  }
  
  const takePicture = async (id: number) => {
    setModalVisiblePicture(false)
   /*  if (cameraRef.current) {
      const photo = await cameraRef.current.takePictureAsync();
      const { uri } = photo; 
      console.log("URI de la foto:", uri); 
  
      const fileUri = FileSystem.cacheDirectory + 'photo.jpg';
      console.log("Ruta absoluta guardada:", fileUri);
  
      // Mueve la foto a la nueva ubicación
      await FileSystem.moveAsync({
        from: uri,
        to: fileUri,
      });
  
      const formData = new FormData();
      formData.append('evidence', {
        uri: fileUri,
        name: 'photo.jpg',
        type: 'image/jpeg',
      }as any);
      console.log("Datos del formulario",formData );

  
       try {
        const response = await axios.post(`/takePhoto/${id}/evidence`, formData,{
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });
        console.log(response.data);
      }
      catch (error) {
        console.error(error);
      } 
    } */
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
                    <Text style={styles.value}>{vehicle.cliente}</Text>
                  </View>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>Modelo:</Text>
                    <Text style={styles.value}>{vehicle.modelo}</Text>
                  </View>
                  <View style={styles.labelRow}>
                    <Text style={styles.label}>No. Cédula:</Text>
                    <Text style={styles.value}>{vehicle.cedula}</Text>
                  </View>
                  </View>
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
        {capturedImageURL !== '' && (
    <Image source={{ uri: capturedImageURL }} style={styles.capturedImage} />
  )}
      </Modal>

      <View style={styles.emptyDiv}>
      <AlertNotificationRoot>
</AlertNotificationRoot>     
      </View>
      
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
    backgroundColor: '#FFF',
    borderRadius: 5,
    padding: 20,
    marginBottom: 10,
    width: '100%',
  },
  capturedImage: {
    width: 200,
    height: 200,
    alignSelf: 'center',
    marginTop: 10,
  },
});

export default IdentificationCard;
