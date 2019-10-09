import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String infoText = 'Preencha os dados';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _imc;

  void _resetValues() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      infoText = 'Preecha os dados';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcImc() {
    setState(() {
      double peso = double.parse(weightController.text);
      double alt = double.parse(heightController.text);

      _imc = peso / (alt * alt / 100) * 100;

      String complementText = 'Seu IMC é ${_imc.toStringAsPrecision(4)}';

      if (_imc < 17.0) {
        infoText = '$complementText, você está Muito Abaixo do Peso';
      } else if (_imc >= 17.0 && _imc <= 18.49) {
        infoText = '$complementText, você está Abaixo do Peso';
      } else if (_imc >= 18.5 && _imc <= 24.99) {
        infoText = '$complementText, você está Peso Normal';
      } else if (_imc >= 25.0 && _imc <= 29.99) {
        infoText = '$complementText, você está Acima do Peso';
      } else if (_imc >= 30.0 && _imc <= 34.99) {
        infoText = '$complementText, você está Obeso';
      } else if (_imc >= 35.0 && _imc <= 39.99) {
        infoText = '$complementText, você está com Obesidade Severa';
      } else {
        infoText = '$complementText, você está com Obesidade Morbida';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculadora de IMC'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetValues,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120,
                color: Colors.green,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      labelStyle: TextStyle(color: Colors.green, fontSize: 21)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 28),
                  controller: weightController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Insira o Peso';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      labelStyle: TextStyle(color: Colors.green, fontSize: 21)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 28),
                  controller: heightController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Insira a Altura';
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(20),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _calcImc();
                    }
                  },
                  child: Text(
                    'Calcular',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  infoText,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        )));
  }
}
