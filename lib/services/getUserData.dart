import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/models/userData.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';
import 'package:LectoEscrituraApp/screens/home/rewardPage.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetUserData extends StatelessWidget {
  final String uid;
  const GetUserData({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService(uid: uid);
    final user = Provider.of<UserCustom>(context, listen: false);

    UserData data =
        UserData(uid: user.uid, age: 0, name: '', image: 'assets/avatar1.png');
    return FutureBuilder(
      future: db.getUserData(),
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data.name == null) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          data = snapshot.data;
          return RewardPage(user: data);
        }
        return Loading();
      },
    );
  }
}
