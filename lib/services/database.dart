import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LectoEscrituraApp/models/userData.dart';
import 'package:flutter/cupertino.dart';

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

  Future<int> getUserData() async {
    DocumentSnapshot qShot =
        await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    Map<String, dynamic> data = qShot.data();
    if (!qShot.exists) {
      return 0;
    }

    if (qShot.data().isNotEmpty) {
      return data['age'];
    }

    return 0;
  }

  Future<List<Game>> getGameList() async {
    int userAge = await getUserData();

    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection('game')
        .where('age', isLessThanOrEqualTo: userAge)
        .get();

    return qShot.docs
        .map((doc) => Game(
              uid: doc.id,
              title: doc.data()['title'],
              description: doc.data()['description'],
              age: doc.data()['age'],
            ))
        .toList();
  }
}
