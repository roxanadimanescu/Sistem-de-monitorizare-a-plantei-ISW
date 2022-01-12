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
  String min_humidity;
  String max_humidity;
  String min_temp;
  String max_temp;
  String min_light;
  String max_light;

  Plantdata(
      {required this.plantID,
      required this.plantType,
      required this.plantDimension,
      required this.plantDescription,
        required this.min_humidity,
        required this.max_humidity,
        required this.min_temp,
        required this.max_temp,
        required this.min_light,
        required this.max_light,
      });

  factory Plantdata.fromJson(Map<String, dynamic> json) {
    return Plantdata(
        plantID: json['id'],
        plantType: json['type'],
        plantDimension: json['dimension'],
        plantDescription: json['description'],
        min_humidity: json['min_humidity'],
        max_humidity: json['max_humidity'],
        min_temp: json['min_temp'],
        max_temp: json['max_temp'],
        min_light: json['min_light'],
        max_light: json['max_light'],
    );
  }
}

class MyPlantsScreen extends StatefulWidget {
  late final String idHolder;
  MyPlantsScreen(this.idHolder);

  @override
  _MyPlantsState createState() => _MyPlantsState(this.idHolder);
}

class _MyPlantsState extends State<MyPlantsScreen> {
  _MyPlantsState(this.idHolder);
  final String idHolder;
  late String selectedPlantId = '1';
  late Plantdata _selectedPackage;
  late Future<List<Plantdata>> futurePlants;
  late Future<List<Plantdata>> futureAllPlants;
  List<Plantdata> packageList = [];
  TextEditingController nicknameController = TextEditingController();

  final String getPlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/getMyPlant.php';
  final String deletePlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/deletePlant.php';
  final String getAllPlantsURL =
      'https://plantmonitoringsystem5.000webhostapp.com/get.php';
  final String addPlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/addPlant.php';

  void deletePlant(String deleteID, String userID) async {
    var data = {
      'plant_id': int.parse(deleteID.toString()),
      'user_id': int.parse(userID.toString())
    };
    await http.post(Uri.parse(deletePlantURL), body: json.encode(data));
  }
  void addPlant(String nickname, String userID, String plantID) async {
    var data = {
      'nickname': nickname,
      'user_id': int.parse(userID.toString()),
      'plant_id': int.parse(plantID.toString()),
    };
    var addResponse = await http.post(Uri.parse(addPlantURL), body: json.encode(data));
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
      setState(() {
        packageList = plantList;
        _selectedPackage = plantList[0];
      });
      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  void initState() {
    futurePlants = fetchMyPlants();
    futureAllPlants = fetchAllPlants();
    super.initState();
  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ViewPlantScreen(dataHolder)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plantdata>>(
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
            print("se ajunge aici");
            items = [
              DropdownMenuItem(
                child: Text(_selectedPackage.plantType),
                value: _selectedPackage,
              )
            ];
          }
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
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
                                                  ? 0.7
                                                  : 1.5,
                                          mainAxisSpacing: 15,
                                          crossAxisSpacing: 15,
                                          crossAxisCount: 2),
                                  padding: EdgeInsets.only(top: 0.0, bottom:80),
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
                                                      height: (MediaQuery.of(context).size.width <
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height)
                                                          ? 45
                                                          : 25,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      child: Text(
                                                        snapshot.data![index].plantType,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
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
                                                                "assets/images/"+snapshot
                                                                    .data![index]
                                                                    .plantType+".jpg"),
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
                      top: MediaQuery.of(context).size.height-80,
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
                            side: BorderSide(width: 2.0, color: Colors.white),
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
                      onChanged: (newVal)
                      {
                        setState(()  {
                        _selectedPackage = newVal!;
                         selectedPlantId = _selectedPackage.plantID;
                        });
                      },
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
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                     FilteringTextInputFormatter.allow(
                  RegExp("[0-9a-zA-Z]")),
                    ],
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
            //Navigator.of(context).pop();
            //if(nicknameController.text.isEmpty) nicknameController.text = selectedDrop.plantType;

            addPlant(nicknameController.text, idHolder, selectedPlantId);
            Navigator.push( context, MaterialPageRoute( builder: (context) => MyPlantsScreen(idHolder)), ).then((value) => setState(() {}));
            
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
      BuildContext context, String text, String plantId, String idUser) {
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
            deletePlant(plantId, idUser);
            Navigator.push( context, MaterialPageRoute( builder: (context) => MyPlantsScreen(idHolder)), ).then((value) => setState(() {}));
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
