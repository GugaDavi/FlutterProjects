import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

main(List<String> args) {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

  TextEditingController todoController = TextEditingController();

  List _todoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((prevItem, nextItem) {
        if (prevItem['ok'] && !nextItem['ok'])
          return 1;
        else if (!prevItem['ok'] && nextItem['ok'])
          return -1;
        else
          return 0;
      });

      _saveData();
    });
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = todoController.text;
      newTodo['ok'] = false;
      todoController.text = '';
      _todoList.add(newTodo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('To Do List'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    height: 50,
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      controller: todoController,
                      decoration: InputDecoration(
                          labelText: 'Tarefa',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder()),
                    ),
                  )),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5),
                    child: RaisedButton(
                      onPressed: _addTodo,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
                child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: buildItem,
              ),
            ))
          ],
        ));
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(index.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]['title']),
        value: _todoList[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]['ok'] ? Icons.check : Icons.error),
        ),
        onChanged: (checked) {
          setState(() {
            _todoList[index]['ok'] = checked;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text('Tarefa \"${_lastRemoved['title']}\" removida!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 3),
          );

          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getData() async {
    final diretory = await getApplicationDocumentsDirectory();
    return File('${diretory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);

    final file = await _getData();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getData();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
