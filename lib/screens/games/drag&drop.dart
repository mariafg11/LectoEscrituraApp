import 'dart:math';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/services/database.dart';

import 'package:LectoEscrituraApp/services/rPeacker.dart';
import 'package:LectoEscrituraApp/shared/emoji.dart';
import 'package:LectoEscrituraApp/shared/help.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class DragnDropGame extends StatefulWidget {
  @override
  const DragnDropGame({Key key}) : super(key: key);

  _DragnDropGameState createState() => _DragnDropGameState();
}

class _DragnDropGameState extends State<DragnDropGame> {
  final Map<String, bool> score = {};
  Map _options = new Map();
  Rpeacker peaker = new Rpeacker();
  int seed = 0;
  bool finalScore = false;
  AudioCache audioPlayer = AudioCache();
  int wrong = 0;

  Widget _buildDragTarget(emoji) {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);
    final String gameId = ModalRoute.of(context).settings.arguments as String;
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            //color: Colors.transparent,
            child: Text(
              'Correcto',
              style: TextStyle(fontSize: 35),
            ),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            child: Emoji(emoji: _options[emoji]),
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          if (score.length == 5) {
            db.updateProgress(gameId, score.length + 1, wrong);
          }
          // audioPlayer.setUrl('assets/correcto.mp3');
          score[emoji] = true;
          audioPlayer.play('correcto.mp3');
        });
      },
      onLeave: (data) {
        wrong++;
        //db.updateProgress(gameId, score.length);

        // audioPlayer.play('wrong.mp3');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _options = peaker.randomPeaker(6);
  }

  Widget build(BuildContext context) {
    final String gameId = ModalRoute.of(context).settings.arguments as String;
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage('ES-es');
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntos ${score.length}/6'),
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
            score.clear();
            seed++;
            _options = peaker.randomPeaker(6);
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            //first column the one which is dragable(the words)
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _options.keys.map((emoji) {
              return Draggable<String>(
                data: emoji,
                child: Semantics(
                  child: Text(
                    score[emoji] == true ? '✅' : emoji,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                onDragStarted: () {
                  flutterTts.speak(emoji);
                },
                feedback: Text(
                  '$emoji',
                  style: TextStyle(
                      fontSize: 35,
                      //color: Colors.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
                childWhenDragging: Text(
                  '⚪️',
                  style: TextStyle(fontSize: 40),
                ),
              );
            }).toList(),
          ),
          Column(
            //second column (the emoji)
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                _options.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                  ..shuffle(Random(seed)),
          ),
        ],
      ),
    );
  }
}
