import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_monitoring_system/myPlants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Userdata {
  String userID;
  String username;
  String email;
  String password;

  Userdata({required this.userID,
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
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _formKey = GlobalKey<FormState>();
  bool access = false;
  String idForUser = '';
  String username = '';
  String password = '';
  String email = '';
  bool usernameValid = false;
  final String apiLoginURL =
      'https://plantmonitoringsystem5.000webhostapp.com/login.php';
  final String apiSignUpURL =
      'https://plantmonitoringsystem5.000webhostapp.com/register.php';

  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  void checkInputUsername() {
    if (!username.isEmpty) {
      usernameValid = true;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(setUsername);
    emailController.addListener(setEmail);
    passwordController.addListener(setPassword);
  }

  void setUsername() {
    username = usernameController.text;
  }

  void setEmail() {
    email = emailController.text;
  }

  void setPassword() {
    password = passwordController.text;
  }
  var userIdResponse ;
  void postProfileData() async {
    setUsername();
    setPassword();
    setEmail();
    if (!isSignupScreen) {
      var dataLogin = {'username': username, 'password': password};
      print("sus");
      print(username);
      if (username != null && password != null) {
        userIdResponse= await http.post(Uri.parse(apiLoginURL), body: json.encode(dataLogin));
        print("sus2");
        print(dataLogin);
        // userIdResponse = await http.get(Uri.parse(apiLoginURL));
         print("get raspuns");
         print(userIdResponse.body);

        if (userIdResponse.statusCode == 200) {
          if (userIdResponse.body.isNotEmpty) {
          access = true;
          var json = jsonDecode(userIdResponse.body);
          var idJson = json['id'];
          idForUser = idJson.toString();
          }
//         final items = json.decode(userIdResponse.body);
//         print("222222222222");
          //print(userIdResponse.body);
//         List<Userdata> userList = (items as List).map((data) => Userdata.fromJson(data)).toList();
// print(userList);
//          idForUser = userList[0].userID;
//          print("11111111111111111111111");
//          print(idForUser);
        } else {
          throw Exception('Failed to load data from Server.');
        }
      }
    } else {
      var dataSignUp = {
        'username': username,
        'email': email,
        'password': password
      };
      print("signup");
      print(dataSignUp);
      var response1 = await http.post(Uri.parse(apiSignUpURL),
          body: json.encode(dataSignUp));
      print(response1.body);
      if (response1.statusCode == 200) {
        access = true;
      }
    }
  }

  //bool isValid = false;
  bool _trySubmitForm() {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid != null)
      return isValid;
    return isValid = false;
    // if (isValid == true) {
    //   debugPrint('Everything looks good!');
    //   debugPrint(_userEmail);
    //   debugPrint(_userName);
    //   debugPrint(_password);
    //   debugPrint(_confirmPassword);
    //
    //   /*
    //   Continute proccessing the provided information with your own logic
    //   such us sending HTTP requests, savaing to SQLite database, etc.
    //   */
    // }
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
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.27),
                  child: Container(
                    height: isSignupScreen ? 400 : 300,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 5)
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        if (isSignupScreen) buildSignupSection(),
                        if (!isSignupScreen) buildLoginSection(),
                      ],
                    ),
                  )),
              Spacer(),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                    top: (MediaQuery
                        .of(context)
                        .size
                        .width <
                        MediaQuery
                            .of(context)
                            .size
                            .height)
                        ? MediaQuery
                        .of(context)
                        .size
                        .height * 0.9
                        : MediaQuery
                        .of(context)
                        .size
                        .height * 1.2,
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
      margin: EdgeInsets.only(top: 0, left: 10, right: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(Icons.person, "Username", false, false),
            SizedBox(height: 35),
            buildTextField(Icons.lock, "Password", true, false),
            SizedBox(height: 35),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Text(
                  "Login",
                  textScaleFactor: 1.5,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[500]!,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                onPressed: () {
                  _trySubmitForm;
                  if (_trySubmitForm()) {
                    postProfileData();
                    if (access) {
                      navigateToNextActivity(context, idForUser);
                      print("hmm hai sa vedem");
                      print(idForUser);
                    } else {
                      print("login section idforUser");
                      print(idForUser);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 10, right: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(Icons.person, "Username", false, false),
            SizedBox(height: 35),
            buildTextField(Icons.email, "E-mail", false, true),
            SizedBox(height: 35),
            buildTextField(Icons.lock, "Password", true, false),
            SizedBox(height: 35),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Text(
                  "Sign Up",
                  textScaleFactor: 1.5,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[500]!,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                onPressed: () {
                  _trySubmitForm;
                  if (_trySubmitForm()) {
                    postProfileData();
                    //if(access)
                    navigateToNextActivity(context, idForUser);
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail) {
    print("user: ");
    print(usernameController.text);
    print("pw: ");
    print(passwordController.text);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: isPassword
            ? passwordController
            : isEmail
            ? emailController
            : usernameController,
        obscureText: isPassword,
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
        validator: (value) {
          if (isEmail) {
            if (value == null || value
                .trim()
                .isEmpty) {
              return 'Please enter your email address';
            }
            // Check if the entered email has the right format
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            // Return null if the entered email is valid
            return null;
          };
          if (isPassword) {
            if (value == null || value
                .trim()
                .isEmpty) {
              return 'This field is required';
            }
            if (value
                .trim()
                .length < 6) {
              return 'Password must be at least 6 characters in length';
            }
            // Return null if the entered password is valid
            return null;
          } else {
            if (value == null || value
                .trim()
                .isEmpty) {
              return 'This field is required';
            }
            if (value
                .trim()
                .length < 4) {
              return 'Username must be at least 4 characters in length';
            }
            // Return null if the entered username is valid
            return null;
          }
        },

        //onChanged: (value) => _userEmail = value,
      ),

      // child: TextField(
      //   controller: isPassword ? passwordController : isEmail? emailController : usernameController,
      //   obscureText: isPassword,
      //   keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      //   inputFormatters: [
      //     FilteringTextInputFormatter.allow(
      //         RegExp("[0-9a-zA-Z]")),
      //   ],
      //   style:  TextStyle(
      //       fontSize: 15.0,
      //       color: Colors.black
      //   ),
      //   decoration: InputDecoration(
      //     fillColor: Colors.white,
      //     filled: true,
      //     prefixIcon: Icon(
      //       icon,
      //       color: Colors.green,
      //       size: 30.0,
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue),
      //       //borderRadius: BorderRadius.all(Radius.circular(35.0)),
      //     ),
      //     hintText: hintText,
      //     hintStyle: TextStyle(fontSize: 15, color: Colors.black),
      //   ),
      // ),
    );
  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyPlantsScreen(dataHolder)));
  }
}
