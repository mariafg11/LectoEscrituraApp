import 'package:firebase_auth/firebase_auth.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCustom _userFromFirebaseUser(User user) {
    return user != null ? UserCustom(uid: user.uid) : null;
  }

  //auth change stream
  Stream<UserCustom> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((FirebaseUser user) => _userFromFirebaseUSer(user));
  }

  //Sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email pass
  Future signInEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register In custom
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //transformar el nombre en  email y dirección de la imagen en la password
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
