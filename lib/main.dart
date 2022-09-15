import 'package:LectoEscrituraApp/screens/games/drag&drop.dart';
import 'package:LectoEscrituraApp/screens/games/tablevocals.dart';
import 'package:LectoEscrituraApp/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LectoEscrituraApp/screens/wrapper.dart';
import 'package:LectoEscrituraApp/services/auth.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var u = UserCustom();

    return StreamProvider<UserCustom>.value(
      initialData: u,
      value: AuthService().user,
      child: MaterialApp(
        darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
        theme: ThemeData.from(
            colorScheme: ColorScheme(
          onSecondary: Colors.blue[50],
          background: Colors.blue[50],
          brightness: Brightness.light,
          secondary: Colors.blue[400],
          surface: Colors.white,
          error: Colors.blueAccent,
          onError: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.blue[400],
          primary: Colors.blue[400],
          onSurface: Colors.blue[400],
        )),
        routes: {
          '/home': (context) => Home(),
          '/drag&drop': (context) => DragnDropGame(),
          '/tableVocals': (context) => TableVocals(),
        },
        home: Wrapper(),
      ),
    );
  }
}
