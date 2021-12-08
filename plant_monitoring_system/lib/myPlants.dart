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
      setState(() {
        packageList =  plantList;
        _selectedPackage = packageList[0];
      });
      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }
  late Plantdata _selectedPackage;
  late Future<List<Plantdata>> futurePlants;
  List<Plantdata> packageList = [];

  @override
  void initState() {
    super.initState();
    futurePlants = fetchPlants();

  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ViewPlantScreen(dataHolder)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plantdata>>(
      future: fetchPlants(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          List<DropdownMenuItem<Plantdata>> items = packageList.map((item) {
            return DropdownMenuItem<Plantdata>(
              child: Text(item.plantType),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (items.isEmpty) {
            items = [
              DropdownMenuItem(
                child: Text(_selectedPackage.plantType),
                value: _selectedPackage,
              )
            ];
          }
          return Scaffold(
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.9), BlendMode.darken),
                      fit: BoxFit.cover)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          height: 80,
                          color: Colors.grey.withOpacity(0.12),
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
                                      maximumSize: Size(90, 90),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupAdd(context, items),
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 130,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 30,
                      child: FutureBuilder<List<Plantdata>>(
                          future: futurePlants,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: (MediaQuery
                                        .of(context)
                                        .size
                                        .width <
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height)
                                        ? 0.65
                                        : 1.4,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    crossAxisCount: 2),
                                padding: EdgeInsets.only(top: 0.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    color: Colors.transparent,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: new BorderSide(
                                              color: Colors.blueGrey
                                                  .withOpacity(0.4),
                                              width: 2.0),
                                          borderRadius: BorderRadius.circular(
                                              4.0)),
                                      color: Colors.greenAccent.withOpacity(
                                          0.12),
                                      margin: EdgeInsets.only(bottom: 2.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            left: 0,
                                            right: 0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                                  child: SizedBox(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        0.35,
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .plantType,
                                                      maxLines: 3,
                                                      //'Note Title',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  height: (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height >
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width)
                                                      ? MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height *
                                                      0.15
                                                      : MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height *
                                                      0.35,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.35,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/bg.jpg"),
                                                          fit: BoxFit.cover)),
                                                ),
                                                Spacer(),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      child: Text(
                                                        "View",
                                                        textScaleFactor: 1.3,
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .transparent,
                                                        elevation: 0,
                                                        //fixedSize: Size(MediaQuery.of(context).size.width * 0.25, MediaQuery.of(context).size.height * 0.15),
                                                      ),
                                                      onPressed: () {
                                                        navigateToNextActivity(
                                                            context, snapshot
                                                            .data![index]
                                                            .plantID);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text(
                                                        "Delete",
                                                        textScaleFactor: 1.3,
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .transparent,
                                                        onPrimary: Colors.red,
                                                        elevation: 0,
                                                        //fixedSize: Size(MediaQuery.of(context).size.width * 0.25, MediaQuery.of(context).size.height * 0.15),
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) =>
                                                              _buildPopupDelete(
                                                                  context,
                                                                  snapshot
                                                                      .data![index]
                                                                      .plantType),
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
                            return Center(
                                child: CircularProgressIndicator()
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
      }else if (snapshot.hasError) {
        return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Center(
            child: CircularProgressIndicator()
        );
  },
    );
  }

  Widget _buildPopupAdd(BuildContext context,List<DropdownMenuItem<Plantdata>> items) {

    return new AlertDialog(
      title: const Text('Choose a plant:'),
      content:  StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<Plantdata>(
                items: items,
                value: _selectedPackage,
                onChanged: (newVal) => setState(() => _selectedPackage = newVal!),

              ),
            ],
          );
  },
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

  Widget _buildPopupDelete(BuildContext context, String text) {
    late Future<List<Plantdata>> futurePlants;

    return new AlertDialog(
      title: const Text("Are you sure you want to delete this plant?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
            ),),
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
}
