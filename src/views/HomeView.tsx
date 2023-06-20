import React, { useState, useEffect } from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/FontAwesome';
import IdentificationScreen from '../views/IdentificationScreen';
import VisualInspectionScreen from './VisualInspectionScreen';
import ClearancesScreen from './ClearancesScreen';
import WheelsScreen from './WheelsScreen';
import RolePermissionScreen from './RolePermissionScreen';
import ExitScreen from './ExitScreen';
import UsersView from './UsersViews';
import AsyncStorage from '@react-native-async-storage/async-storage';
import jwtDecode from 'jwt-decode';
import axiosInstance from '../../axios/axios2';
import { IDecodedToken } from '../Interface/IDecodedToken';
import axios from '../../axios/axios';
import { IPermission } from '../Interface/IPermission';

const Tab = createBottomTabNavigator();

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


const App = () => {
  const [userRole, setUserRole] = useState('');
  const [selectedTab, setSelectedTab] = useState(0);
  const [idRole, setIdRole] = useState<number>(0);
  const [permissions, setPermissions] = useState<IPermission[]>([]);

  const handleTabPress = (index: any) => {
    setSelectedTab(index);
    console.log('Valor seleccionado:', index);
  };

  const getPermissions = async () => {
    console.log('ID del rol:', idRole);
    try {
      const response = await axios.get(`/role_permissions/${idRole}`);
      const permissions = response.data.data;
      setPermissions(permissions);
    } catch (error) {
      console.error('Error al obtener los permisos:', error);
    }
  };

  useEffect(() => {
    const fetchUserRole = async () => {
      const decodedToken = await decodeToken();
      if (decodedToken && decodedToken.nameRole) {
        setUserRole(decodedToken.nameRole);
      }
      if (decodedToken && decodedToken.role_id) {
        setIdRole(decodedToken.role_id);
      }
    };
  
    fetchUserRole();
  }, []);
  
  useEffect(() => {
    getPermissions();
  }, [idRole,userRole]);

  const renderScreen = (name: string, component: any, iconName: string) => {
    return (
      <Tab.Screen
        name={name}
        component={component}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name={iconName} color={color} size={size} />
          ),
        }}
      />
    );
  };

  const isPermissionEnabled = (permissionName: string) => {
    if (userRole === 'superAdministrador') {
      return true;
    }

    const permission = permissions.find((p: IPermission) => p.name === permissionName);
    return permission && permission.state;
  };

  return (
    <Tab.Navigator>
      {userRole === 'superAdministrador' && (
        <>
          {renderScreen('Roles y permisos', RolePermissionScreen, 'male')}
          {renderScreen('Usuarios', UsersView, 'male')}
        </>
      )}

      {isPermissionEnabled('identificacion') &&
        renderScreen('Identificación', IdentificationScreen, 'car')}
      {isPermissionEnabled('inspeccion visual') &&
        renderScreen('Inspección Visual', VisualInspectionScreen, 'eye')}
      {isPermissionEnabled('holguras') && 
        renderScreen('Holguras', ClearancesScreen, 'key')}
      {isPermissionEnabled('llantas') &&
        renderScreen('Llantas', WheelsScreen, 'circle')}
      {renderScreen('Salir', ExitScreen, 'sign-out')}
    </Tab.Navigator>
  );
};

export default App;
