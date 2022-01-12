import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/screens/games/drag&drop.dart';
import 'package:LectoEscrituraApp/screens/games/tableVocals.dart';
import 'package:LectoEscrituraApp/screens/home/acSettings.dart';
import 'package:LectoEscrituraApp/services/auth.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final List<Game> games;

  const Home({Key key, this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<UserCustom>(context);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("bienvenido"),
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
                    MaterialPageRoute(builder: (context) => AcSettings()));
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(

              //mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.center,
              child:
                  //gif animado con ejemplo
                  Column(
            children: [
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: games.length,
                      itemBuilder: (BuildContext context, int index) {
                        String page = games.elementAt(index).title;
                        return Card(
                          child: InkWell(
                            child: Column(
                              children: [
                                Image(
                                    height: 125,
                                    width: 125,
                                    image:
                                        AssetImage('assets/' + page + '.gif')),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    games.elementAt(index).description,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/' + page);
                            },
                          ),
                        );
                      })),
            ],
          )),
        ),
      ),
    );
  }
}
