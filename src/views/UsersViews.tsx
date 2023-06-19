import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Modal, TextInput } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { IUser } from '../Interface/IUser';
import { IRole } from '../Interface/IRole';
import DropDownPicker from 'react-native-dropdown-picker';
import { ALERT_TYPE, AlertNotificationRoot, Toast } from 'react-native-alert-notification';

const UsersView = () => {
  const [users, setUsers] = useState<IUser[]>([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [username, setUsername] = useState('');
  const [role, setRole] = useState<IRole[]>([]);
  const [idUser, setIdUser] = useState<number | null>(null);
  const [open, setOpen] = useState(false);
  const [value, setValue] = useState<number | null>(null);

  const getUsers = async () => {
    try {
      const response = await axios.get('/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Error al obtener los usuarios:', error);
    }
  };

const clearData=()=>{
setValue(0)
setUsername('')
} 

  const getRoles = async () => {
    try {
      const response = await axios.get('/roles');
      setRole(response.data);
    } catch (error) {
      console.error('Error al obtener los roles:', error);
    }
  };

  useEffect(() => {
    getUsers();
    getRoles();
  }, []);

  const addUser = async () => {
    try {
      if (idUser) {
        await axios.put(`/users/${idUser}`, {
          username: username,
          role_id: value,  
          });

        Toast.show({
          title: 'Usuario Actualizado',
          textBody: 'El usuario ha sido actualizado exitosamente.',
          type: ALERT_TYPE.SUCCESS,
        });
        getRoles()

      } else {
        await axios.post('/register', {
          username: username,
          role_id: value,
          password:"123456"
        });

        Toast.show({
          title: 'Usuario Agregado',
          textBody: 'El usuario ha sido agregado exitosamente.',
          type: ALERT_TYPE.SUCCESS,
        });
        getRoles()
        clearData()
      }

      setModalVisible(false);
      getUsers();
    } catch (error) {
      console.error('Error al agregar o actualizar el usuario:', error);
    }
  };

  const changeState = async (id: number) => {
    try {
      await axios.put(`/users/activate/${id}`);

      Toast.show({
        title: 'Usuario Desactivado',
        textBody: 'El usuario ha sido desactivado.',
        type: ALERT_TYPE.DANGER,
      });
      getUsers();
    } catch (error) {
      console.error('Error al cambiar el estado del usuario:', error);
    }
  };

  const renderList = () => {
    return (
      <AlertNotificationRoot>
        <View style={styles.rolesContainer}>
          {users.map((user, index) => (
            <View key={index} style={styles.roleItem}>
              <Text style={styles.roleName}>Usuario: {user.username}</Text>
              <Text style={styles.roleName}>Rol: {user.role_id ? user.role.name : 'Sin ningún rol'}</Text>
              <TouchableOpacity
                style={styles.editButton}
                onPress={() => {
                  setIdUser(user.id);
                  setUsername(user.username);
                  setValue(user.role_id);
                  setModalVisible(true);
                }}
              >
                <Icon name="edit" size={20} color="blue" />
              </TouchableOpacity>
              <TouchableOpacity style={styles.deleteButton} onPress={() => changeState(user.id)}>
                <Icon name="trash" size={20} color="red" />
              </TouchableOpacity>
            </View>
          ))}
        </View>
      </AlertNotificationRoot>
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
      <AddButton onPress={() =>{ setModalVisible(true)
      clearData()
      }} />

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Usuario</Text>
            <TextInput
              style={styles.modalInput}
              placeholder="Nombre de usuario"
              value={username}
              onChangeText={setUsername}
            />
            <DropDownPicker
              open={open}
              value={value}
              items={role.map((role: IRole) => ({ label: role.name, value: role.id }))}
              setOpen={setOpen}
              setValue={setValue}
              setItems={setRole}
            />

            <TouchableOpacity style={styles.modalButton} onPress={()=>addUser()}>
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
    padding: 16,
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
  rolesContainer: {
    flex: 1,
  },
  roleItem: {
    marginBottom: 10,
    backgroundColor: '#EEE',
    padding: 10,
    borderRadius: 5,
    flexDirection: 'row',
    alignItems: 'center',
  },
  roleName: {
    flex: 1,
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  editButton: {
    marginRight: 8,
  },
  deleteButton: {},
});

export default UsersView;
