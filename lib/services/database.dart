import 'package:LectoEscrituraApp/models/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LectoEscrituraApp/models/userData.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('game');

  Future updateUserData(String image, String name, int age) async {
    return await userDataCollection.doc(uid).set({
      'image': image,
      'name': name,
      'age': age,
    });
  }

  Future updateGame(String title, String description, int age) async {
    return await userDataCollection.doc(uid).set({
      'title': title,
      'description': description,
      'age': age,
    });
  }

//game list from snapshot
  List<Game> _gameListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Game(
        title: doc.data()['name'] ?? '',
        description: doc.data()['image'] ?? '',
        age: doc.data()['age'] ?? 0,
      );
    }).toList();
  }

  //userDataFromSnapshot
  UserData _gameDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserData(
      uid: uid,
      name: documentSnapshot.data()['title'] ?? '',
      image: documentSnapshot.data()['description'] ?? '',
      age: documentSnapshot.data()['age'] ?? 0,
    );
  }

  //user list from snapshot
  List<UserData> _userListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return UserData(
        name: doc.data()['name'] ?? '',
        age: doc.data()['age'] ?? 0,
        image: doc.data()['image'] ?? '',
      );
    }).toList();
  }

  //userDataFromSnapshot
  UserData _userDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserData(
      uid: uid,
      name: documentSnapshot.data()['name'] ?? '',
      age: documentSnapshot.data()['age'] ?? 0,
      image: documentSnapshot.data()['image'] ?? '',
    );
  }

  //get userlist stream
  Stream<List<UserData>> get userdataCollection {
    return userDataCollection.snapshots().map(_userListFromSnapshot);
  }

  //get user document stream
  Stream<UserData> get userData {
    return userDataCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get Gamelist stream
  Stream<List<Game>> get gameListCollection {
    return gameCollection.snapshots().map(_gameListFromSnapshot);
  }

  //get user document stream
  Stream<UserData> get game {
    return userDataCollection.doc(uid).snapshots().map(_gameDataFromSnapshot);
  }
}
