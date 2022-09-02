import 'package:LectoEscrituraApp/screens/home/home.dart';
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

  final CarouselController _controller = CarouselController();

  // text field
  String email = "";
  String password = 'assets/avatar1.png';
  String error = "";
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Registrate'),
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
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: 200,
                      onPageChanged: (index, reason) {
                        setState(() {
                          password = imgList[index];
                        });
                      },
                    ),
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Nombre"),
                    validator: (val) => val.isEmpty ? "Enter an Name" : null,
                    onChanged: (val) {
                      setState(() => email = val + '@mail.com');
                    },
                  ),
                  SizedBox(height: 20.0),

                  Text('Edad'),
                  Slider(
                    value: age.toDouble(),
                    min: 0.0,
                    max: 10.0,
                    label: age.toString(),
                    divisions: 10,
                    onChanged: (val) => setState(() => age = val.round()),
                  ),
                  RaisedButton(
                      color: Colors.blue[200],
                      child: Text(
                        "Register ",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _auth.register(email, password, age);
                          if (result == null) {
                            setState(() {
                              error = "enter a valid email";
                              loading = false;
                            });
                          }
                        } else {
                          loading = true;
                          Navigator.popAndPushNamed(context, "/home");
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
