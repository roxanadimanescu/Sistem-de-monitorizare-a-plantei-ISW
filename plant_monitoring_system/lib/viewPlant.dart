import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool pressedDescription = false;
  final temperatureController = TextEditingController();
  final humidityController = TextEditingController();
  final brightnessController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    temperatureController.dispose();
    humidityController.dispose();
    brightnessController.dispose();
    super.dispose();
  }

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
  double temperature = 0;
  double humidity = 0;
  double brightness = 0;


  @override
  void initState() {
    super.initState();
    futurePlants= fetchPlant();
    temperatureController.addListener(setTemperature);
    temperatureController.addListener(setHumidity);
    temperatureController.addListener(setBrightness);

  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  double setTemperature() {
    if(isNumeric(temperatureController.text)){
      temperature = double.parse(temperatureController.text) + 20;
    }
    else{
      temperature = 20;
    }
    return temperature;
  }
  double setHumidity() {
    if(isNumeric(humidityController.text)){
      humidity = double.parse(humidityController.text) + 20;
    }
    else{
      humidity = 20;
    }
    return humidity;
  }
  double setBrightness() {
    if(isNumeric(brightnessController.text)){
      brightness = double.parse(brightnessController.text) + 20;
  }
    else{
      brightness = 20;
    }
    return brightness;
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    //print(widthScreen);
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
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: ElevatedButton(
                                      onPressed: () {
                                          setState(() {
                                            pressedDescription = !pressedDescription;
                                          });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black,
                                        elevation: 0,
                                        maximumSize: Size(220, 36),
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Description',
                                              style: TextStyle(color: Colors.black, fontSize: 20),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                !pressedDescription ? Icons.arrow_drop_down : Icons.arrow_drop_up  ,
                                                color: Colors.black,
                                                size: 35,)
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),

                                  if(pressedDescription)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                        snapshot.data![0].plantDescription,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              //color: Colors.red,
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              //padding: const EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width:120,
                                          child: Text(
                                            "Temperature",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.white,fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width:  80,
                                          height: 25,
                                          child: TextField(
                                            controller: temperatureController,
                                            keyboardType:  TextInputType.emailAddress,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(6),
                                              FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)')),
                                            ],
                                            textAlignVertical: TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black,fontSize: 18),
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
                                        SizedBox(width: 5),
                                        Text(
                                          "\u00B0C",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                      ]

                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  Container(
                                    height: 25,
                                    width:  widthScreen,
                                    margin: const EdgeInsets.only(bottom:0,right: 60, left:17),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: [
                                              0,
                                              0.7,
                                              0.9
                                            ],
                                            colors: <Color>[
                                              Colors.blue,
                                              Colors.orange,
                                              Colors.red[800]!

                                            ])
                                    ),
                                    child:
                                    Row(
                                      children: [
                                        Text(
                                          "-20",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                       Spacer(),
                                        Text(
                                          "0   ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                        Spacer(),
                                        Text(
                                          " 20 ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                        Spacer(),
                                        Text(
                                          "40",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),

                                      ],

                                    ),
                                  ),
                                  Container(
                                    //color: Colors.green,
                                    width:  widthScreen,
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(top:0,right:60,left:(widthScreen-137)/60*setTemperature()),
                                    child:
                                      Icon(
                                        Icons.arrow_drop_up  ,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                  ),

                                  //SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width:120,
                                          child: Text(
                                            "Humidity",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.white,fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width:  80,
                                          height: 25,
                                          child: TextField(
                                            controller: humidityController,
                                            keyboardType:  TextInputType.emailAddress,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(6),
                                              FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)')),
                                            ],

                                            textAlignVertical: TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black,fontSize: 18),
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
                                        SizedBox(width: 5),
                                        Text(
                                          "%",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                      ],

                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 25,
                                    width:  widthScreen,
                                    margin: const EdgeInsets.only(bottom:0,right: 60, left:17),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            // stops: [
                                            //   0,
                                            //   0.7,
                                            //   0.9
                                            // ],
                                            colors: <Color>[
                                              Colors.red[800]!,
                                              Colors.white,
                                              Colors.blue,

                                            ])
                                    ),
                                    child:
                                    Row(
                                      children: [
                                        Text(
                                          "Dry",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Wet",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),


                                      ],

                                    ),
                                  ),
                                  Container(
                                    //color: Colors.green,
                                    width:  widthScreen,
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(top:0,right:60,left:(widthScreen-137)/60*setHumidity()),
                                    child:
                                    Icon(
                                      Icons.arrow_drop_up  ,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width:120,
                                          child: Text(
                                            "Brightness",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.white,fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width:  80,
                                          height: 25,
                                          child: TextField(
                                            controller: brightnessController,
                                            keyboardType:  TextInputType.emailAddress,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(6),
                                              FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)')),
                                            ],
                                            textAlignVertical: TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black,fontSize: 18),
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
                                      ]
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 25,
                                    width:  widthScreen,
                                    margin: const EdgeInsets.only(bottom:0,right: 60, left:17),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            // stops: [
                                            //   0,
                                            //   0.7,
                                            //   0.9
                                            // ],
                                            colors: <Color>[
                                              Colors.grey[900]!,
                                              Colors.grey[100]!,
                                              //Colors.red[800]!

                                            ])
                                    ),
                                    child:
                                    Row(
                                      children: [
                                        Text(
                                          "Dark",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Bright ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.black,fontSize: 18),
                                        ),


                                      ],

                                    ),
                                  ),
                                  Container(
                                    //color: Colors.green,
                                    width:  widthScreen,
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(top:0,right:60,left:(widthScreen-137)/60*setBrightness()),
                                    child:
                                    Icon(
                                      Icons.arrow_drop_up  ,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  SizedBox(height: 20),
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