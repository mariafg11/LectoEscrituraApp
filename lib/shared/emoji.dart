import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  const Emoji({Key key, this.emoji}) : super(key: key);
  final String emoji;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        child: Text(
          emoji,
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
