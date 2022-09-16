import 'dart:developer';
import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/nGames.dart';
import 'package:LectoEscrituraApp/models/progress.dart';
import 'package:LectoEscrituraApp/models/userData.dart';
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

      Game gamesCasted = Game(
        uid: item.gameId,
        title: qShot.get('title'),
        tipe: qShot.get('tipe'),
        description: qShot.get('description'),
        age: qShot.get('age'),
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
    int rightAnwers,
    int wrongAnwers,
  ) async {
    QuerySnapshot qShot = await progressCollection
        .where('gameId', isEqualTo: gameId)
        .where('userId', isEqualTo: uid)
        .get();
    if (qShot.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = qShot.docs.first;
      log(doc.data.toString());

      List wrong = doc.get('wrong');
      List right = doc.get('right');
      right.add(rightAnwers);
      wrong.add(wrongAnwers);

      return await progressCollection.doc(doc.id).set({
        'userId': uid,
        'gameId': gameId,
        'right': right,
        'wrong': wrong,
      });
    } else {
      return await progressCollection.doc(uuid.v1()).set({
        'userId': uid,
        'gameId': gameId,
        'right': rightAnwers,
        'wrong': wrongAnwers,
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
            gameId: doc.get('gameId'),
            userId: uid,
            wrong: doc.get('wrong'),
            right: doc.get('right')))
        .toList();
  }

  Future<Game> getGame(String gameId) async {
    Game result = Game(age: 0, tipe: '', title: '', description: '');
    DocumentSnapshot qShot =
        await FirebaseFirestore.instance.collection('game').doc(gameId).get();
    Map<String, dynamic> data = qShot.data();
    if (qShot.exists) {
      result = Game(
          age: data['age'],
          tipe: data['title'],
          title: data['title'],
          description: data['description']);
    }

    return result;
  }

  Future<int> getUserDataAge() async {
    DocumentSnapshot qShot =
        await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    Map<String, dynamic> data = qShot.data();
    if (!qShot.exists) {
      return 0;
    }

    if (qShot.get('age') != null) {
      return data['age'];
    }

    return 0;
  }

  Future<UserData> getUserData() async {
    UserData result = UserData(
      uid: uid,
      age: 0,
      name: 'fallo',
      image: 'avatar1',
    );
    DocumentSnapshot qShot =
        await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    Map<String, dynamic> data = qShot.data();
    if (!qShot.exists) {
      return result;
    }

    if (qShot.get('name') != null) {
      result = UserData(
        uid: data['uid'],
        age: data['age'],
        name: data['name'],
        image: data['image'],
      );
      return result;
    }

    return result;
  }

  Future<List<Game>> getGameList() async {
    int userAge = await getUserDataAge();

    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection('game')
        .where('age', isLessThanOrEqualTo: userAge)
        .get();

    return qShot.docs
        .map((doc) => Game(
              uid: doc.id,
              title: doc.get('title'),
              description: doc.get('description'),
              age: doc.get('age'),
            ))
        .toList();
  }
}
