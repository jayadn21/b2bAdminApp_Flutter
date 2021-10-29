import 'dart:convert';
import 'package:untitled/DataModel.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'OpenOrders.dart';
import 'main.dart';

String? aptoken;
GetOrderItems(String token, String orderId) async {
  print("GetItems===>");
  print(selectedDataModel.Id);
  aptoken = token;
  http.Response response = await http.post(
    Uri.parse(baseUrl + '/cart/ordersItemsByOrdId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token,
    },
    body: jsonEncode(<String, String>{
      'branchid': branchId.toString(),
      'OrderId': orderId,
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
        List<OrderItemModel> ordrList = List.generate(
            orders.length,
            (index) => OrderItemModel(
                '${orders[index]["Itemid"]}',
                '${orders[index]["qty"]}',
                '${orders[index]["ItemCost"]}',
                '${orders[index]["ItemName"]}',
                '${orders[index]["UnitTypeName"]}',
                '${orders[index]["SellingPrice"]}',
                '${orders[index]["Instructions"]}',
                '${orders[index]["QtyAvailable"]}',
                '${orders[index]["ProductCode"]}',
                '${orders[index]["ItemImage"]}',
                '${orders[index]["Status"]}'));
        return ordrList;
      }
    }
  }
  return null;
}
