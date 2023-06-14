import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/FontAwesome';
import IdentificationScreen from '../views/IdentificationScreen'
import VisualInspectionScreen from './VisualInspectionScreen';
import ClearancesScreen from './ClearancesScreen';
import WheelsScreen from './WheelsScreen'
import RolePermissionScreen from './RolePermissionScreen';
import UsersView from './UsersViews';
const Tab = createBottomTabNavigator();

const App = () => {
  return (
    <Tab.Navigator>
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
