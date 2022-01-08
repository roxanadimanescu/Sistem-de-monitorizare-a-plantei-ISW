import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_monitoring_system/myPlants.dart';

class MyProfileScreen extends StatefulWidget {
  //late final String idHolder;
  //ViewPlantScreen(this.idHolder);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfileScreen> {
  //final String apiURL = 'https://plantmonitoringsystem5.000webhostapp.com/getSpecificPlant.php';
  //final String idHolder;
  //_MyProfileState(this.idHolder);
  // Future<List<Plantdata>> fetchPlant() async {
  //
  //   var data = {'id': int.parse(idHolder.toString())};
  //   print(data);
  //   print("ID");
  //   var response = await http.post(Uri.parse(apiURL), body: json.encode(data));
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     List<Plantdata> plantList = items.map<Plantdata>((json) {
  //       return Plantdata.fromJson(json);
  //     }).toList();
  //     print(plantList);
  //     return plantList;
  //   }
  //   else {
  //     throw Exception('Failed to load data from Server.');
  //   }
  //
  // }
  //late Future<List<Plantdata>> futurePlants;
  @override
  void initState() {
    super.initState();
    //futurePlants= fetchPlant();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.9), BlendMode.darken),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 20),
                            height: 80,
                            color: Colors.grey.withOpacity(0.12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Planti ',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 45),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            )),
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          // width: MediaQuery
                          //     .of(context)
                          //     .size
                          //     .width,
                          // padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    iconSize: 50,
                                    color: Colors.grey,
                                    splashColor: Colors.purple,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 110,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Expanded(
                                    child: Text(
                                      "Edit profile",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 70,
                              height: 200,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 80,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(20.0),
                                              ),
                                            ),
                                              onPressed: () => null,
                                              child: Stack(
                                                children: <Widget>[
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Icon(Icons.person, color: Colors.green,)
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 30),
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: Text(
                                                            "Change username",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Colors.black,fontSize: 18),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,)
                                                  ),
                                                ],
                                              ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () => null,
                                            child: Stack(
                                              children: <Widget>[
                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Icon(Icons.lock, color: Colors.green,)
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 30),
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Text(
                                                          "Change password",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.black,fontSize: 18),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            onPressed: () => null,
                                            child: Stack(
                                              children: <Widget>[
                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Icon(Icons.logout, color: Colors.red,)
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 30),
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Text(
                                                          "Logout",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.black,fontSize: 18),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),




    );

  }
}