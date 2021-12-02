import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_monitoring_system/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      behavior: HitTestBehavior.translucent,
      child: MaterialApp(home: LoginScreen()),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Planti, planta cea buna..in curand')
        ),
        body: MainListView(),
      ),
    );
  }
}

class Plantdata {
  String plantID;
  String plantType;
  String plantDimension;
  String plantDescription;

  Plantdata ({
    required this.plantID,
    required this.plantType,
    required this.plantDimension,
    required this.plantDescription
  });

  factory Plantdata.fromJson(Map<String, dynamic> json) {
    return Plantdata(
        plantID: json['id'],
        plantType: json['type'],
        plantDimension: json['dimension'],
        plantDescription: json['description']

    );
  }
}

class MainListView extends StatefulWidget {

  MainListViewState createState() => MainListViewState();

}

class MainListViewState extends State {

  final String apiURL = 'https://plantmonitoringsystem5.000webhostapp.com/get.php';

  Future<List<Plantdata>> fetchPlants() async {

    var response = await http.get(Uri.parse(apiURL));

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();

      return plantList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  late Future<List<Plantdata>> futurePlants;

  @override
  void initState() {
    super.initState();
    futurePlants= fetchPlants();
  }
  navigateToNextActivity(BuildContext context, String dataHolder) {

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SecondRouteState(dataHolder)
        )
    );

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plantdata>>(
      future: futurePlants,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {

              return Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 32, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          InkWell(
                            onTap: (){navigateToNextActivity(context, snapshot.data![index].plantID);},

                            child: Text(
                              snapshot.data![index].plantType,
                              //'Note Title',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                          Text(
                            snapshot.data![index].plantDescription,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      //SizedBox(width: 20),
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.length == null ? 0 : snapshot.data!.length,
          );
          // Text(snapshot.data.);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      });
  }
}
class SecondRouteState extends StatefulWidget {
  late final String idHolder;
  SecondRouteState(this.idHolder);
  @override
  State<StatefulWidget> createState() {
    return SecondRoute(this.idHolder);
  }
}
class SecondRoute extends State<SecondRouteState> {
  final String apiURL = 'https://plantmonitoringsystem5.000webhostapp.com/getSpecificPlant.php';
  final String idHolder ;
  SecondRoute(this.idHolder);

  Future<List<Plantdata>> fetchPlant() async {

    var data = {'id': int.parse(idHolder.toString())};
  print(data);
  print("ID");
    var response = await http.post(Uri.parse(apiURL), body: json.encode(data));
    print(response.body);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();
    print(plantList);
      return plantList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }

    }
  late Future<List<Plantdata>> futurePlants;

  @override
  void initState() {
    super.initState();
    futurePlants= fetchPlant();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Showing Selected Item Details'),
                automaticallyImplyLeading: true,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed:() => Navigator.pop(context, false),
                )
            ),
            body: FutureBuilder<List<Plantdata>>(
              future: futurePlants,
              builder: (context, snapshot) {

                if (!snapshot.hasData) return Center(
                    child: CircularProgressIndicator()
                );

                return ListView(
                  children: snapshot.data!
                      .map((data) => Column(children: <Widget>[
                    GestureDetector(
                      onTap: (){print(data.plantType);},
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Text('ID = ' + data.plantID.toString(),
                                    style: TextStyle(fontSize: 21))),

                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text('Name = ' + data.plantType,
                                    style: TextStyle(fontSize: 21))),

                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text('Description = ' + data.plantDescription.toString(),
                                    style: TextStyle(fontSize: 21))),

                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text('Dimension = ' + data.plantDimension.toString(),
                                    style: TextStyle(fontSize: 21))),

                          ]),)
                  ],))
                      .toList(),
                );
              },
            )
        ));
  }
}
*/
