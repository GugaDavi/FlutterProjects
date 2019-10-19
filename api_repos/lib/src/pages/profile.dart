import 'package:flutter/material.dart';

const api = 'https://api.github.com/users';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(user['login']),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image(
              image: NetworkImage(user['avatar_url']),
              width: 100,
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                user['name'],
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              user['bio'] ?? user['login'],
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(),
            // Expanded(
            //   child: ListView.builder(),
            // )
          ],
        ),
      ),
    );
  }
}
