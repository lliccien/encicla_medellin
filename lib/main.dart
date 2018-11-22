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
  
  List data;

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
    this.setState(() {
      // decodifico la respuesta
      final jsonResponse = json.decode(response.body);
      // la convierto a mi modelo con el metodo
      Encicla encicla = new Encicla.fromJson(jsonResponse);
      // obtengo la lista 
      data = encicla.stations;
    });

    print(data[0]['name']);

    return 'Success!';
  }

  @override
  void iniStated() {
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Encicla"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Text(data[index]['name']),
          );
        },
      ),
    );
  }
}


