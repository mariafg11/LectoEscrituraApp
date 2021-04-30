import 'package:flutter/material.dart';
import 'package:LectoEscrituraApp/screens/authenticate/register.dart';
import 'package:LectoEscrituraApp/screens/authenticate/signIn.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

//devuelve una pagina u otra dependiendo si hay un usuario conectado
class _AuthenticateState extends State<Authenticate> {
  @override
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.red[400],
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Image(
                    image: AssetImage('assets/test.png'),
                    width: 500.0,
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    color: Colors.green[300],
                    onPressed: () {
                      return Home();
                    },
                    label: Text(
                      'Jugar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
