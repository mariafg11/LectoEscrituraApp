import 'dart:developer';

import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/services/rPeacker.dart';
import 'package:LectoEscrituraApp/shared/answersDialog.dart';
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

  int right = 0;
  int wrong = 0;

  List<String> _grid = new List.empty();
  List<int> selectedIndexList = [];
  List<String> _emojis = new List.empty();
  List<String> _vocals = <String>['A', 'E', 'I', 'O', 'U'];
  Rpeacker peaker = new Rpeacker();
  Color colorCard = Colors.orange[50];
  String error = '';
  int seed = 0;

  void initState() {
    super.initState();
    _options = peaker.randomPeaker(6);
    _emojis = _options.values.toList();
    _grid = _createlist();
    //reset the sacore counter
    wrong = 0;
    right = 0;
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
    if (selectedIndexList.isEmpty) {
      error = 'rellena las casillas';
      return result = false;
    } else {
      for (int item in selectedIndexList) {
        int mod = item % 6;
        String word = _options.keys.elementAt(i);
        i++;
        switch (mod) {
          case 1: //A

            if (word.endsWith('a')) {
              right++;
            } else {
              wrong++;
              error = error + '$word no termina en A \n';
              result = false;
            }
            break;
          case 2: //E
            if (word.endsWith('e')) {
              right++;
            } else {
              wrong++;
              error = error + '$word no termina en E \n';
              result = false;
            }
            break;
          case 3:
            //I
            if (word.endsWith('i')) {
              right++;
            } else {
              wrong++;
              error = error + '$word no termina en I \n';
              result = false;
            }
            break;
          case 4: //O
            if (word.endsWith('o')) {
              right++;
            } else {
              wrong++;
              error = error + '$word no termina en O \n';
              result = false;
            }
            break;
          case 5: //U
            if (word.endsWith('u')) {
              right++;
            } else {
              wrong++;
              error = error + '$word no termina en U \n ';

              result = false;
            }
            break;
          default:
            error = error + 'Termina en consonante ';
        }
      }
    }
    log(error + selectedIndexList.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserCustom>(context, listen: false);

    DatabaseService db = DatabaseService(uid: user.uid);
    final String gameId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          title: Text('Puntos  $right/5'),
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
          onPressed: () {
            setState(() {
              // score.clear();
              selectedIndexList = [];
              seed++;
              _options = peaker.randomPeaker(6);
              _emojis = _options.values.toList();
              _grid = _createlist();
              error = '';
              right = 0;
              wrong = 0;
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
                            if (_twoInLine(selectedIndexList)) {
                              selectedIndexList.remove(index);
                            } else {
                              selectedIndexList.add(index);
                            }
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
                    right = 5;
                    audioPlayer.play('correcto.mp3');
                    error = '';
                    db.updateProgress(gameId, right, wrong);
                  } else {
                    right = 5 - wrong;
                  }
                });
                if (right == 5) {
                  int result = right;
                  audioPlayer.play('applause.mp3');
                  setState(() {
                    // score.clear();
                    selectedIndexList = [];
                    seed++;
                    _options = peaker.randomPeaker(6);
                    _emojis = _options.values.toList();
                    _grid = _createlist();
                    error = '';
                    right = 0;
                    wrong = 0;
                  });
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AnswersDialog(
                          right: result,
                        );
                      });
                } else {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 200.0,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20.0),
                                      Text(error,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.0)),
                                    ],
                                  ),
                                )
                              ]),
                        );
                      });
                }
              },
              icon: Icon(Icons.check_circle),
              //color: Colors.green,
              iconSize: 40,
            ),
          ],
        ));
  }
}
