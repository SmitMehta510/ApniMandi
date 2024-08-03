import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_app/model/item.dart';
import 'package:admin_app/model/orderitems.dart';

class DatabaseService{

  final CollectionReference itemscollection = FirebaseFirestore.instance.collection('items');

  final CollectionReference farmerInfo = FirebaseFirestore.instance.collection('farmerInfo');


  //return items as list from database
  List<Item> _itemListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Item(
        name: doc.data()['name'] ?? 'New Item',
        minprice: doc.data()['minprice'] ?? '0',
        maxprice: doc.data()['maxprice'] ?? '0',
        totalquantity: doc.data()['totalquantity'] ?? '0',
        image: doc.data()['image'] ?? '',
        category: doc.data()['category'] ?? '',
        id: doc.data()['id'],
        sellingprice: doc.data()['sellingprice'],
        description: doc.data()['description'],
        unit: doc.data()['unit'],
      );
    }).toList();
  }

  //get items stream
  Stream<List<Item>> get items{
    return itemscollection.snapshots().map(_itemListFromSnapshot);
  }


  // Admin functions

  Future<void> addItem(Item item) async{
    return itemscollection.add({
      'id' : item.id,
      'name' : item.name,
      'minprice' : item.minprice,
      'maxprice' :item.maxprice,
      'sellingprice': item.sellingprice,
      'image': item.image,
      'category' : item.category,
      'totalquantity' : item.totalquantity,
      'description' : item.description,
      'unit' : item.unit,
    });
  }

  // Update an item details in database
  Future<void> updateitem(Item item, String docid){
    return itemscollection.doc(docid).update({
      'id' : item.id,
      'name' : item.name,
      'minprice' : item.minprice,
      'maxprice' :item.maxprice,
      'sellingprice': item.sellingprice,
      'image': item.image,
      'category' : item.category,
      'totalquantity' : item.totalquantity,
      'description' : item.description,
      'unit' : item.unit,
    });
  }

  // add order items (after admin has assigned orders)
  Future<void> addorderitems(OrderItems orderItems, String uid) async{
    return await farmerInfo.doc(uid).collection('orders').add({
      'itemname' : orderItems.name,
      'sellingquantity' : orderItems.sellingquantity,
      'id' : orderItems.id,
      'category': orderItems.category,
      'orderquantity' : orderItems.orderquantity,
      'image' : orderItems.image,
      'minprice' : orderItems.minprice,
      'maxprice' : orderItems.maxprice,
      'price' : orderItems.price,
      'unit' : orderItems.unit,
    });
  }

}