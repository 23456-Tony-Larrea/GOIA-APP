import { createStackNavigator } from '@react-navigation/stack';
import LoginView from '../views/LoginView';
import HomeScreen from '../views/HomeView';
import RegisterView from '../views/RegisterView'
import RolePermissionView from '../views/RolePermissionScreen';
import UsersView from '../views/UsersViews';
import ExitScreen from '../views/ExitScreen'
import IdentificationScreen from '../views/IdentificationScreen'
//import host view  
import Config from '../views/ConfigHostView'
import Bluetooth from '../views/ClearancesScreen'
import BluetoohScreen from '../views/ScreenBluetooj'
const Stack = createStackNavigator();

const Navigation = () => {
  return (
    <Stack.Navigator initialRouteName="Bluetooh">
      <Stack.Screen name="Ingreso" component={LoginView} />
      <Stack.Screen name="Inicio" component={HomeScreen} />
      <Stack.Screen name="Registro" component={RegisterView} />
      <Stack.Screen name="Roles y Permisos" component={RolePermissionView} />
      <Stack.Screen name="Usuarios" component={UsersView} />
      <Stack.Screen name="Salir" component={ExitScreen} />
      <Stack.Screen name="Configuracion Host" component={Config}/>
      <Stack.Screen name="Identificacion" component={IdentificationScreen}/>
      <Stack.Screen name="Bluetooh" component={Bluetooth}/> 
    </Stack.Navigator>
  );
};

export default Navigation;