import React , { useState, useEffect }from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/FontAwesome';
import IdentificationScreen from '../views/IdentificationScreen'
import VisualInspectionScreen from './VisualInspectionScreen';
import ClearancesScreen from './ClearancesScreen';
import WheelsScreen from './WheelsScreen'
import RolePermissionScreen from './RolePermissionScreen';
import UsersView from './UsersViews';
import AsyncStorage from '@react-native-async-storage/async-storage';
import jwtDecode from 'jwt-decode';
import { IDecodedToken } from '../Interface/IDecodedToken';
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
  useEffect(() => {
    const fetchUserRole = async () => {
      const decodedToken = await decodeToken();
      if (decodedToken && decodedToken.nameRole) {
        setUserRole(decodedToken.nameRole);
      }
    };

    fetchUserRole();
  }, []);

  return (
    <Tab.Navigator>
       {userRole === 'superAdministrador' && (
        <>
      <Tab.Screen
        name="Roles y permisos"
        component={RolePermissionScreen}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="male" color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen
        name="Usuarios"
        component={UsersView}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="male" color={color} size={size} />
          ),
        }}
      />
      </>
      )}
      <Tab.Screen
        name="Identificación"
        component={IdentificationScreen}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="car" color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen
        name="Inspección Visual"
        component={VisualInspectionScreen}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="eye" color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen
        name="Holguras"
        component={ClearancesScreen}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="key" color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen
        name="Llantas"
        component={WheelsScreen}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="circle" color={color} size={size} />
          ),
        }}
      />
       
    </Tab.Navigator>
  );
};

export default App;
