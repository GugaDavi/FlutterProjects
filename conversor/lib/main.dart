import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request = 'https://api.hgbrasil.com/finance';

Future<Map> getData() async {
  http.Response response = await http.get(request);
  dynamic infos = json.decode(response.body);

  return infos['results']['currencies'];
}

void main(List<String> args) async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();

  double dolar;
  double euro;

  void _realCalc(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsPrecision(4);
    euroController.text = (real / euro).toStringAsPrecision(4);
  }

  void _dolarCalc(String text) {
    double valueDolar = double.parse(text);
    realController.text = (valueDolar * dolar).toStringAsPrecision(4);
    euroController.text =
        (double.parse(realController.text) / euro).toStringAsPrecision(4);
  }

  void _euroCalc(String text) {
    double valueEuro = double.parse(text);
    realController.text = (valueEuro * euro).toStringAsPrecision(4);
    dolarController.text =
        (double.parse(realController.text) / dolar).toStringAsPrecision(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando Dados',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar os dados',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data['USD']['buy'];
                euro = snapshot.data['EUR']['buy'];
                return SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Icon(
                        Icons.monetization_on,
                        size: 150,
                      ),
                    ),
                    buildTextFild('Reais', 'R\$ ', realController, _realCalc),
                    buildTextFild(
                        'Dólares', 'U\$ ', dolarController, _dolarCalc),
                    buildTextFild('Euros', '€ ', euroController, _euroCalc)
                  ],
                ));
              }
          }
        },
      ),
    );
  }
}

Widget buildTextFild(String label, String prefix,
    TextEditingController controller, Function changedFunction) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 21),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(fontSize: 23),
      onChanged: changedFunction,
    ),
  );
}
