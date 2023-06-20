import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Modal, Button } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ALERT_TYPE, Toast } from 'react-native-alert-notification';
import { NavigationProp } from '@react-navigation/native';

const ExitScreen =  ({ navigation }: { navigation: NavigationProp<any> }) => {
  const [modalVisible, setModalVisible] = useState(false);

  const handleLogout = async () => {
    try {
      // Eliminar el token del AsyncStorage
      await AsyncStorage.removeItem('token');
      // Mostrar mensaje de éxito
      Toast.show({
        title: 'Cerrar sesión',
        textBody: 'Has cerrado sesión exitosamente.',
        type: ALERT_TYPE.SUCCESS,
      });

      // Redireccionar a la pantalla de inicio de sesión
      navigation.navigate('Ingreso');
    } catch (error) {
      console.error(error);
      Toast.show({
        title: 'Error',
        textBody: 'Ha ocurrido un error al cerrar sesión.',
        type: ALERT_TYPE.DANGER,
      });
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>¿Estás seguro de cerrar sesión?</Text>
      <TouchableOpacity onPress={() => setModalVisible(true)}>
        <Text style={styles.logoutButton}>Cerrar sesión</Text>
      </TouchableOpacity>

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Confirmación de cierre de sesión</Text>
            <Text style={styles.modalText}>¿Estás seguro de que deseas cerrar sesión?</Text>
            <View style={styles.modalButtons}>
              <Button title="Cancelar" onPress={() => setModalVisible(false)} />
              <Button title="Aceptar" onPress={handleLogout} />
            </View>
          </View>
        </View>
      </Modal>
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
    marginBottom: 20,
  },
  logoutButton: {
    fontSize: 18,
    color: 'blue',
    textDecorationLine: 'underline',
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    backgroundColor: 'white',
    padding: 20,
    borderRadius: 5,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  modalText: {
    fontSize: 16,
    marginBottom: 20,
  },
  modalButtons: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
});

export default ExitScreen;
