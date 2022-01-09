import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_monitoring_system/myPlants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Userdata {
  String userID;
  String username;
  String email;
  String password;

  Userdata(
      {required this.userID,
        required this.username,
        required this.email,
        required this.password});

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
        userID: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password']);
  }
}
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool access = false;
   String idForUser='';
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
   final String apiLoginURL =
       'https://plantmonitoringsystem5.000webhostapp.com/login.php';
  final String apiSignUpURL =
      'https://plantmonitoringsystem5.000webhostapp.com/register.php';

  void postProfileData() async {
    if(!isSignupScreen){
      var dataLogin = {'username': usernameController.text,'password': passwordController.text};


      var response = await http.post(Uri.parse(apiLoginURL), body: json.encode(dataLogin));
      var userIdResponse = await http.get(Uri.parse(apiLoginURL));

      if (userIdResponse.statusCode == 200) {
        if(userIdResponse.body.isNotEmpty) {
          access = true;
          var json = jsonDecode(userIdResponse.body);
          var idJson = json['id'];
          idForUser = idJson.toString();

        }


//         final items = json.decode(userIdResponse.body);
//         print("222222222222");
print(userIdResponse.body);
//         List<Userdata> userList = (items as List).map((data) => Userdata.fromJson(data)).toList();
// print(userList);
//          idForUser = userList[0].userID;
//          print("11111111111111111111111");
//          print(idForUser);
      } else {
        throw Exception('Failed to load data from Server.');
      }

    }
    else{
      var dataSignUp = {'username': usernameController.text,'email': emailController.text,'password': passwordController.text};
      print("signup");
      print(dataSignUp);
      var response1 = await http.post(Uri.parse(apiSignUpURL), body: json.encode(dataSignUp));
      print(response1.body);
      if (response1.statusCode == 200) {
        access = true;
      }
    }
  }

  bool isSignupScreen = false;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Planti ',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 45),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Container(
                    height: isSignupScreen ? 300 : 200,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5)
                        ]),
                    child: Column(
                      children: [
                        if (isSignupScreen) buildSignupSection(),
                        if (!isSignupScreen) buildLoginSection(),
                      ],
                    ),
                  )),
              Spacer(),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.width<MediaQuery.of(context).size.height)? MediaQuery.of(context).size.height * 0.9:MediaQuery.of(context).size.height * 1.2,
                    left: 0,
                    right: 0),
                child: ElevatedButton(
                  child: !isSignupScreen
                      ? Text(
                          "New here? Sign up",
                          textScaleFactor: 1.5,
                        )
                      : Text(
                          "Already have an account? Login",
                          textScaleFactor: 1.5,
                        ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    maximumSize: Size(350, 150),
                  ),
                  onPressed: () {
                    setState(() {
                      isSignupScreen = !isSignupScreen;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Container buildLoginSection() {
    return Container(
      child: Column(
        children: [
          buildTextField(Icons.person, "Username", false, false),
          buildTextField(Icons.lock, "Password", true, false),
          ElevatedButton(
            child: Text(
              "Login",
              textScaleFactor: 1.5,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              elevation: 5,
              shadowColor: Colors.black,
            ),
            onPressed: () {
              postProfileData();
              print("se primesc date??????????");
              print(idForUser);
              if(access)
              navigateToNextActivity(
                  context, idForUser);
              },
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        children: [
          buildTextField(Icons.person, "Username", false, false),
          buildTextField(Icons.email, "E-mail", false, true),
          buildTextField(Icons.lock, "Password", true, false),
          ElevatedButton(
            child: Text(
              "Sign Up",
              textScaleFactor: 1.5,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              elevation: 5,
              shadowColor: Colors.black,
            ),
            onPressed: () {
              postProfileData();
              if(access)
                navigateToNextActivity(
                    context, idForUser);
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: isPassword ? passwordController : isEmail? emailController : usernameController,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            icon,
            color: Colors.green,
            size: 30.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            //borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MyPlantsScreen(dataHolder)

        )
    );
  }
}
