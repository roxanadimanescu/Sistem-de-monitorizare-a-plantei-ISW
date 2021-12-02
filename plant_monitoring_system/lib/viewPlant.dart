import 'package:flutter/material.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

class ViewPlantScreen extends StatefulWidget {
  @override
  _ViewPlantState createState() => _ViewPlantState();
}

class _ViewPlantState extends State<ViewPlantScreen> {
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 140,
                    //margin: EdgeInsets.only(top: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                              iconSize: 50,
                              color: Colors.grey,
                              splashColor: Colors.purple,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),

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
                        Spacer(),

                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropCapText(
                          'Cactusii sunt plante cu tulpini suculente de forma cilindrica, globuloasa, ovoidala, ovala, turtita. Lungimea lor masoara de la cativa centimetri la 20-30 m, in tara de origine.Frunzele sunt transformate in spini. Pe suprafata tulpinii se afla numerosi muguri care la cactusi se numesc areole. Din areole iau nastere spinii, florile, ramificatiile laterale.',
                          style: TextStyle(
                              fontSize: 20.0, height: 1.1, color: Colors.white),
                          dropCap: DropCap(
                            width: 200,
                            height: 200,
                            child: Image.asset("assets/images/bg.jpg"),
                          ),
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
  }
}
