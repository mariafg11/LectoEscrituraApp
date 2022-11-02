import 'package:LectoEscrituraApp/services/gamesFiltered.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context, listen: true);
    final value = user?.uid;
    if (user != null && value != null) {
      if (Navigator.canPop(context)) {
        Navigator.maybePop(
            context, MaterialPageRoute(builder: (context) => Loading()));
      }
      return GamesFilter(uid: user.uid);
    } else {
      return Authenticate();
    }
  }
}
