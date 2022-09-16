import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/models/userData.dart';
import 'package:LectoEscrituraApp/screens/home/acSettings.dart';
import 'package:LectoEscrituraApp/screens/home/parentsArea.dart';
import 'package:LectoEscrituraApp/services/auth.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final List<Game> games;
  //final UserData userData;

  const Home({
    Key key,
    this.games,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<UserCustom>(context);
    //var height = MediaQuery.of(context).size.height;
    DatabaseService db = DatabaseService(uid: user.uid);
    String name = '';
    UserData data =
        UserData(uid: user.uid, age: 0, name: '', image: 'assets/avatar1.png');

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido "),
        actions: [
          FutureBuilder(
              future: db.getUserData(),
              builder:
                  (BuildContext context, AsyncSnapshot<UserData> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && snapshot.data.name == null) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  data = snapshot.data;
                  name = data.name.split('@')[0];
                }

                return Row(children: [
                  Text(
                    name,
                    style: TextStyle(), //color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: (() => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loading()))),
                      child: Image(image: AssetImage(data.image))),
                ]);
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.orange[400]),
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ParentsArea()));
                }),
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
              child: Column(
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
                              Navigator.pushNamed(context, '/' + page,
                                  arguments: games.elementAt(index).uid);
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
