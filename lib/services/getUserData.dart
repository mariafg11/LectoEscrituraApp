import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/models/userData.dart';

import 'package:LectoEscrituraApp/screens/home/rewardPage.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/progress.dart';

class GetUserData extends StatelessWidget {
  final String uid;
  final UserData user;
  const GetUserData({Key key, this.user, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService(uid: uid);
    final user = Provider.of<UserCustom>(context, listen: false);

    List<Progress> data = [];
    return FutureBuilder(
      future: db.getProgress(),
      builder: (BuildContext context, AsyncSnapshot<List<Progress>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data == null) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          data = snapshot.data;

          return RewardPage(
            user: this.user,
            progress: data,
          );
        }
        return Loading();
      },
    );
  }
}
