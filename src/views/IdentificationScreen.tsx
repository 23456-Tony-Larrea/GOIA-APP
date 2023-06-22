import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image, Modal, Button,ScrollView } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import { ICars } from '../Interface/ICars';
import { Camera } from 'expo-camera';
import axiosInstance from '../../axios/axios2';
import { Toast, ALERT_TYPE, AlertNotificationRoot } from 'react-native-alert-notification';
import { IListProcedure,IDefecto } from '../Interface/IListProcedure';
import { RadioButton } from 'react-native-paper';


const IdentificationCard = () => {
  const [plateNumber, setPlateNumber] = useState('');
  const [vehicleInfo, setVehicleInfo] = useState<ICars[]>([]);
  const [searched, setSearched] = useState(false);
  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null);
  const [captureCodeVehi, setCaptureCodeVehi] = useState('');
  const [codeRTV, setCodeRTV] = useState<number | null>(null);
  const [listProcedure, setListProcedure] = useState<IListProcedure[]>([]);
  const [listDefects, setListDefects] = useState<IDefecto[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [modalVisible, setModalVisible] = useState(false);
  const [modalVisible2,setModalVisible2]=useState(false);
 const [modalAbreviature,setModalAbreviature]=useState(false);
  const [selectedCategory2, setSelectedCategory2] = useState<string | null>(null);
  const [procedureModal , setProcedureModal]=useState<string | null>(null);
  const [selectedDescription, setSelectedDescription] = useState('');


  useEffect(() => {
    (async () => {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasCameraPermission(status === 'granted');
    })();
  }, []);

  const clearData = () => {
    setVehicleInfo([]);
    setPlateNumber('');
    setSearched(false);
  };

  const searchVehicle = async () => {
    try {
      const response = await axiosInstance.post('/GetCodVehiculo', {
        placa: plateNumber
      });
      setSearched(true);
      if (response.data[0] && response.data[0].vehi_codigo) {
        setCaptureCodeVehi(response.data[0].vehi_codigo);
        getInformationCar(response.data[0].vehi_codigo);
        getRegisterRTV(response.data[0].vehi_codigo);
      } else {
        Toast.show({
          title: 'Codigo',
          textBody: 'No tienes codigo.',
          type: ALERT_TYPE.DANGER,
        });
      }
    } catch (error) {
      console.error(error);
    }
  };

  const handleDescriptionSelection = (description:any) => {
    setSelectedDescription(description);
    setModalAbreviature(true);
  }

  const getInformationCar = async (captureCodeVehi: number) => {
    try {
      setSearched(true);
      const response = await axiosInstance.post('/GetDatoVehiculo', {
        vehi_codigo: captureCodeVehi
      });
      setVehicleInfo(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  const getRegisterRTV = async (captureCodeVehi: number) => {
    try {
      setSearched(true);
      const response = await axiosInstance.post('/ObtenerRegistroRTV', {
        vehi_codigo: captureCodeVehi
      });
      console.log(response.data);
      if (response.data[0] && response.data[0].codigo) {
        setCodeRTV(response.data[0].codigo);
        Toast.show({
          title: 'Encontrado',
          textBody: 'Tienes un codigo.',
          type: ALERT_TYPE.SUCCESS,
        });
      } else {
        Toast.show({
          title: 'Codigo',
          textBody: 'No tienes codigo.',
          type: ALERT_TYPE.DANGER,
        });
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

  const lisProcedure = async () => {
    try {
      if (codeRTV) {
        const response = await axiosInstance.post('/listarProcedimientos', {
          tipo: 1,
          estado: 1
        });
        console.log(response.data);
        setListProcedure(response.data);
        setListDefects(response.data)
        setSearched(true);
      } else {
        Toast.show({
          title: 'Codigo',
          textBody: 'No tienes generado el codigo de revision vehicular.',
          type: ALERT_TYPE.DANGER,
        });
        clearData()
      }
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    lisProcedure();
  }, []);


  if (hasCameraPermission === false) {
    return <Text>No tienes acceso a la cámara</Text>;
  }

  return (
    <AlertNotificationRoot>
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

<View style={styles.card}>
            <Text style={styles.title}>Items:</Text>
            {listProcedure.map((item, index) => (
  <View key={item.codigo} style={[styles.procedureContainer, index !== 0 && { marginTop: 40 }]}>
    <TouchableOpacity
      onPress={() => {
        if (index === 0) {
          // Acción para el primer elemento
          setSelectedCategory(item.categoria_abreviatura);
          setProcedureModal(item.procedimiento);
          setModalVisible(true);
        } else if (index===1) {
          setModalVisible2(true);
          setSelectedCategory(item.categoria_abreviatura);
          setProcedureModal(item.procedimiento);
        }
      }}
    >
      <Text style={styles.subtitle}>{item.categoria_abreviatura}</Text>
      <Text style={styles.procedure}>{item.procedimiento}</Text>
    </TouchableOpacity>
  </View>
))}
        
 
        {modalVisible && (
  <Modal visible={modalVisible} onRequestClose={() => setModalVisible(false)}>
    <ScrollView>
      <View style={styles.modalContent}>
        <Text style={styles.modalTitle}>Procedimiento seleccionado:</Text>
        <Text style={styles.modalText}>{procedureModal}</Text>
        <Text style={styles.modalTitle}>Categoría:</Text>
        <Text style={styles.modalText}>{selectedCategory}</Text>
        <Text style={styles.modalTitle}>Detalles del procedimiento:</Text>
        <View style={styles.card}>
          {listProcedure[0].defectos.map((defecto) => (
            <View key={defecto.codigo} style={{ marginBottom: 20 }}>
               <TouchableOpacity
                key={defecto.codigo}
                onPress={() =>{ 
                handleDescriptionSelection(defecto.descripcion)
                setModalAbreviature(true)  
              }
              }
              >
              <Text style={styles.cardAbreviatura}>{defecto.abreviatura}</Text>
              <Text style={styles.cardDescripcion}>{defecto.descripcion}</Text>
              </TouchableOpacity>
            </View>
          ))}
        </View>
      
        <Button title="Cerrar" onPress={() => setModalVisible(false)} />
      </View>
    </ScrollView>
  </Modal>
)}
{modalAbreviature && (
  <Modal visible={modalAbreviature} onRequestClose={() => setModalAbreviature(false)}>
    <View style={styles.modalContainerButtons}>
      <Text>Calificar {selectedDescription}</Text>
      <View style={styles.radioButtonContainer}>
        <RadioButton
          value="first"
          status={selectedCategory === 'first' ? 'checked' : 'unchecked'}
        />
        <RadioButton
          value="second"
          status={selectedCategory === 'second' ? 'checked' : 'unchecked'}
        />
        <RadioButton
          value="third"
          status={selectedCategory === 'third' ? 'checked' : 'unchecked'}
        />
        <RadioButton
          value="fourth"
          status={selectedCategory === 'fourth' ? 'checked' : 'unchecked'}
        />
      </View>
      <View style={styles.modalFooter}>
        <Button title="Cerrar" onPress={() => setModalAbreviature(false)} />
      </View>
    </View>
  </Modal>
)}

{modalVisible2 && (
  <Modal visible={modalVisible2} onRequestClose={() => setModalVisible2(false)}>
    <ScrollView>
      <View style={styles.modalContent}>
        <Text style={styles.modalTitle}>Procedimiento seleccionado:</Text>
        <Text style={styles.modalText}>{procedureModal}</Text>
        <Text style={styles.modalTitle}>Categoría:</Text>
        <Text style={styles.modalText}>{selectedCategory}</Text>
        <Text style={styles.modalTitle}>Lista de defectos:</Text>
        <View style={styles.card}>
          {listProcedure[1].defectos.map((defecto) => (
            <View key={defecto.codigo} style={{ marginBottom: 20 }}>
              <Text style={styles.cardAbreviatura}>{defecto.abreviatura}</Text>
              <Text style={styles.cardDescripcion}>{defecto.descripcion}</Text>
            </View>
          ))}
        </View>
        <Button title="Cerrar" onPress={() => setModalVisible2(false)} />
      </View>
    </ScrollView>
  </Modal>
)}
            </View>
          </>
        )}
      </View>
    </AlertNotificationRoot>
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
  itemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  title: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  subtitle: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  code: {
    fontSize: 14,
    color: 'gray',
  },
  subtitleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  checkbox: {
    // Estilos para el checkbox (puedes ajustarlos según tus necesidades)
  },
  procedure: {
    // Estilos para el procedimiento (puedes ajustarlos según tus necesidades)
  },
  modalContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#FFF',
  },
  modalText: {
    fontSize: 12,
    marginBottom: 20,
    color: '#FFF',
  },
  procedureContainer: {
    marginBottom: 10,
  },
  cardAbreviatura: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  cardDescripcion: {
    fontSize: 14,
    marginBottom: 5,
  },
  cardNumero: {
    fontSize: 14,
    color: 'gray',
    marginBottom: 20
  },
  defectoContainer:{
    fontSize: 8,
    fontWeight: 'bold',
  },
  radioButtonsContainer: {
    marginTop: 20,
    paddingHorizontal: 20,
  },  modalFooter: {
    justifyContent: 'flex-end',
    alignItems: 'center',
    paddingVertical: 10,
    paddingHorizontal: 20,
    backgroundColor: 'lightgray',
  },
  radioButtonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  modalContainerButtons: {
    width: '50%',
    height: '50%',
    alignSelf: 'center',
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 20,
  },

});

export default IdentificationCard;
