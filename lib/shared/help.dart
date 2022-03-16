import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class Help extends StatelessWidget {
  final String gameId;
  const Help({Key key, this.gameId}) : super(key: key);
//Pasar toda la info de game id from db intentar que alguien lo lea
  @override
  Future<Game> _gamefromDb(BuildContext context) async {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);
    Game game = await db.getGame(gameId);
    return game;
  }

  Widget build(BuildContext context) {
    Game game = Game();
    return FutureBuilder<Game>(
        future: _gamefromDb(context),
        builder: (BuildContext context, AsyncSnapshot<Game> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            game = snapshot.data;
            return Dialog(
                child: Column(children: [
              Text('Ayuda'),
              Text(game.title),
              Text(game.description),
              Image(
                image: AssetImage('assets/' + game.title + '.gif'),
              ),
            ]));
          }
          return Loading();
        });
  }
}
