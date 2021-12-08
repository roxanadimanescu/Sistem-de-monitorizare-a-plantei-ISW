import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_monitoring_system/myPlants.dart';

class ViewPlantScreen extends StatefulWidget {
  late final String idHolder;
  ViewPlantScreen(this.idHolder);
  @override
  _ViewPlantState createState() => _ViewPlantState(this.idHolder);
}

class _ViewPlantState extends State<ViewPlantScreen> {
  final String apiURL = 'https://plantmonitoringsystem5.000webhostapp.com/getSpecificPlant.php';
  final String idHolder;
  _ViewPlantState(this.idHolder);
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
    return  Scaffold(
          body: FutureBuilder<List<Plantdata>>(
            future: futurePlants,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(
                  child: CircularProgressIndicator()
              );

              return Container(
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
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.only(bottom: 20),
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
                                          snapshot.data![0].plantType,
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
                                  Spacer(),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 60,
                                  height: 270,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/bg.jpg"),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,

                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 25, left: 30, right: 30, bottom: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description:", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white
                                  ),
                                  ),
                                  Text(
                                      snapshot.data![0].plantDescription,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

            },
          )
      );

  }
}