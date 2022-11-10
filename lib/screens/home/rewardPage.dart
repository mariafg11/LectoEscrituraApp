import 'package:LectoEscrituraApp/models/userData.dart';
import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  final UserData user;
  const RewardPage({Key key, this.user}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  String avatar = '';
  void initState() {
    super.initState();
    avatar = 'assets/' + widget.user.image + '-cuerpo.png';
  }

  Widget build(BuildContext context) {
    Map _options = new Map();

    List<String> images = [
      'pantalones1.png',
      'camiseta1.png',
      'camiseta2.png',
      'pantalones2.png',
      'zapatos1.png',
      'zapatos2.png',
      'lazo.png',
      'chaqueta1.png'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Viste a tu avatar'),
      ),
      body: Column(
        children: [
          Stack(children: <Widget>[
            Image(
              image: AssetImage(avatar),
              width: 300,
              height: 500,
            ),
          ]),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      child:
                          Image(image: AssetImage('assets/' + images[index])),
                      onTap: () {
                        //filtrar que lleva puesto y quitarlo si das otra vez
                        List<String> aux = avatar.split('.');
                        String selectDress = aux[0] + '-' + images[index];

                        setState(() => avatar = selectDress);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
