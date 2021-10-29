import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/DashBoard.dart';
import 'package:untitled/OpenOrders.dart';
import 'package:untitled/main.dart';
import 'ProflieModel.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
String _versionName = 'V1.0';
final splashDelay = 5;
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    SharedPreferences sharedPreferences;
    String ph;
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      if (sp.containsKey(ProflieModel.ph_key) && sp.getString(ProflieModel.ph_key)!.length >0) {
        //in this case the app is already installed, so we need to redirect to landing screen
        ph = sp.getString(ProflieModel.ph_key)!;
        phoneNumberVerified = ph;
        var phn = phoneNumberVerified.substring(3);
        bool res = await Login(context, phn);
        Timer(Duration(seconds: 5),
                () => Get.to(res ? DashBoard() : MyHomePage()));
      } else {
        //in this case the app is installed newly or user signed out, so we need to redirect to signup page
        Get.to(MyHomePage());
      }
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/loading.gif',
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Ecommerce",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 22.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/Simpfologo.png',width: 150,height: 150,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}