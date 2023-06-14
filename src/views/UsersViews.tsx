import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Modal, TextInput } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { IUser } from '../Interface/IUser';
import { IRole } from '../Interface/IRole';

const UsersView = () => {
  const [users, setUsers] = useState<IUser[]>([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [username, setUsername] = useState('');
  const [role, setRole] = useState<IRole[]>([]); // Movido dentro del componente
  const [selectedValue, setSelectedValue] = useState(''); // Movido dentro del componente


  const getUsers = async () => {
    try {
      const response = await axios.get('/users');
      setUsers(response.data);
      console.log(response.data);
    } catch (error) {
      console.error('Error al obtener los usuarios:', error);
    }
  };

  const getRoles = async ()=>{
    try{
    const response = await axios.get('/roles')
        setRole(response.data)
        console.log(response.data)
    } catch (error) {
        console.error('Error al obtener los usuarios:', error);    
  }

  }

  useEffect(() => {
    getUsers();
    getRoles();
  }, []);

  const addUser = async () => {
    try {
      await axios.post('/users', { username });
      setModalVisible(false);
      setUsername('');
      getUsers();
    } catch (error) {
      console.error('Error al insertar el usuario:', error);
    }
  };

  const renderList = () => {
    return (
      <FlatList
        data={users}
        keyExtractor={(user) => user.id.toString()}
        renderItem={({ item }) => (
          <View style={styles.listItem}>
            <Text style={styles.listItemText}>Nombre: {item.username}</Text>
            <Text style={styles.listItemText}>Rol: {item.role_id || 'Ningún rol asignado'}</Text>
          </View>
        )}
      />
    );
  };

  const AddButton = ({ onPress }: { onPress: () => void }) => (
    <TouchableOpacity style={styles.addButton} onPress={onPress}>
      <Icon name="plus" size={15} color="white" />
      <Text style={styles.buttonText}>Agregar Usuario</Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <AddButton onPress={() => setModalVisible(true)} />

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Agregar Usuario</Text>
            <TextInput
              style={styles.modalInput}
              placeholder="Nombre de usuario"
              value={username}
              onChangeText={setUsername}
            />
        
            <TouchableOpacity style={styles.modalButton} onPress={addUser}>
              <Text style={styles.buttonText}>Agregar</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.modalButton} onPress={() => setModalVisible(false)}>
              <Text style={styles.buttonText}>Cancelar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>

      {renderList()}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  tableContainer: {
    flex: 1,
    backgroundColor: '#fff',
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#ddd',
    padding: 8,
    marginBottom: 16,
  },
  head: {
    height: 40,
    backgroundColor: '#f1f8ff',
  },
  headText: {
    textAlign: 'center',
    fontWeight: 'bold',
  },
  rowText: {
    textAlign: 'center',
  },
  listItem: {
    backgroundColor: '#f9f9f9',
    borderRadius: 4,
    padding: 8,
    marginBottom: 8,
  },
  listItemText: {
    fontSize: 16,
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    backgroundColor: '#fff',
    borderRadius: 4,
    padding: 16,
    alignItems: 'center',
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  modalInput: {
    width: '100%',
    height: 40,
    borderColor: '#ccc',
    borderWidth: 1,
    borderRadius: 4,
    padding: 8,
    marginBottom: 16,
  },
  modalButton: {
    backgroundColor: '#2196F3',
    borderRadius: 4,
    padding: 8,
    marginBottom: 8,
  },
  addButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#2196F3',
    borderRadius: 4,
    padding: 8,
    marginBottom: 16,
  },
  buttonText: {
    color: 'white',
    marginLeft: 8,
  },
});

export default UsersView;
