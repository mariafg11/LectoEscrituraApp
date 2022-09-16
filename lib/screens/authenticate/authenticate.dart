import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:flutter/material.dart';
import 'package:LectoEscrituraApp/screens/authenticate/register.dart';
import 'package:LectoEscrituraApp/screens/authenticate/signIn.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

//devuelve una pagina u otra dependiendo si hay un usuario conectado
class _AuthenticateState extends State<Authenticate> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context);
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: [
                  SizedBox(height: 100.0),
                  Image(
                    image: AssetImage('assets/test.png'),
                    width: 500.0,
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      minimumSize: Size(275.0, 70.0),
                    ),
                    label: Text(
                      'Jugar ',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      if (user == null) {
                        loading = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange[300],
                      minimumSize: Size(275.0, 70.0),
                    ),
                    label: Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
