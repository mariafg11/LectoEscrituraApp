import 'package:LectoEscrituraApp/services/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/src/rendering/box.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final List<String> imgList = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
    'assets/avatar4.png',
    'assets/avatar5.png',
    'assets/avatar6.png',
  ];

  // final List<Widget> imageSliders = imgList
  //     .map((item) => Container(
  //           child: Container(
  //             margin: EdgeInsets.all(5.0),
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 child: Stack(
  //                   children: <Widget>[
  //                     Image.network(item, fit: BoxFit.cover, width: 1000.0),
  //                     Positioned(
  //                       bottom: 0.0,
  //                       left: 0.0,
  //                       right: 0.0,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: [
  //                               Color.fromARGB(200, 0, 0, 0),
  //                               Color.fromARGB(0, 0, 0, 0)
  //                             ],
  //                             begin: Alignment.bottomCenter,
  //                             end: Alignment.topCenter,
  //                           ),
  //                         ),
  //                         padding: EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 20.0),
  //                         child: Text(
  //                           'No. ${imgList.indexOf(item)} image',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ),
  //         ))
  //     .toList();

  final CarouselController _controller = CarouselController();

  // text field
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Registrate'),
              backgroundColor: Colors.red[400],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  // SizedBox(height: 20.0),
                  CarouselSlider(
                    items: imgList
                        .map((item) => Container(
                              child: Center(
                                  child: Image(
                                      image: AssetImage(item),
                                      fit: BoxFit.cover)),
                            ))
                        .toList(),
                    options:
                        CarouselOptions(enlargeCenterPage: true, height: 200),
                    carouselController: _controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: RaisedButton.icon(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.blue[200],
                          onPressed: () => _controller.previousPage(),
                          label: Text(''),
                        ),
                      ),
                      Flexible(
                        child: RaisedButton.icon(
                          onPressed: () => _controller.nextPage(),
                          color: Colors.blue[200],
                          icon: Icon(Icons.arrow_forward),
                          label: Text(''),
                        ),
                      ),
                    ],
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(hintText: "Email"),
                  //   validator: (val) => val.isEmpty ? "Enter an email" : null,
                  //   onChanged: (val) {
                  //     setState(() => email = val);
                  //   },
                  // ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Nombre"),
                    validator: (val) =>
                        val.length < 6 ? "Enter a password 6+ char long" : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.pink,
                      child: Text(
                        "Register ",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _auth.register(email, password);
                          if (result == null) {
                            setState(() {
                              error = "enter a valid email";
                              loading = false;
                            });
                          }
                        }
                      }),
                  SizedBox(height: 20.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]),
              ),
            ),
          );
  }
}
