import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class Help extends StatelessWidget {
  final String gameId;
  const Help({Key key, this.gameId}) : super(key: key);
//Pasar toda la info de game id from db intentar que alguien lo lea

  Future<Game> _gamefromDb(BuildContext context) async {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);
    Game game = await db.getGame(gameId);
    return game;
  }

  Widget build(BuildContext context) {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage('ES-es');
    Game game = Game();
    return FutureBuilder<Game>(
        future: _gamefromDb(context),
        builder: (BuildContext context, AsyncSnapshot<Game> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return Dialog(child: Loading());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            game = snapshot.data;
            return Dialog(
              insetPadding: EdgeInsets.all(10),
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 600.0,
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),

                          Text(
                            'Ayuda',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 20.0),
                          //Text(game.title),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              game.description,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Image(
                            image: AssetImage('assets/' + game.title + '.gif'),
                          ),
                          SizedBox(height: 20.0),

                          IconButton(
                              onPressed: () {
                                flutterTts.speak(game.description);
                              },
                              icon: Icon(
                                Icons.volume_up,
                                size: 50.0,
                              )),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ]),
            );
          }
          return Loading();
        });
  }
}
