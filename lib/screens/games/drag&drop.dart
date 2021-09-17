import 'dart:math';

import 'package:LectoEscrituraApp/shared/emoji.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DragnDropGame extends StatefulWidget {
  @override
  const DragnDropGame({Key key}) : super(key: key);

  _DragnDropGameState createState() => _DragnDropGameState();
}

class _DragnDropGameState extends State<DragnDropGame> {
  @override
  final Map<String, bool> score = {};
  final Map options = {
    '👗': 'vestido',
    '👟': 'zapato',
    '💍': 'anillo',
    '🛌🏿': 'cama',
    '🐶': 'perro',
    '🐘': 'elefante',
    '🌞': 'sol',
  };
  int seed = 0;
  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Correcto'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            child: Text(options[emoji]),
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {},
    );
  }

  // AudioCache _audioController = AudioCache();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntos ${score.length}/7'),
        backgroundColor: Colors.red[400],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: options.keys.map((emoji) {
              return Draggable<String>(
                data: emoji,
                child: Emoji(emoji: score[emoji] == true ? '✅' : emoji),
                feedback: Emoji(
                  emoji: emoji,
                ),
                childWhenDragging: Emoji(emoji: '⚪️'),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                options.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                  ..shuffle(Random(seed)),
          ),
        ],
      ),
    );
  }
}
