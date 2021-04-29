import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/models/userCustom.dart';
import 'package:proyecto/screens/authenticate/authenticate.dart';
import 'package:proyecto/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
