import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './profile.dart';

const api = 'https://api.github.com/users';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController newUser = TextEditingController();

  List<Map> users = [];

  void clearUsers() {
    setState(() {
      users = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(api);
    return Scaffold(
        appBar: AppBar(
          title: Text('Usuarios'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            FlatButton(
              onPressed: clearUsers,
              child: Text(
                'Limpar dados',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(5),
                  height: 50,
                  child: TextField(
                    autocorrect: false,
                    controller: newUser,
                    decoration: InputDecoration(
                        labelText: 'Adicionar Usuario',
                        border: OutlineInputBorder()),
                  ),
                )),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: RaisedButton(
                    onPressed: () => _addUser(newUser.text),
                    child: Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    ),
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
            Divider(),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: buildItem,
            ))
          ],
        ));
  }

  Widget buildItem(context, index) {
    return Column(
      children: <Widget>[
        Image(
          image: NetworkImage(users[index]['avatar_url']),
          width: 100,
          height: 100,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            users[index]['name'],
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          users[index]['bio'] ?? users[index]['login'],
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20, top: 10),
          child: RaisedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(),
                    settings: RouteSettings(arguments: users[index]))),
            child: Text(
              'Perfil',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.redAccent,
          ),
        )
      ],
    );
  }

  Future<Null> _addUser(user) async {
    http.Response response = await http.get('$api/$user');
    dynamic infos = json.decode(response.body);
    newUser.text = '';

    if (infos['message'] == 'Not Found') {
      setState(() {
        AlertDialog(
          title: Text('Usuario não encontrado'),
          content: Text('Verifique os dados'),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    } else {
      setState(() {
        users.add(infos);
      });
    }
  }
}
