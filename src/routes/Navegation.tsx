import { createStackNavigator } from '@react-navigation/stack';
import LoginView from '../views/LoginView';
import HomeScreen from '../views/HomeView';
import RegisterView from '../views/RegisterView'
import RolePermissionView from '../views/RolePermissionScreen';
import UsersView from '../views/UsersViews';

const Stack = createStackNavigator();

const Navigation = () => {
  return (
    <Stack.Navigator initialRouteName="Inicio">
      <Stack.Screen name="Ingreso" component={LoginView} />
      <Stack.Screen name="Inicio" component={HomeScreen} />
      <Stack.Screen name="Registro" component={RegisterView} />
      <Stack.Screen name="Roles y Permisos " component={RolePermissionView} />
      <Stack.Screen name="Usuarios" component={UsersView} />
    </Stack.Navigator>
  );
};

export default Navigation;