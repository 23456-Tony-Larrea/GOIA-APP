import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, Modal, StyleSheet, Switch, Alert,TextInput,Button } from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import axios from '../../axios/axios';
import { IRole } from '../Interface/IRole';
import { ALERT_TYPE, Dialog, AlertNotificationRoot } from 'react-native-alert-notification';
import { IPermission } from '../Interface/IPermission';
import Toast from 'react-native-toast-message';


const RoleView = ({}) => {
  const [roles, setRoles] = useState<IRole[]>([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [editedPermissions, setEditedPermissions] = useState(null);
  const [selectedName, setSelectedName] = useState('');
  const [idRole,setIdRole]=useState(Number);
  const [permissionsModalTitle, setPermissionsModalTitle] = useState('');
  const [permissionsModalVisible, setPermissionsModalVisible] = useState(false);
  const [permissions, setPermissions] = useState<IPermission[]>([]);
  const [rolePermissionId,setRolePermissionId]=useState(Number)
  let [roleIdANDPermission,setRoleANDIdPermission]=useState(Number)


   
  useEffect(() => {
    getRoles()
    getPermissionRoleById(rolePermissionId)
  }, []);
  const getRoles=async()=>{
    try {
        const response = await axios.get('/roles'); 
         setRoles(response.data);
        } catch (error) {
        console.error('Error al obtener los roles:', error);
      }
}
const clearData= async ()=>{
  setSelectedName('')
  setIdRole(0)
}
const createRole = async () => {
    
    try {
      if(idRole){
        const response = await axios.put(`/roles/${idRole}`, { name: selectedName });
        const createdRole = response.data;
        setRoles(prevRoles => [...prevRoles, createdRole]);
        setModalVisible(false);
        Dialog.show({
          type: ALERT_TYPE.SUCCESS,
          title: 'Rol creado',
          textBody: 'El rol ha sido actualizado exitosamente.',
          button: 'Cerrar',
        });
        getRoles()
        setEditedPermissions(null);
        }else{
      const response = await axios.post('/roles', { name: selectedName });
      const createdRole = response.data;
      setRoles(prevRoles => [...prevRoles, createdRole]);
      setModalVisible(false);
      Dialog.show({
        type: ALERT_TYPE.SUCCESS,
        title: 'Rol creado',
        textBody: 'El rol ha sido creado exitosamente.',
        button: 'Cerrar',
      });
      getRoles()
      setEditedPermissions(null);
      clearData()
    }
    } catch (error) {
      console.error('Error al crear el rol:', error);
      Dialog.show({
        type: ALERT_TYPE.DANGER,
        title: 'Error',
        textBody: 'Se produjo un error al crear el rol.',
        button: 'Cerrar',
      });
    }
  }
  
  const deleteRole=async (id:number) => {
    try {
      const response = await axios.delete(`/roles/${id}`);
      const deletedRole = response.data;
      setRoles(prevRoles => prevRoles.filter(role => role.id!== deletedRole.id));
      Dialog.show({
        type: ALERT_TYPE.SUCCESS,
        title: 'Rol eliminado',
        textBody: 'El rol ha sido eliminado exitosamente.',
        button: 'Cerrar',
      });
      getRoles()
    } catch (error) {
      console.error('Error al eliminar el rol:', error);
      Dialog.show({
        type: ALERT_TYPE.DANGER,
        title: 'Error',
        textBody: 'Se produjo un error al eliminar el rol.',
        button: 'Cerrar',
      });
    }
  }
  const getPermissionRoleById=async(id:number)=>{
    try{
      const response = await axios.get(`/role_permissions/${id}`);
      const permission = response.data.data;
      console.log('Permissions:', permission);
       setPermissions(permission);
   }
    catch(e){
      console.log(e)
    }
}
  const updatePermissionState = async (permissionId:number, newState:boolean,roleId:number) => {
   
     try {
      const response = await axios.put(`/roles/${roleId}/permissions/${permissionId}/state`, { newState });
      const updatedPermissions = permissions.map((permission) => {
        if (permission.id === permissionId) {
          return { ...permission, state: newState };
        }
        return permission;
      });
      console.log('Updated Permissions:', updatedPermissions); // Agrega este console.log para verificar los permisos actualizados
      setPermissions(updatedPermissions);
      Toast.show({
        type:'success',
        text1: 'Permiso',
        text2: "El permiso se ha actualizado",
      });
    } catch (error) {
      console.log(error);
    } 
  };
  return (
    <AlertNotificationRoot>
    <View style={styles.container}>
      <View style={styles.rolesContainer}>
        {roles.map((role, index) => {
          if (role.name !== 'superAdministrador') { 
            return (
              <TouchableOpacity key={index} style={styles.roleItem} onPress={() => {
                setPermissionsModalTitle(`Permisos de ${role.name}`);
                setPermissionsModalVisible(true);
                getPermissionRoleById(role.id);
                setRoleANDIdPermission(role.id)
              }}>
                <Text style={styles.roleName}>{role.name}</Text>
                <TouchableOpacity style={styles.editButton} onPress={() => {
                  setIdRole(role.id);
                  setModalVisible(true);
                  setSelectedName(role.name);
                }}>
                  <Icon name="pencil" size={16} color="#FFF" />
                </TouchableOpacity>
                <TouchableOpacity style={styles.deleteButton} onPress={() => deleteRole(role.id)}>
                  <Icon name="trash" size={16} color="#FFF" />
                </TouchableOpacity>
              </TouchableOpacity>
            );
           } else {
            return null; // Omite el renderizado del rol de superAdministrador
          } 
        })}
      </View>
      <TouchableOpacity style={styles.createButton} onPress={() => { setModalVisible(true); clearData(); }}>
        <Icon name="user" size={20} style={styles.roleIcon} />
        <Text style={styles.createButtonText}>Crear Rol</Text>
      </TouchableOpacity>
      {modalVisible && (
        <Modal visible={modalVisible} transparent animationType="fade">
          <View style={styles.modalContainer}>
            <View style={styles.modalContent}>
              <Text style={styles.modalTitle}>Rol</Text>
              <TextInput
                style={styles.roleNameInput}
                placeholder="Nombre del Rol"
                value={selectedName}
                onChangeText={setSelectedName}
              />
              <Button title="Guardar" onPress={createRole} />
              <TouchableOpacity style={styles.closeButton} onPress={() => { setModalVisible(false); }}>
                <Text style={styles.closeButtonText}>Cerrar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      )}
      {permissionsModalVisible && (
        <Modal visible={permissionsModalVisible} transparent animationType="fade">
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>{permissionsModalTitle}</Text>
            <View style={styles.permissionList}>
              {permissions.map((permission, index) => (
                <View key={index} style={styles.permissionItem}>
                  <Text style={styles.permissionText}>{permission.name}</Text>
                  <Switch
      value={permission.state}
  onValueChange={async (value) => {
    console.log('Switch Value:', value);
    await updatePermissionState(permission.id, value, roleIdANDPermission);
  }}
/>

                </View>
              ))}
            </View>
            <TouchableOpacity style={styles.closeButton} onPress={() => {setPermissionsModalVisible(false)
              getPermissionRoleById(rolePermissionId)
            }}>
              <Text style={styles.closeButtonText}
           >Cerrar</Text>
            </TouchableOpacity>
          </View>
        </Modal>
      )}
    </View>
  </AlertNotificationRoot>
  
);
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
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
  editButton: {
    backgroundColor: '#007AFF',
    padding: 5,
    borderRadius: 5,
    marginLeft: 10,
  },
  deleteButton: {
    backgroundColor: '#FF3B30',
    padding: 5,
    borderRadius: 5,
    marginLeft: 10,
  },
  editButtonText: {
    color: '#FFF',
    fontWeight: 'bold',
  },
  permissionsContainer: {
    marginTop: 20,
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    backgroundColor: '#FFF',
    padding: 20,
    borderRadius: 5,
    width: '80%',
    flex: 1,
    marginTop: 50, // Ajusta el margen superior según sea necesario
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  permissionList: {
    marginTop: 10,
  },
  permissionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  permissionText: {
    flex: 1,
    fontSize: 16,
  },
  saveButton: {
    backgroundColor: '#007AFF',
    padding: 10,
    borderRadius: 5,
    marginTop: 20,
  },
  saveButtonText: {
    color: '#FFF',
    fontWeight: 'bold',
    textAlign: 'center',
  },
  closeButton: {
    backgroundColor: '#CCC',
    padding: 10,
    borderRadius: 5,
    marginTop: 10,
  },
  closeButtonText: {
    color: '#FFF',
    fontWeight: 'bold',
    textAlign: 'center',
  },
  createButton: {
    backgroundColor: '#007AFF',
    padding: 10,
    borderRadius: 5,
    marginTop: 10,
  },
  createButtonText: {
    color: '#FFF',
    fontWeight: 'bold',
    textAlign: 'center',
  },
  roleNameInput: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 10,
    paddingLeft: 5,
  },
  roleIcon: {
    marginRight: 10,
  },
});

export default RoleView;
