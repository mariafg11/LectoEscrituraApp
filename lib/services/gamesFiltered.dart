import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/userData.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';

class GamesFilter extends StatelessWidget {
  final String uid;
  const GamesFilter({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService(uid: uid);

    return FutureBuilder<List<Game>>(
      future: db.getGameList(),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.isNotEmpty) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Game> data = snapshot.data;

          return Home(
            games: data,
          );
        }

        return Loading();
      },
    );
  }
}
