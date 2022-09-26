import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnswersDialog extends StatelessWidget {
  final int right;
  const AnswersDialog({Key key, this.right}) : super(key: key);

  Widget build(BuildContext context) {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage('ES-es');

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 300.0,
              child: Column(
                children: [
                  SizedBox(height: 20.0),

                  Text(
                    '¡ENHORABUENA!',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  //Text(game.title),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '¡¡HAS ACERTADO ' + right.toString() + '!! \n MUY BIEN',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Image(
                    image: AssetImage('assets/correct.gif'),
                  ),
                  SizedBox(height: 20.0),

                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ]),
    );
  }
}
