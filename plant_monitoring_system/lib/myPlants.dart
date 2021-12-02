import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_monitoring_system/viewPlant.dart';

class Plantdata {
  String plantID;
  String plantType;
  String plantDimension;
  String plantDescription;

  Plantdata(
      {required this.plantID,
      required this.plantType,
      required this.plantDimension,
      required this.plantDescription});

  factory Plantdata.fromJson(Map<String, dynamic> json) {
    return Plantdata(
        plantID: json['id'],
        plantType: json['type'],
        plantDimension: json['dimension'],
        plantDescription: json['description']);
  }
}

class MyPlantsScreen extends StatefulWidget {
  @override
  _MyPlantsState createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlantsScreen> {
  final String apiURL =
      'https://plantmonitoringsystem5.000webhostapp.com/get.php';

  Future<List<Plantdata>> fetchPlants() async {
    var response = await http.get(Uri.parse(apiURL));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();

      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  late Future<List<Plantdata>> futurePlants;

  @override
  void initState() {
    super.initState();
    futurePlants = fetchPlants();
  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    // Navigator.of(context).push(
    //     MaterialPageRoute(
    //         builder: (context) => SecondRouteState(dataHolder)
    //     )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.darken),
                fit: BoxFit.cover)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                    height: 140,
                    //margin: EdgeInsets.only(top: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Planti ',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 45),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              child: Text(
                                "+",
                                textScaleFactor: 1.5,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                primary: Colors.grey,
                                elevation: 0,
                                maximumSize: Size(90,90),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupAdd(context),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            Positioned(
              top: 110,
              child: Container(
                height: MediaQuery.of(context).size.height - 130,
                width: MediaQuery.of(context).size.width - 30,
                child: FutureBuilder<List<Plantdata>>(
                    future: futurePlants,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.75,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 2),
                          padding: EdgeInsets.only(top: 0.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.transparent,
                              child: Card(
                                color: Colors.black38.withOpacity(0.5),
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2, bottom: 2, left: 0, right: 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10.0),
                                            child: SizedBox(
                                              width: 160,
                                              child: Text(
                                                snapshot.data![index].plantType,
                                                //'Note Title',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 100,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/bg.jpg"),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                child: Text(
                                                  "View",
                                                  textScaleFactor: 1.5,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  elevation: 0,
                                                  maximumSize: Size(100, 50),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewPlantScreen()));
                                                },
                                              ),
                                              ElevatedButton(
                                                child: Text(
                                                  "Delete",
                                                  textScaleFactor: 1.5,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  onPrimary: Colors.red,
                                                  elevation: 0,
                                                  maximumSize: Size(100, 50),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _buildPopupDelete(
                                                            context),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      //SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data!.length == null
                              ? 0
                              : snapshot.data!.length,
                        );
                        // Text(snapshot.data.);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPopupAdd(BuildContext context) {
  late Future<List<Plantdata>> futurePlants;

  return new AlertDialog(
    title: const Text('Choose a plant:'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Lista..."),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.black,
          elevation: 0,
          maximumSize: Size(100, 50),
        ),
        child: const Text(
          'Add',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.red,
          elevation: 0,
          maximumSize: Size(100, 50),
        ),
        child: const Text(
          'Close',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    ],
  );
}

Widget _buildPopupDelete(BuildContext context) {
  late Future<List<Plantdata>> futurePlants;

  return new AlertDialog(
    title: const Text("Are you sure you want to delete this plant?"),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Cactus"),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.black,
          elevation: 0,
          maximumSize: Size(100, 50),
        ),
        child: const Text(
          'Yes',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.red,
          elevation: 0,
          maximumSize: Size(100, 50),
        ),
        child: const Text(
          'No',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    ],
  );
}
