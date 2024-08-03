import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/adminhome.dart';
import 'package:admin_app/services/database.dart';
import 'package:flutter/services.dart';
import 'package:admin_app/model/orderitems.dart';
import 'package:admin_app/model/farmerinfo.dart';
import 'package:firebase_core/firebase_core.dart';

class FarmerOrderDetailsPage extends StatefulWidget {

  final FarmerInfo selectedFarmer;
  FarmerOrderDetailsPage({this.selectedFarmer});

  @override
  _FarmerOrderDetailsPageState createState() => _FarmerOrderDetailsPageState();
}

class _FarmerOrderDetailsPageState extends State<FarmerOrderDetailsPage> {
  DatabaseService dbase = new DatabaseService();

  List<OrderItems> mysellinglist =[];

  Map<String,int> myordermap = new Map();

  Map<String,OrderItems> orderitemsmap = new Map();

  Future <void> getitemfromfarmer(){
    return Future.delayed(Duration(seconds: 0),() async{
      FirebaseApp defaultApp= Firebase.app('admin');

      FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);
      await firebaseFirestoreInstance.collection('farmerInfo').doc(widget.selectedFarmer.uid).collection('sellingitems').get()
          .then((snapshot){
        snapshot.docs.forEach((element) {
          OrderItems orderItems = new OrderItems(
              name: element.get('itemname'),id: element.get('id'),category: element.get('category'),orderquantity: element.get('orderquantity'),sellingquantity: element.get('sellingquantity'),image: element.get('image'),
              minprice: element.get('minprice'),maxprice: element.get('maxprice'),unit: element.get('unit'));
          mysellinglist.add(orderItems);
        });
      });
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getitemfromfarmer().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }


  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.green[600],
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
              widget.selectedFarmer.username,
              style: GoogleFonts.lato(
                fontSize: 30.0,
              )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                // myordermap.forEach((key, value) {
                //   dbase.addOrder(key, value);
                // });
                if(_formkey.currentState.validate()){
                  print('pass');
                  orderitemsmap.forEach((key, value) {
                    dbase.addorderitems(value, widget.selectedFarmer.uid);
                  });

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHomePage()));
                }else{
                  print('fail');
                  _showToast(context);
                }

              },
              color: Colors.white,
            )
          ],
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.transparent,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                width: screenWidth,
                child: Center(
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.selectedFarmer.profileImage),
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10.0,),
                          Container(
                            width: 100.0,
                            child: Center(
                              child: Text(
                                'Item name',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            'Selling Limit',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            'Order quantity',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formkey,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: mysellinglist.length,
                          itemBuilder: (context,index){
                            return builditemdisplay(mysellinglist[index],);
                          }
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  builditemdisplay(OrderItems orderItems,){
    return Container(
      height: 60.0,
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.black,
      //   ),
      // ),
      child: Card(
        elevation: 20.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 130.0,
              child: Center(
                child: Text(
                  orderItems.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Container(
              width: 100.0,
              child: Center(
                child: Text(
                  orderItems.sellingquantity.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 30.0,),
            Container(
              width: 80.0,
              child: TextFormField(
                validator: (value){
                  if(int.tryParse(value) > orderItems.sellingquantity){
                    return 'Wrong quantity';
                  }else{
                    return null;
                  }
                },
                initialValue: '${0}',
                textAlign: TextAlign.center,

                onChanged: (val){
                  if(_formkey.currentState.validate()){
                    OrderItems neworder = new OrderItems(
                        name: orderItems.name,category: orderItems.category,image: orderItems.image,sellingquantity: orderItems.sellingquantity,orderquantity: int.parse(val),id: orderItems.id,
                        minprice: orderItems.minprice,maxprice: orderItems.maxprice,price: orderItems.minprice,unit: orderItems.unit);

                    if(orderitemsmap.containsKey(orderItems.name)){
                      orderitemsmap.update(orderItems.name, (value) => neworder);
                    }else{
                      orderitemsmap[orderItems.name] = neworder;
                    }
                  }else{
                    _showToast(context);
                  }
                },
                cursorColor: Colors.black,
                cursorHeight: 20.0,
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        SnackBar(
          content: Text('Order quantity larger than selling limit'),
          backgroundColor: Colors.black,
          action: SnackBarAction(
            label: 'Close',
            onPressed: scaffold.hideCurrentSnackBar,
          ),
          duration: Duration(seconds: 2),
        )
    );
  }

}



