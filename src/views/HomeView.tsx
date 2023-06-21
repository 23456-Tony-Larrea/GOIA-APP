import React, { useState, useEffect } from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { TouchableOpacity, Alert } from 'react-native';
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
  const [navigationDisabled, setNavigationDisabled] = useState<boolean>(false);
  const [hasSearched, setHasSearched] = useState(false);


  const sendDataProcess = async (value: number) => {
    if (value === 0) {
      return;
    } else {
      const body = {
        tipo: value,
        estado: 1
      };
      try {
        const response = await axiosInstance.post('/listarProcedimientos', body);
        console.log(response.data);
      } catch (error) {
        console.log(error);
      }
    }
  };

  const getPermissions = async () => {
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
  }, [idRole, userRole]);

  const renderScreen = (name: string, component: any, iconName: string, value: number) => {
    return (
      <Tab.Screen
        name={name}
        component={component}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name={iconName} color={color} size={size} />
          ),
         
        }}
        listeners={({ navigation }) => ({
          tabPress: (event) => {
            event.preventDefault();
            setSelectedTab(value);
            sendDataProcess(value);
            navigation.navigate(name);
          },
        })}
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
          {renderScreen('Roles y permisos', RolePermissionScreen, 'male', 0)}
          {renderScreen('Usuarios', UsersView, 'male', 0)}
        </>
      )}

      {isPermissionEnabled('identificacion') &&
        renderScreen('Identificación', IdentificationScreen, 'car', 1)}
      {isPermissionEnabled('inspeccion visual') &&
        renderScreen('Inspección Visual', VisualInspectionScreen, 'eye', 2)}
      {isPermissionEnabled('holguras') &&
        renderScreen('Holguras', ClearancesScreen, 'key', 3)}
      {isPermissionEnabled('llantas') &&
        renderScreen('Llantas', WheelsScreen, 'circle', 4)}
      {renderScreen('Salir', ExitScreen, 'sign-out', 0)}
    </Tab.Navigator>
  );
};

export default App;
