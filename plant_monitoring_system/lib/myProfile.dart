import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login.dart';

class MyProfileScreen extends StatefulWidget {
  late final String idHolder;
  MyProfileScreen(this.idHolder);
  @override
  _MyProfileState createState() => _MyProfileState(this.idHolder);
}

class _MyProfileState extends State<MyProfileScreen> {
  bool pressedChangeUsername = false;
  bool pressedChangePassword = false;

  final String apiChangeUsernameURL = 'https://plantmonitoringsystem5.000webhostapp.com/changeUsername.php';
  final String apiChangePasswordURL = 'https://plantmonitoringsystem5.000webhostapp.com/changePass.php';
  final String idHolder;
  TextEditingController newUsernameController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController oldPasswordController = new TextEditingController();
  _MyProfileState(this.idHolder);

  void changeUsername() async {
    var data = {'id': int.parse(idHolder.toString()), 'new_username': newUsernameController.text.toString()};
    await http.post(Uri.parse(apiChangeUsernameURL), body: json.encode(data));
  }

  void changePassword() async {
    var data = {'id': int.parse(idHolder.toString()), 'old_pass': oldPasswordController.text, 'new_pass': newPasswordController.text};
    await http.post(Uri.parse(apiChangePasswordURL), body: json.encode(data));
  }

  @override
  void initState() {
    super.initState();
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
                              height: 500,
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
                                            onPressed: () {
                                              setState(() {
                                                pressedChangeUsername = !pressedChangeUsername;
                                              });
                                            },
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(top:5),
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Icon(Icons.person, color: Colors.green,)
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 30, top:5),
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
                                                      child: Icon(
                                                        !pressedChangeUsername ? Icons.arrow_drop_down : Icons.arrow_drop_up  ,
                                                        color: Colors.black,
                                                        size: 35,)
                                                  ),
                                                ],
                                              ),
                                          ),
                                        ),
                                        if(pressedChangeUsername)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Container(
                                              height: 45,
                                              child: TextField(
                                                controller: newUsernameController,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue),
                                                    //borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                                  ),
                                                  hintText: "hintText",
                                                  hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(pressedChangeUsername)
                                          Padding(
                                              padding: const EdgeInsets.only(bottom: 15.0),
                                              child: ElevatedButton(
                                                child: Text(
                                                  "Done",
                                                  textScaleFactor: 1.5,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  elevation: 5,
                                                  shadowColor: Colors.black,
                                                ),
                                                onPressed: () {
                                                  changeUsername();
                                                },
                                              )
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
                                            onPressed: () {
                                              setState(() {
                                                pressedChangePassword = !pressedChangePassword;
                                              });
                                            },
                                            child: Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top:5),
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Icon(Icons.lock, color: Colors.green,)
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 30,top: 5),
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
                                                    child: Icon(
                                                      !pressedChangePassword ? Icons.arrow_drop_down : Icons.arrow_drop_up  ,
                                                      color: Colors.black,
                                                      size: 35,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if(pressedChangePassword)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Container(
                                              height: 45,
                                              child: TextField(
                                                controller: oldPasswordController,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue),
                                                    //borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                                  ),
                                                  hintText: "old password",
                                                  hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(pressedChangePassword)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0),
                                            child: Container(
                                              height: 45,
                                              child: TextField(
                                                controller: newPasswordController,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue),
                                                    //borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                                  ),
                                                  hintText: "new password",
                                                  hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(pressedChangePassword)
                                          Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0),
                                          child: ElevatedButton(
                                            child: Text(
                                              "Done",
                                              textScaleFactor: 1.5,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              onPrimary: Colors.black,
                                              elevation: 5,
                                              shadowColor: Colors.black,
                                            ),
                                            onPressed: () {
                                              changePassword();
                                            },
                                          )
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
                                            onPressed: () {
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                                  LoginScreen()), (Route<dynamic> route) => false);
                                            },
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