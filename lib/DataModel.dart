class DataModel{
   late final String name, phone_number,orderid,orderdate;

   DataModel(this.name,this.phone_number,this.orderid,this.orderdate);
}

class OrderModel{
 final String Id,Phone,FullName,OrderDateAndTime,OrderCost,OrderAddress,Email,EstAmt,Status;

OrderModel(this.Id,this.Phone,this.FullName,this.OrderDateAndTime,this.OrderCost,this.OrderAddress,this.Email,this.EstAmt,this.Status);
}
class OrderItemModel{
  final String Itemid,qty,ItemCost,ItemName,UnitTypeName,SellingPrice,Instructions,QtyAvailable,ProductCode,ItemImage,Status;
  OrderItemModel(this.Itemid,this.qty,this.ItemCost,this.ItemName,this.UnitTypeName,this.SellingPrice,this.Instructions,this.QtyAvailable,this.ProductCode,this.ItemImage,this.Status);
}