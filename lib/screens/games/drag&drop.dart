import 'dart:math';
import 'package:LectoEscrituraApp/services/rPeacker.dart';
import 'package:LectoEscrituraApp/shared/emoji.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DragnDropGame extends StatefulWidget {
  @override
  const DragnDropGame({Key key}) : super(key: key);

  _DragnDropGameState createState() => _DragnDropGameState();
}

class _DragnDropGameState extends State<DragnDropGame> {
  @override
  final Map<String, bool> score = {};
  Map _options = new Map();
  rPeacker peaker = new rPeacker();
  int seed = 0;
  AudioCache audioPlayer = AudioCache();

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.transparent,
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
          // audioPlayer.setUrl('assets/correcto.mp3');
          score[emoji] = true;
          audioPlayer.play('correcto.mp3');
        });
      },
      onLeave: (data) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntos ${score.length}/6'),
        backgroundColor: Colors.red[400],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.red[400],
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
                child: Text(
                  score[emoji] == true ? '✅' : emoji,
                  style: TextStyle(fontSize: 40),
                ),
                onDragStarted: () {
                  audioPlayer.play('$emoji.mp3');
                },
                feedback: Text(
                  '$emoji',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
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