import 'package:flutter/material.dart';
import 'package:admin_app/services/database.dart';
import 'package:admin_app/model/item.dart';
import 'package:admin_app/shared/loading.dart';
import 'package:admin_app/item/updatedetails.dart';

class UpdateItemPage extends StatefulWidget {
  @override
  _UpdateItemPageState createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Item List',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: builditemlist(),
    );
  }

  Widget builditemlist(){
    return StreamBuilder<List<Item>>(
        stream: DatabaseService().items,
        builder: (context, snapshot) {
          if(snapshot.hasData){

            List<Item> items = snapshot.data;

            items.sort((a,b) => a.id.compareTo(b.id));

            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0) ,
                itemCount: items.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateDetails(item: items[index],)));
                    },
                    child: Card(
                      elevation: 10.0,
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.green,
                          backgroundImage: NetworkImage(items[index].image),
                        ),
                        title: Text(
                          items[index].name,
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                                'Quantity :'
                            ),
                            SizedBox(width: 10.0,),
                            Text(
                                items[index].totalquantity.toString()
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }else{
            return Loading();
          }
        }
    );
  }
}
