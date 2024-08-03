import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/model/farmerinfo.dart';
import 'package:admin_app/farmer details/farmerorderdetails.dart';
import 'package:firebase_core/firebase_core.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {

  List<FarmerInfo> myfarmerlist =[];


  Future<void> getfarmersdata(){
    return Future.delayed(Duration(seconds: 0),() async{
      FirebaseApp defaultApp= Firebase.app('admin');

      FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);
      await firebaseFirestoreInstance.collection('farmerInfo').get().then((snap){
        snap.docs.forEach((element) {

          FarmerInfo info = new FarmerInfo(
            username: element.get('username'),profileImage: element.get('profileImage'),uid: element.id,email: element.get('email'),mobilenumber: element.get('mobilenumber'),
          );
          myfarmerlist.add(info);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfarmersdata().whenComplete((){
      setState(() {
        build(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Farmers List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: myfarmerlist.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FarmerOrderDetailsPage(selectedFarmer: myfarmerlist[index],)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                    color: Colors.white,
                    elevation: 10.0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(myfarmerlist[index].profileImage),
                            radius: 40.0,
                          ),
                          SizedBox(width: 30.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myfarmerlist[index].username,
                                style: GoogleFonts.b612(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0,),
                              Text(
                                myfarmerlist[index].email,
                                style: GoogleFonts.b612(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.0,),
                        ],
                      ),
                    )
                ),
              ),
            );
          }
      ),
    );
  }
}
