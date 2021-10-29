import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/OpenOrders.dart';
import 'package:untitled/OrdersClose.dart';
import 'package:untitled/proflie.dart';
import 'package:untitled/push_notifications_manager.dart';
import 'DataModel.dart';
import 'ProflieModel.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';


List<dynamic> mainDataList = [];
List<dynamic> openOrderList =[];
List<dynamic> closeOrderList =[];
String selectedOrderId = "-1";
OrderModel selectedDataModel = OrderModel('','','','','','','','','');
late Future<dynamic> _calculation ;
DateTime? backbuttonpressedTime;

Future<Null> RefreshOrders() async{
  //await Future.delayed(Duration(seconds: 2));
  Future<dynamic> calculation = GetOrders(apiToken);
  _calculation = Future.value(calculation);
}

GetOrders(String token) async {
  http.Response response = await http.post(
    Uri.parse(baseUrl+'/cart/getOrdersOnStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token,
    },
    body: jsonEncode(<String, String>{
      'branchid': '1',
      'Status': '1',
    }),
  );
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    //success, message
    bool res = map["success"];
    String msg = map["message"];
    if (res) {
      List<dynamic> data = map["data"];
      if (data != null) {
        List<dynamic> orders = data;
        List<OrderModel> ordrList = List.generate(
            orders.length,
                (index) => OrderModel(
                '${orders[index]["Id"]}',
                '${orders[index]["Phone"]}',
                '${orders[index]["FullName"]}',
                '${orders[index]["OrderDateAndTime"]}',
                '${orders[index]["OrderCost"]}',
                '${orders[index]["OrderAddress"]}',
                '${orders[index]["Email"]}',
                '${orders[index]["EstAmt"]}',
                '${orders[index]["Status"]}'));
        return ordrList;
      }
    }
  }
  return null;
}

void main() => runApp(const MyApp());



 class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       title: 'FIY',
       theme: ThemeData(
         primarySwatch: Colors.blue,
         visualDensity: VisualDensity.adaptivePlatformDensity,
       ),
       home: DashBoard(),
     );

   }
 }


 class DashBoard extends StatefulWidget {
   const DashBoard({Key? key}) : super(key: key);

   @override
   _DashBoardState createState() => _DashBoardState();
 }

 class _DashBoardState extends State<DashBoard> {
   @override
   void initState() {
     PushNotificationsManager().init();
     super.initState();
     getPostsData();
     GetOrders(apiToken);
     setState(() {});
   }

   getPostsData() async {
     openOrderList = await GetOrders(apiToken);
     setState(()  {
       mainDataList = openOrderList;
     });
   }
   int currentIndex = 0;
   Widget appBarTitle = new Text("Ecommerce Notifications");
   Icon actionIcon = new Icon(Icons.search);

   setBottomBarIndex(index) {
     setState(() {
       currentIndex = index;
     });
   }
   Future<Null> refreshList() async{
     //await Future.delayed(Duration(seconds: 2));
     getPostsData();
   }
   Future<bool> onWillPop() async {
     DateTime currentTime = DateTime.now();

     //Statement 1 Or statement2
     bool DashBoard = backbuttonpressedTime == null ||
         currentTime.difference(backbuttonpressedTime!) > Duration(seconds: 3);

     if (DashBoard) {
       backbuttonpressedTime = currentTime;
       Fluttertoast.showToast(
           msg: "Double Click to exit app",
           backgroundColor: Colors.black,
           textColor: Colors.white);
       return false;
     }
     exit(0);
     return true;
   }


   int _selectedIndex = 0;
   static const TextStyle optionStyle =
   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
   static const List<Widget> _widgetOptions = <Widget>[
     OpenOrders(),
     OrdersClose(),
     Proflie(),

   ];

   void _onItemTapped(int index) {
     setState(() {
       _selectedIndex = index;
     });
   }
   onItemChanged(String value) {
     setState(() {
       openOrderList = mainDataList
           .where((dynamic) => (dynamic.Id.toLowerCase().contains(value.toLowerCase())) || (dynamic.FullName.toLowerCase().contains(value.toLowerCase())) || (dynamic.Phone.toLowerCase().contains(value.toLowerCase())))
           .toList();
     });
   }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white.withAlpha(55),
       body: Center(
         child: _widgetOptions.elementAt(_selectedIndex),
       ),
       bottomNavigationBar: BottomNavigationBar(
         items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(
           icon: Badge(child:FaIcon(FontAwesomeIcons.cartArrowDown,size: 25,),
               badgeContent: Text(
                   openOrderList.length.toString(), style: TextStyle(color: Colors.white,fontSize: 10)),),
           label:"Open",
           backgroundColor: Colors.blueAccent,
           ),
           BottomNavigationBarItem(
             icon: Badge(child:FaIcon(FontAwesomeIcons.checkCircle,size: 25,),
               badgeContent: Column(
                 children: [
                   Text(
                       closeOrderList.length.toString(), style: TextStyle(color: Colors.white,fontSize: 10)),
                   WillPopScope(
                     onWillPop: onWillPop,
                     child: Center(
                     ),
                   ),
                 ],
               ),),
             label:"Closed",
             backgroundColor: Colors.blueAccent,
           ),

           BottomNavigationBarItem(
             icon: FaIcon(FontAwesomeIcons.user,
                 size: 25),
             label: 'Profile',
             backgroundColor: Colors.blueAccent,
           ),
         ],
         currentIndex: _selectedIndex,
         selectedItemColor: Colors.blue,
         onTap: _onItemTapped,
       ),
     );
   }
 }


