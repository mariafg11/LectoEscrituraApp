import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  bool _pantsOn = false;
  bool _shirtOn = false;
  String _pants = 'pants';
  Widget build(BuildContext context) {
    Map _options = new Map();

    List<String> images = ['pantalon.png', 'camiseta.png'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Viste a tu avatar'),
      ),
      body: Row(
        children: [
          Column(
            children: [
              //POner pantalones
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    child: Image(
                      image: AssetImage(
                          _pantsOn ? 'assets/test.png' : 'assets/chica.png'),
                      width: 300,
                      height: 500,
                    ),
                  );
                },
                onWillAccept: (data) {
                  return data == _pants;
                },
                onAccept: (data) {
                  setState(() {
                    _pantsOn = true;
                  });
                },
              )
            ],
          ),
          // Pantalones que enviar a la muchahcha
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Visibility(
                visible: !_pantsOn,
                child: Draggable<String>(
                  data: _pants,
                  child: Image(
                      height: 150,
                      width: 150,
                      image: AssetImage('assets/' + images[0])),
                  feedback: Image(
                      height: 150,
                      width: 150,
                      image: AssetImage('assets/' + images[0])),
                  childWhenDragging: Text(
                    '⚪️',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              )
            ],
          )))
        ],
      ),
    );
  }
}
