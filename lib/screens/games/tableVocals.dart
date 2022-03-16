import 'dart:developer';

import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/services/rPeacker.dart';
import 'package:LectoEscrituraApp/shared/help.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableVocals extends StatefulWidget {
  const TableVocals({
    Key key,
  }) : super(key: key);

  @override
  _TableVocalsState createState() => _TableVocalsState();
}

class _TableVocalsState extends State<TableVocals> {
  Map _options = new Map();
  AudioCache audioPlayer = AudioCache();

  int score = 0;
  List<String> _grid = new List.empty();
  List<int> selectedIndexList = [];
  List<String> _emojis = new List.empty();
  List<String> _vocals = <String>['A', 'E', 'I', 'O', 'U'];
  rPeacker peaker = new rPeacker();
  Color colorCard = Colors.orange[50];
  String error = '';
  int seed = 0;

  void initState() {
    super.initState();
    _options = peaker.randomPeaker(6);
    _emojis = _options.values.toList();
    _grid = _createlist();

    score = 0;
  }

  List<String> _createlist() {
    List<String> list = [];
    int j = 0;
    for (var i = 0; i < 36; i++) {
      if (i > 0 && i < 6) {
        list.add(_vocals[i - 1]);
      } else if (i % 6 == 0 && i != 0) {
        list.add(_emojis[j]);
        j++;
      } else {
        list.add('');
      }
    }
    return list;
  }

  bool _twoInLine(t) {
    int repeat1 = 0;
    int repeat2 = 0;
    int repeat3 = 0;
    int repeat4 = 0;
    int repeat5 = 0;

    bool result = false;
    int row = 1;
    for (var i = 0; i < selectedIndexList.length; i++) {
      int line = (selectedIndexList[i] ~/ 6);
      switch (line) {
        case 1:
          repeat1++;
          break;
        case 2:
          repeat2++;
          break;
        case 3:
          repeat3++;
          break;
        case 4:
          repeat4++;
          break;
        case 5:
          repeat5++;
          break;
      }
    }
    if ((repeat1 > 1) |
        (repeat2 > 1) |
        (repeat3 > 1) |
        (repeat4 > 1) |
        (repeat5 > 1)) {
      result = true;
    }
    return result;
  }

  bool _isCorrect() {
    int i = 0;
    bool result = true;
    selectedIndexList.sort();
    for (int item in selectedIndexList) {
      int mod = item % 6;
      String word = _options.keys.elementAt(i);
      i++;
      switch (mod) {
        case 1: //A

          if (word.endsWith('a')) {
            score++;
          } else {
            error = error + '$word no termina en A ';
            result = false;
          }
          break;
        case 2: //E
          if (word.endsWith('e')) {
            score++;
          } else {
            error = error + '$word no termina en E ';
            result = false;
          }
          break;
        case 3:
          //I
          if (word.endsWith('i')) {
            score++;
          } else {
            error = error + '$word no termina en I ';
            result = false;
          }
          break;
        case 4: //O
          if (word.endsWith('o')) {
            score++;
          } else {
            error = error + '$word no termina en O ';
            result = false;
          }
          break;
        case 5: //U
          if (word.endsWith('u')) {
            score++;
          } else {
            error = error + '$word no termina en U ';
            result = false;
          }
          break;
        default:
          error = error + 'Termina en consonante ';
      }
    }
    log(error + selectedIndexList.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);
    final String gameId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          title: Text('Puntos  $score/5'),
          backgroundColor: Colors.red[400],
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Help(
                          gameId: gameId,
                        );
                      });
                },
                icon: Icon(Icons.help))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          backgroundColor: Colors.red[400],
          onPressed: () {
            setState(() {
              // score.clear();
              selectedIndexList = [];
              seed++;
              _options = peaker.randomPeaker(6);
              _emojis = _options.values.toList();
              _grid = _createlist();
              error = '';
              score = 0;
            });
          },
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Selecciona la casilla de la ultima vocal del emoji',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemCount: _grid.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: selectedIndexList.contains(index)
                          ? Colors.green
                          : colorCard,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            '${_grid.elementAt(index)}',
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          if (!selectedIndexList.contains(index) &&
                              index > 6 &&
                              index % 6 != 0) {
                            selectedIndexList.add(index);
                          } else {
                            selectedIndexList.remove(index);
                          }
                          setState(() {});
                        },
                      ),
                    );
                  }),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_twoInLine(selectedIndexList)) {
                    error = ('Solo un cuadrado por fila');
                  } else if (_isCorrect()) {
                    score = 5;
                    audioPlayer.play('correcto.mp3');
                    error = '';
                  } else {
                    score = 5 - score;
                  }
                  db.updateProgress(gameId, score);
                });
              },
              icon: Icon(Icons.check_circle),
              color: Colors.green,
              iconSize: 40,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ));
  }
}
