import 'dart:developer';
import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/nGames.dart';
import 'package:LectoEscrituraApp/models/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String uid;
  var uuid = Uuid();
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('game');
  final CollectionReference progressCollection =
      FirebaseFirestore.instance.collection('progress');

  Future<List<NGames>> ntipeGames() async {
    List<NGames> result = [];
    NGames item;

    List<String> tipes = [
      'Leer-Palabra',
      'Leer-Letra',
      'Leer-Silaba',
      'Escribir-Letra',
      'Escribir-Silaba',
      'Escribir-Palabra'
    ];
    List<Game> gamesProgress = [];

    List<Progress> progressList = await getProgress();
    for (var item in progressList) {
      DocumentSnapshot qShot = await gameCollection.doc(item.gameId).get();
      var gameDoc = qShot.data().entries;
      Game gamesCasted = Game(
        uid: item.gameId,
        title: gameDoc.elementAt(2).value,
        tipe: gameDoc.elementAt(1).value,
        description: gameDoc.first.value,
        age: gameDoc.last.value,
      );

      gamesProgress.add(gamesCasted);
    }

    int size = 0;
    for (var i in tipes) {
      List gameList = gamesProgress.where((x) => x.tipe == i).toList();
      //.where('tipe', isEqualTo: i).get();
      if (gameList != null) {
        size = gameList.length;
      }
      item = NGames(i, size, gameList);
      if (item != null) {
        result.add(item);
      }
    }
    log(result.toString());
    return result;
  }

  Future updateProgress(
    String gameId,
    int score,
  ) async {
    QuerySnapshot qShot = await progressCollection
        .where('gameId', isEqualTo: gameId)
        .where('userId', isEqualTo: uid)
        .get();
    if (qShot.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = qShot.docs.first;
      log(doc.data.toString());

      int rep = doc.get('repetitions') + 1;
      List<int> sc = doc.get('score');
      sc.add(score);
      return await progressCollection.doc(doc.id).set({
        'userId': uid,
        'gameId': gameId,
        'score': sc,
        'repetitions': rep,
      });
    } else {
      return await progressCollection.doc(uuid.v1()).set({
        'userId': uid,
        'gameId': gameId,
        'score': score,
        'repetitions': 1,
      });
    }
  }

  Future updateUserData(String image, String name, int age) async {
    return await userDataCollection.doc(uid).set({
      'image': image,
      'name': name,
      'age': age,
    });
  }

  Future<List<Progress>> getProgress() async {
    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection('progress')
        .where('userId', isEqualTo: uid)
        .get();
    return qShot.docs
        .map((doc) => Progress(
            uid: doc.id,
            gameId: doc.data()['gameId'],
            userId: uid,
            repetitions: doc.data()['repetitions'],
            score: doc.data()['score']))
        .toList();
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
