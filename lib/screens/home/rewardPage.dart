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
  String top = '';
  String pant = '';
  String hat = '';
  String shoes = '';

  bool _topOn = false;
  bool _pantOn = false;
  bool _hatOn = false;
  bool _shoesOn = false;
  void initState() {
    super.initState();
    avatar = 'assets/' + widget.user.image + '-cuerpo.png';
  }

  Widget build(BuildContext context) {
    Map _options = new Map();

    List<String> images = [
      'pantalon-1.png',
      'camiseta-1.png',
      'camiseta-2.png',
      'pantalon-2.png',
      'zapatos-1.png',
      'zapatos-2.png',
      'gorro-1.png',
      'camiseta-3.png'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Viste a tu avatar'),
      ),
      body: Column(
        children: [
          Stack(clipBehavior: Clip.antiAlias, children: <Widget>[
            Image(
              fit: BoxFit.cover,
              alignment: Alignment(0, -1),
              image: AssetImage(avatar),
              width: 350,
              height: 500,
            ),
            _hatOn
                ? Image(
                    alignment: Alignment(0.3, -0.1),
                    image: AssetImage('assets/' + hat),
                    height: 380,
                    width: 330,
                  )
                : SizedBox(),
            _topOn
                ? Image(
                    image: AssetImage('assets/' + top),
                    height: 520,
                    width: 350,
                  )
                : SizedBox(),
            _pantOn
                ? Image(
                    image: AssetImage('assets/' + pant),
                    height: 525,
                    width: 350,
                  )
                : SizedBox(
                    width: 350,
                    height: 80,
                  ),
            _shoesOn
                ? Image(
                    image: AssetImage('assets/' + shoes),
                    height: 520,
                    width: 350,
                  )
                : SizedBox(),
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
                    color: Colors.amber[50],
                    child: InkWell(
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/' + images[index]),
                      ),
                      onTap: () {
                        //filtrar que lleva puesto y quitarlo si das otra vez
                        List<String> aux = images[index].split('-');
                        switch (aux[0]) {
                          case 'camiseta':
                            setState(() {
                              _topOn = true;
                              top = images[index];
                            });
                            break;
                          case 'pantalon':
                            setState(() {
                              _pantOn = true;
                              pant = images[index];
                            });
                            break;
                          case 'zapatos':
                            setState(() {
                              _shoesOn = true;
                              shoes = images[index];
                            });
                            break;
                          case 'gorro':
                            setState(() {
                              _hatOn = true;
                              hat = images[index];
                            });

                            break;
                          default:
                        }
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
