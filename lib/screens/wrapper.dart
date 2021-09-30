import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/screens/authenticate/authenticate.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context);
    if (user == null) {
      return Authenticate();
    } else {
      if (Navigator.canPop(context)) {
        Navigator.maybePop(
            context, MaterialPageRoute(builder: (context) => Loading()));
      }
      return Home();
    }
  }
}
