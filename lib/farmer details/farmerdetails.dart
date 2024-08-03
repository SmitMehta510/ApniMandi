import 'package:flutter/material.dart';
import 'package:admin_app/model/farmerinfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_app/model/pastorder.dart';
import 'package:admin_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/farmer details/buildpastorder.dart';
import 'package:firebase_core/firebase_core.dart';

class FarmerDetailsPage extends StatefulWidget {

  final FarmerInfo selectedFarmer;
  FarmerDetailsPage({this.selectedFarmer});

  @override
  _FarmerDetailsPageState createState() => _FarmerDetailsPageState();
}

class _FarmerDetailsPageState extends State<FarmerDetailsPage> {

  DatabaseService dbase = DatabaseService();

  List<List<PastOrder>> alldocuments =[];

  Future<void> getpastorders(){
    return Future.delayed(Duration(seconds: 0),() async{
      FirebaseApp defaultApp= Firebase.app('admin');

      FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);
      await firebaseFirestoreInstance.collection('farmerInfo').doc(widget.selectedFarmer.uid).collection('PastOrders').orderBy('DateTime',descending: true).get()
          .then((snapshot){
        snapshot.docs.forEach((element) {
          List<PastOrder> allorders = [];

          for(int i =0;i<element.data()['Order'].length; i++){
            Timestamp t= element.data()["DateTime"];
            DateTime date =t.toDate();
            String newDate= DateFormat('dd-MM-yyyy').format(date);

            PastOrder order = new PastOrder(total: element.data()['Total'],datetime: newDate,id: element.data()["Order"][i]["Id"] ,name: element.data()["Order"][i]["Name"], price: element.data()["Order"][i]["Price"],
                quantity: element.data()["Order"][i]["Quantity"], image: element.data()["Order"][i]["Image"]);

            allorders.add(order);
          }
          alldocuments.add(allorders);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpastorders().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: Text(
            'Farmer details',
            style: GoogleFonts.montserrat(
              fontSize: 25.0,
            )
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          SizedBox(height: 30.0,),
          Card(
            elevation: 10.0,
            child: Container(
              height: 160.0,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        backgroundImage: NetworkImage(widget.selectedFarmer.profileImage),
                      ),
                      SizedBox(width: 30.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Name :',
                            style: GoogleFonts.lato(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            children: [
                              SizedBox(width: 10.0,),
                              Text(
                                widget.selectedFarmer.username,
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            'Email :',
                            style: GoogleFonts.lato(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            children: [
                              SizedBox(width: 10.0,),
                              Text(
                                widget.selectedFarmer.email,
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    'Contact Details : ${widget.selectedFarmer.mobilenumber}',
                    style: GoogleFonts.montserrat(
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          alldocuments.isEmpty ? Center(
            child: Text(
              'No Past Orders found',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ) : ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                'Previous Orders',
                style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 10.0,),
              //buildPastOrders(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: alldocuments.length,
                itemBuilder: (context,index) {
                  return BuildPastOrder(index: index,mydocuments: alldocuments,);
                }
              )
            ],
          )
        ],
      ),
    );
  }
}
