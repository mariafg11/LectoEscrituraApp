import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LectoEscrituraApp/models/userData.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');

  Future updateUserData(String image, String name, int age) async {
    return await userDataCollection.doc(uid).set({
      'image': image,
      'name': name,
      'age': age,
    });
  }

  //brew list from snapshot
  List<UserData> _brewListFromSnapshot(QuerySnapshot querySnapshot) {
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

  //get brews stream
  Stream<List<UserData>> get userdataCollection {
    return userDataCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user document stream
  Stream<UserData> get userData {
    return userDataCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
