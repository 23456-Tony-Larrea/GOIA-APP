import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Modal, TextInput } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { IUser } from '../Interface/IUser';
import { IRole } from '../Interface/IRole';
import DropDownPicker, { ItemType } from 'react-native-dropdown-picker';
import { ALERT_TYPE, AlertNotificationRoot ,Toast} from 'react-native-alert-notification';


const UsersView = () => {
  const [users, setUsers] = useState<IUser[]>([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [username, setUsername] = useState('');
  const [role, setRole] = useState<IRole[]>([]);
  

  const getUsers = async () => {
    try {
      const response = await axios.get('/users');
      setUsers(response.data);
      console.log("re",response.data)
    } catch (error) {
      console.error('Error al obtener los usuarios:', error);
    }
  };

  const [open, setOpen] = useState(false);
  const [value, setValue] = useState(null);
  const items: ItemType<number>[] = role.map((role: IRole) => ({
    label: role.name,
    value: role.id
  }));

  const getRoles = async ()=>{
    try{
    const response = await axios.get('/roles')
        setRole(response.data)
        
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
        const response = await axios.post('/users',{
            username: username,
            role_id:value
        });
        setUsers([...users, response.data]);
        setModalVisible(false);
        getUsers()
    } catch (error) {
        console.error('Error al obtener los usuarios:', error);
    } 
    
  };

const changeState = async (id:number) => {
    try {
        const response = await axios.put(`/users/activate/${id}`
        );
        setUsers(users.map((user: IUser) => (user.id === id? response.data : user)));
        //Using toast 
        Toast.show({
            title: 'Usuario desactivado',
            textBody:'Se desactivo el usuario',
            type: ALERT_TYPE.DANGER
        });
}
    catch (error) {
        console.error('Error al obtener los usuarios:', error);
    }
}

  const renderList = () => {
    return (
        <AlertNotificationRoot>
     <View style={styles.rolesContainer}>
     {users.map((user, index) => (
        <View key={index} style={styles.roleItem}>
          <Text>Nombre del usuario:{user.username}</Text>
          <Text>Nombre del Rol: {user.role_id ?user.role_id.name  : "Sin ningún rol"}</Text>
          <TouchableOpacity>
            <Icon name="edit" size={20} color="blue" />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => changeState(user.id)}>
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
      <AddButton onPress={() => setModalVisible(true)} />

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
      items={items}
      setOpen={setOpen}
      setValue={setValue}
      setItems={setRole}
      
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
  },
});

export default UsersView;
