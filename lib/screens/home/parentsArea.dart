import 'package:LectoEscrituraApp/models/progress.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentsArea extends StatefulWidget {
  const ParentsArea({Key key}) : super(key: key);

  @override
  _ParentsAreaState createState() => _ParentsAreaState();
}

class _ParentsAreaState extends State<ParentsArea> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);

    return FutureBuilder<List<Progress>>(
      future: db.getProgress(),
      builder: (BuildContext context, AsyncSnapshot<List<Progress>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.isNotEmpty) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<Progress> data = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("bienvenido"),
              backgroundColor: Colors.red[400],
            ),
            body: Text('Aqui van los graficos'),
          );
        }

        return Loading();
      },
    );
  }
}
