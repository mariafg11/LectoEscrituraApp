import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double fontSize = 14;
  bool daltonicMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Colors.red[400],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Tamaño de Letra',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Slider(
                  value: fontSize,
                  min: 14.0,
                  max: 24.0,
                  label: fontSize.toString(),
                  divisions: 5,
                  onChanged: (val) => setState(() => fontSize = val),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Modo Daltónico',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Switch(
                  value: daltonicMode,
                  onChanged: (val) => setState(() => daltonicMode = val),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}