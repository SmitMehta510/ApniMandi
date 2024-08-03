import 'package:admin_app/item/additem.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/item/updateitem.dart';
import 'package:admin_app/farmer details/displayfarmers.dart';
import 'package:admin_app/farmer details/viewfarmerslist.dart';

class AdminDrawerPage extends StatefulWidget {
  @override
  _AdminDrawerPageState createState() => _AdminDrawerPageState();
}

class _AdminDrawerPageState extends State<AdminDrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300.0,
      child: ListView(
        children: [
          Container(
              height: 100.0,
              color: Colors.green,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                                  ],
              )
          ),
          ListTile(
            title: Text('Add new item'),
            leading: Icon(Icons.add_sharp),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddItem()));
            },
          ),
          ListTile(
            title: Text('Update an item'),
            leading: Icon(Icons.update_sharp),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateItemPage()));
            },
          ),
          ListTile(
            title: Text('Add Farmer orders'),
            leading: Icon(Icons.edit_outlined),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayPage()));
            },
          ),
          ListTile(
            title: Text('View Farmers'),
            leading: Icon(Icons.remove_red_eye_sharp),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewFarmersPage()));
            },
          ),
          // ListTile(
          //   title: Text('View Reports'),
          //   leading: Icon(Icons.report),
          //   onTap: (){
          //     Navigator.of(context).pop();
          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportHome()));
          //   },
          // ),
          // ListTile(
          //   title: Text('Logout'),
          //   leading: Icon(Icons.logout),
          //   onTap: (){
          //
          //   },
          // )
        ],
      ),
    );
  }
}
