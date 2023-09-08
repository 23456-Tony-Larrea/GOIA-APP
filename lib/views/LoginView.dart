import 'package:flutter/material.dart';
import 'package:rtv/controllers/LoginController.dart';
import 'package:rtv/controllers/ConfigHostController.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  final ConfigHostController _configHostController = ConfigHostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FutureBuilder<String?>(
                  future: _configHostController.getHostFromSharedPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      Fluttertoast.showToast(
                        msg: "el host ha sido guardado con éxito",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM_LEFT,
                        backgroundColor: Colors.greenAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        timeInSecForIosWeb: 5, // display duration for web
                      );
                      //traer estaHost
                      _configHostController
                          .getHostFromSharedPreferences()
                          .then((estaIp) {
                        if (estaIp != null) {
                          // Mostrar un mensaje Toast con el valor de esta_host
                          print(estaIp);
                          Fluttertoast.showToast(
                            msg: 'Tu host es: $estaIp',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM_LEFT,
                            backgroundColor: Colors.greenAccent,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          ;
                        }
                      });

                      return Container();
                    } else {
                      Fluttertoast.showToast(
                        msg: "el host no se pudo guardar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        timeInSecForIosWeb: 5, // display duration for web
                      );
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Configura tu host'),
                                content: TextField(
                                  controller:
                                      _configHostController.configController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Host',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _configHostController.addConfig(context);
                                    },
                                    child: const Text('Guardar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.settings),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        Expanded(
  child: Stack(
    children: [
      // Fondo con imagen transparente
      Image.asset(
        'assets/images/fondo.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
Center(
  child: Card(
    margin: EdgeInsets.all(10.0),
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'RTV-SYSTEM',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/logoMecanico.png'),
            radius: 40,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _loginController.emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person), // Agrega un ícono de usuario
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _loginController.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock), // Agrega un ícono de candado
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _loginController.login(context),
            icon: Icon(Icons.login), // Agrega un ícono al botón "Ingresar"
            label: Text('Ingresar'),
          ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
    );
  }
}
