import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OpenOrders.dart';
import 'OrdersClose.dart';
import 'ProflieModel.dart';
import 'main.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  _NavBarState createState() => _NavBarState();
}


class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NavBar(),
    );
  }
}


class _NavBarState extends State<NavBar> {
  @override
  String? ph;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      ph = sp.getString(ProflieModel.ph_key);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text(UserFullName),
            accountEmail: Text(phoneNumberVerified),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Simpfo_Logo.webp',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 250,
                    margin: EdgeInsets.only(right: 3),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            compName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            compAddress,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading:FaIcon(
              FontAwesomeIcons.signOutAlt,
              size: 25,
              color: Colors.black,
            ),
            title: Text('Logout'),
            onTap: () {
              SharedPreferences.getInstance().then((SharedPreferences sp) {
                sp.remove(ProflieModel.ph_key);
                Get.to(MyHomePage());
              });
            },
          ),
        ],
      ),
    );
  }
}

