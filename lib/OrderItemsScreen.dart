import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'DashBoard.dart';
import 'DataModel.dart';
import 'NavBar.dart';
import 'OpenOrders.dart';
import 'apiServices.dart';
import 'main.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


closeOrders(BuildContext context, String token) async {
  http.Response response = await http.post(
    Uri.parse(baseUrl + '/cart/updteSingleOrderStatusAndGenerateBill'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token,
    },
    body: jsonEncode(<String, String>{
      'OrderId': selectedOrderId,
      'Status': '5',
    }),
  );

  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    //success, message
    bool res = map["success"];
    String msg = map["message"];
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Order Close Sucessfully"),
          backgroundColor: Colors.indigoAccent,
          padding: EdgeInsets.all(20),
          shape: StadiumBorder()));
      Get.to(OpenOrders());
    }
  }
  return null;
}

class OrderItemsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final CategoriesScroller categoriesScroller = CategoriesScroller(
    dataModel: selectedDataModel,
  );
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );

  List<Widget> itemsData = [];

  void getPostsData() async {
    List<dynamic> responseList = await GetOrderItems(apiToken,selectedDataModel.Id); //FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      print("getPostsData ===>");
      print(post.ItemName);

      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Expanded(
                        child: Text(
                          post.ItemName,

                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          post.qty + " " + post.UnitTypeName,
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Text(
                          "\₹ ${post.ItemCost}",
                          style: const TextStyle(fontSize: 19, color: Colors.grey),
                        ),
                      ],
                    ),


                  ],
                ),
                Container(
                    width: 90,
                    height: 100,
                    child: Image.network(
                      post.ItemImage,
                    ),
                  ),

              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }


  Widget appBarTitle = new Text("Ecommerce Notifications");
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    print("Order Status===>");
    print(selectedDataModel.Status);
    return Scaffold(
      drawer: NavBar(),
      appBar: new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[],
      ),
      body: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Visibility(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: Colors.blue),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Closing Order'),
                          content:
                              const Text("Do you really want to close the order"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () => closeOrders(context, apiToken),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Close Order'),
                  ),
                  visible: (selectedDataModel.Status == '1') ? true : false,
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: size.width,
                  alignment: Alignment.topCenter,
                  child: categoriesScroller),
            ),
            Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;

                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}


class CategoriesScroller extends StatelessWidget {
  _callNumber() async {
    var number = selectedDataModel.Phone; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  final OrderModel dataModel;
  const CategoriesScroller({Key? key, required this.dataModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                Container(
                  width: 130,
                  margin: EdgeInsets.only(right: 3),
                  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.cartArrowDown,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Id",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              selectedDataModel.Id,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OrderDate: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              new DateFormat("dd-MM-yyyy hh:mm a").format(
                                  new intl.DateFormat(
                                          "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
                                      .parse(
                                          selectedDataModel.OrderDateAndTime,true).toLocal()),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OrderCost: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              selectedDataModel.OrderCost + "₹",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  margin: EdgeInsets.only(right: 3),
                  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.addressCard,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Full Name: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                selectedDataModel.FullName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PhoneNo: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              InkWell(
                                child: Text(
                                  selectedDataModel.Phone,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: _callNumber,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                selectedDataModel.Email,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  margin: EdgeInsets.only(right: 20),
                  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.home,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "OrderAddress: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                selectedDataModel.OrderAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
