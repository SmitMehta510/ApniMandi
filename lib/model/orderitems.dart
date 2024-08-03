class OrderItems{

  final int id;
  final String name;
  final int orderquantity;
  final int sellingquantity;
  final String image;
  final String category;
  final int minprice;
  final int maxprice;
  final int price;
  final String unit;

  OrderItems({this.name,this.orderquantity,this.image,this.category,this.id, this.sellingquantity,this.maxprice,this.minprice,this.price,this.unit});
}