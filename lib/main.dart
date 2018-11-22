import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    title: 'Encicla Medellin',
    home: new HomePage(),
  ));

}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

// modelos
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

    //print(data[0]['items']);

    return 'Success!';
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Encicla Medellin".toUpperCase()),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new ExpansionTile(
            title: new Text(
              data[index]['name'].toString().toUpperCase(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              new Column(
                children: _buildExpandableStations(data[index]['items'])
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this.getData();
          //print('refresh');
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

_buildExpandableStations(List stations) {
  List<Widget> columnStation = [];
  Map<String, dynamic> station;
    
    /*
    * implementacion basica de listCollapse
    */

    // for(var i = 0; i < stations.length; i++) {
    //   station = stations[i];
    //   columnStation.add(
    //     new ListTile(
    //       title: new Text(station['name'])
    //     )
    //   );
    //   print(station['name']);
    // }

    for(var i = 0; i < stations.length; i++) {
      station = stations[i];
      columnStation.add(
        new Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(
                      station['name'].toString().toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0) 
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(station['address']),
                  )
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => {},
                      color: Colors.blue,
                      padding: EdgeInsets.all(10.0),
                      child: Column( 
                        children: <Widget>[
                          Icon(Icons.motorcycle),
                          Text('Disponibles: ' +  station['bikes'].toString())
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
    
        )
      );
      // print(station['name']);
    }

    return columnStation;
}
