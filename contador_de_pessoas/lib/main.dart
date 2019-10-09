import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: 'Contador de Pessoas', home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _peaple = 0;

  void changePeaple(add) {
    setState(() {
      if (add) {
        _peaple++;
      } else {
        _peaple--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/restaurant.jpg',
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pessoas: $_peaple',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: FlatButton(
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      onPressed: () {
                        changePeaple(true);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: FlatButton(
                    child: Text(
                      'Sair',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    onPressed: _peaple <= 0
                        ? () {}
                        : () {
                            changePeaple(false);
                          },
                  ),
                ),
              ],
            ),
            Text(
              _peaple <= 0 ? 'Está Vazio, Pode Entrar' : 'Pode entrar',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        )
      ],
    );
  }
}
