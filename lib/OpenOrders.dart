import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/DashBoard.dart';
import 'package:untitled/push_notifications_manager.dart';
import 'DataModel.dart';
import 'NavBar.dart';
import 'OrderItemsScreen.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:fluttertoast/fluttertoast.dart';


List<dynamic> mainDataList = [];
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

void main() {
  runApp(MyApp());
}

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
      home: OpenOrders(),
    );
  }
}

class OpenOrders extends StatefulWidget {
  const OpenOrders({Key? key}) : super(key: key);

  @override
  _OpenOrdersState createState() => _OpenOrdersState();
}

class _OpenOrdersState extends State<OpenOrders> {
  String? ph;
  String? phn;
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
  Widget appBarTitle = new Text("Ecommerce Notifications",style:TextStyle(fontSize: 15),);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  intl.DateFormat dateFormat = new intl.DateFormat("dd-MM-yyyy");

  onItemChanged(String value) {
    setState(() {
      openOrderList = mainDataList
          .where((dynamic) => (dynamic.Id.toLowerCase().contains(value.toLowerCase())) || (dynamic.FullName.toLowerCase().contains(value.toLowerCase())) || (dynamic.Phone.toLowerCase().contains(value.toLowerCase())))
          .toList();
    });
  }
  late Future<dynamic> _calculation = GetOrders(apiToken);
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavBar(),
      appBar:
      new AppBar(
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                refreshList();
              },
            ),
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.arrow_back);
                    this.appBarTitle = new TextField(
                      cursorColor: Colors.white,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                      onChanged: onItemChanged,
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Ecommerce Notifications");
                    refreshList();
                  }
                });
              },
            ),
          ]),
      backgroundColor: Colors.white.withAlpha(55),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(12.0),
                    children: openOrderList.map((data) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                                  data.FullName +
                                  " " +
                                  dateFormat.format(new intl.DateFormat(
                                      "yyyy-MM-dd")
                                      .parse(data
                                      .OrderDateAndTime)), //new intl.DateFormat("yyyy/MM/dd", "en_US").parse(project[index].OrderDateAndTime)) ,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                            ),
                            subtitle: Text(
                              data.Phone +
                                  "           " +
                                  data.Id,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              selectedOrderId=data.Id;
                              selectedDataModel = data;
                              Get.to(OrderItemsApp());
                            }),
                      );
                    }).toList(),
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