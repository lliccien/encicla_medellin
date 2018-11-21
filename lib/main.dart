import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));

}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

// modelo
class Encicla {
  int date;
  List stations;

  Encicla({
    this.date,
    this.stations
});

  factory Encicla.fromJson(Map<String, dynamic> parsedJson){
    return Encicla(
      date: parsedJson['date'],
      stations : parsedJson['stations'],
    );
  }
}


class HomePageState extends State<HomePage> {
  

  Future<String> getData() async {

    http.Response response = await http.get(
      Uri.encodeFull('http://www.encicla.gov.co/estado'),
      headers: {
        "Accept": "application/json"
      }
    );
    
    /*
    * Como la respuesta no es un List (Array) sino un objeto {}
    * la respuesta se considera un Map<String, dynamic>
    * debe definirce una clase con la esturctura de la respuesta y 
    * un metodo de conversion formJson
    */
    // decodifico la respuesta
    final jsonResponse = json.decode(response.body);
    // la convierto a mi modelo con el metodo
    Encicla encicla = new Encicla.fromJson(jsonResponse);
    // obtengo la lista 
    List data = encicla.stations;
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text("Get data"),
          onPressed: getData,
        ),
      ),
    );
  }
}


