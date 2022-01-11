import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_monitoring_system/viewPlant.dart';

import 'myProfile.dart';

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
  late final String idHolder;

  MyPlantsScreen(this.idHolder);

  @override
  _MyPlantsState createState() => _MyPlantsState(this.idHolder);
}

class _MyPlantsState extends State<MyPlantsScreen> {
  final String getPlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/getMyPlant.php';
  final String deletePlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/deletePlant.php';
  final String getAllPlantsURL =
      'https://plantmonitoringsystem5.000webhostapp.com/get.php';
  final String addPlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/addPlant.php';

  final String idHolder;
  TextEditingController nicknameController = TextEditingController();
  _MyPlantsState(this.idHolder);

  void deletePlant(String deleteID, String userID) async {
    var data = {
      'plant_id': int.parse(deleteID.toString()),
      'user_id': int.parse(userID.toString())
    };
    //print("de delete id");
    //print(data);
    var deletePlantResponse =
        await http.post(Uri.parse(deletePlantURL), body: json.encode(data));
    //print("response");
    //print(deletePlantResponse.body);
  }
  void addPlant(String nickname, String userID, String plantID) async {
    var data = {
      'nickname': nickname,
      'user_id': int.parse(userID.toString()),
      'plant_id': int.parse(plantID.toString()),
    };
    var addResponse = await http.post(Uri.parse(addPlantURL), body: json.encode(data));
    print("raspuns la add");
    print(addResponse.body);
  }

  Future<List<Plantdata>> fetchMyPlants() async {
    var data = {'id': int.parse(idHolder.toString())};

    var getPlantResponse =
        await http.post(Uri.parse(getPlantURL), body: json.encode(data));
    if (getPlantResponse.statusCode == 200) {
      final items =
          json.decode(getPlantResponse.body).cast<Map<String, dynamic>>();

      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();
      //print(plantList);
      // setState(() {
      //   packageList =  plantList;
      //   _selectedPackage = packageList[0];
      // });
      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<Plantdata>> fetchAllPlants() async {
    var data = {'id': int.parse(idHolder.toString())};

    var getPlantResponse =
        await http.post(Uri.parse(getAllPlantsURL), body: json.encode(data));
    if (getPlantResponse.statusCode == 200) {
      final items =
          json.decode(getPlantResponse.body).cast<Map<String, dynamic>>();

      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();
      //print(plantList);
      setState(() {
        packageList = plantList;
        _selectedPackage = packageList[0];
      });
      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  late Plantdata _selectedPackage;
  late Future<List<Plantdata>> futurePlants;
  late Future<List<Plantdata>> futureAllPlants;

  List<Plantdata> packageList = [];

  @override
  void initState() {
    // ConnectionUtil connectionStatus = ConnectionUtil.getInstance();
    // connectionStatus.initialize();
    // connectionStatus.connectionChange.listen(connectionChanged);

    futurePlants = fetchMyPlants();
    futureAllPlants = fetchAllPlants();
    super.initState();
  }

  // void connectionChanged(dynamic hasConnection) {
  //   setState(() {
  //     hasInterNetConnection = hasConnection;
  //     print("~~~ Internet connection ~~~~");
  //     print(hasInterNetConnection);
  //   });
  // }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ViewPlantScreen(dataHolder)));
  }

  @override
  Widget build(BuildContext context) {
    //print("plante");
    return FutureBuilder<List<Plantdata>>(
      //future:Future.wait([fetchMyPlants(), fetchAllPlants()]) ,
      future: fetchAllPlants(),
      builder: (context, snapshot) {
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
                              // Expanded(
                              //   child: Center(
                              //     child: ElevatedButton(
                              //       child: Text(
                              //         "+",
                              //         textScaleFactor: 1.5,
                              //       ),
                              //       style: ElevatedButton.styleFrom(
                              //         shape: CircleBorder(),
                              //         primary: Colors.grey,
                              //         elevation: 0,
                              //         maximumSize: Size(90, 90),
                              //       ),
                              //       onPressed: () {
                              //         showDialog(
                              //           context: context,
                              //           builder: (BuildContext context) =>
                              //               _buildPopupAdd(context, items),
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
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
                                    child: Icon(Icons.person),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: Colors.grey,
                                      elevation: 0,
                                      maximumSize: Size(90, 90),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyProfileScreen(idHolder)));
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
                                        childAspectRatio:
                                            (MediaQuery.of(context).size.width <
                                                    MediaQuery.of(context)
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
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      color:
                                          Colors.greenAccent.withOpacity(0.12),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .plantType,
                                                      maxLines: 3,
                                                      //'Note Title',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  height: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height >
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.15
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.35,
                                                  width: MediaQuery.of(context)
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
                                                        primary:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        //fixedSize: Size(MediaQuery.of(context).size.width * 0.25, MediaQuery.of(context).size.height * 0.15),
                                                      ),
                                                      onPressed: () {
                                                        navigateToNextActivity(
                                                            context,
                                                            snapshot
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
                                                        primary:
                                                            Colors.transparent,
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
                                                                      .data![
                                                                          index]
                                                                      .plantType,
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .plantID,
                                                                  idHolder),
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
                            return Center(child: CircularProgressIndicator());
                          }),
                    ),
                  ),
                  new Positioned(
                    top: MediaQuery.of(context).size.height-90,
                    left: MediaQuery.of(context).size.width-90,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        child: Text(
                          "+",
                          textScaleFactor: 2.9,
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: Colors.grey,
                          elevation: 0,
                          //maximumSize: Size(100, 100),
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
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPopupAdd(
      BuildContext context, List<DropdownMenuItem<Plantdata>> items) {
    return new AlertDialog(
      //title: const Text('Choose a plant:'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 25,
                  child:  Text(
                    "Choose a plant:",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black,fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton<Plantdata>(
                      items: items,
                      value: _selectedPackage,
                      onChanged: (newVal) =>
                          setState(() => _selectedPackage = newVal!),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 25,
                  child:  Text(
                    "Nickname(optional)",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black,fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 25,
                  child: TextField(
                    controller: nicknameController,
                    // keyboardType: TextInputType.emailAddress,
                    // inputFormatters: [
                    //   LengthLimitingTextInputFormatter(6),
                    //   FilteringTextInputFormatter.allow(
                    //       RegExp(r'(^\-?\d*\.?\d*)')),
                    // ],
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        //borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      //hintText: "hintText",
                      //hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            addPlant(nicknameController.text, idHolder, _selectedPackage.plantID);
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

  Widget _buildPopupDelete(
      BuildContext context, String text, String id, String idUser) {
    return new AlertDialog(
      title: const Text("Are you sure you want to delete this plant?"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            deletePlant(id, idUser);
            //aici facut pamapamadadfgh
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
