import 'package:LectoEscrituraApp/screens/games/drag&drop.dart';
import 'package:LectoEscrituraApp/screens/home/settings.dart';
import 'package:LectoEscrituraApp/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        backgroundColor: Colors.red[400],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.red[400]),
                child: Text(
                  'Bienvenido',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Area Padres'),
            ),
            ListTile(
              onTap: () async {
                await _auth.signOut();
              },
              leading: Icon(Icons.person),
              title: Text("Log out"),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          height: height - 180,
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          child:
              //gif animado con ejemplo
              Column(
            children: [
              Image(image: AssetImage('assets/juego1.gif')),
              SizedBox(
                width: 20,
                height: 20,
              ),
              //explicación y boton
              Text('Arrastra la palabra con el emoji correcto'),
              SizedBox(
                width: 20,
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DragnDropGame()));
                },
                icon: Icon(Icons.play_arrow),
                label: Text('JUGAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
