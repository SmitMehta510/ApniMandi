import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:admin_app/services/database.dart';
import 'package:admin_app/model/item.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/loading.dart';
import 'package:admin_app/adminhome.dart';
import 'package:firebase_core/firebase_core.dart';

class AddItem extends StatefulWidget {

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  //get category list from firebase
  List<String> mycategories =[];

  List<String> unitslist =[];

  List<Item> items = [];

  Future<void> getcategorylist(){
    return Future.delayed(Duration(seconds: 0),() async{
      FirebaseApp defaultApp= Firebase.app('admin');

      FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);

      await firebaseFirestoreInstance.collection('categories').get().then((snap){
        snap.docs.forEach((element) {
          String newstring  = element.get('category');
          mycategories.add(newstring);
        });
      });
    });
  }

  Future<void> getunitslist(){
    return Future.delayed(Duration(seconds: 0),() async{
      FirebaseApp defaultApp= Firebase.app('admin');

      FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);
      await firebaseFirestoreInstance.collection('units').get().then((snap){
        snap.docs.forEach((element) {
          String string  = element.get('unit');
          print(string);
          unitslist.add(string);
        });
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcategorylist().whenComplete((){
      setState(() {
        build(context);
      });
    });
    getunitslist().whenComplete((){
      setState(() {
        build(context);
      });
    });
  }

  final _formkey = GlobalKey<FormState>();
  DatabaseService dbase = DatabaseService();

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();


  int id ;
  String name;
  int maxprice;
  int minprice;
  int sellingprice;
  String itemimage = 'https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png';
  String category;
  int quantity;
  String description;
  String unit;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Add new item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<Item>>(
          stream: DatabaseService().items,
          builder: (context, snapshot) {

            if(snapshot.hasData) {
              List<Item> items = snapshot.data;

              id = items.length + 1;

              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 70.0,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: _imageFile ==null? NetworkImage(itemimage):FileImage(File(_imageFile.path)),
                              ),
                              Positioned(
                                  left: 90.0,
                                  top: 90.0,
                                  child: IconButton(
                                    iconSize: 40.0,
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.teal,
                                    onPressed: (){
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder)=>buildBottomSheet());
                                    },
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                              height: 50.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                  child: Text(
                                    'Id : $id',
                                    style: GoogleFonts.b612(
                                      fontSize: 20.0,
                                    ),
                                  )
                              )
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            validator: (val){
                              if(val.isEmpty){
                                return "Please enter name";
                              }else{
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(hintText: 'Enter name of the item',labelText: 'Item Name'),
                            onChanged: (val){
                              name = val;
                            },
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                width: 200.0,
                                child: TextFormField(
                                  validator: (val){
                                    if(val.isEmpty){
                                      return "Please enter selling price";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: textInputDecoration.copyWith(hintText: 'Enter selling price',labelText: 'Selling price'),
                                  onChanged: (val){
                                    sellingprice = int.parse(val);
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.0,),
                              Container(
                                width: 140.0,
                                height: 58.0,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                      color: Colors.grey,
                                    )
                                ),
                                child: DropdownButtonFormField(
                                  hint: Text('Select Unit'),
                                  isExpanded: true,
                                  value : unit,
                                  onChanged: (val){
                                    print(val);
                                    setState(() {
                                      unit = val;
                                    });
                                  },
                                  items: unitslist.map((val){
                                    return DropdownMenuItem(
                                        value:  val,
                                        child: Text(val)
                                    );
                                  }).toList(),
                                  validator: (val){
                                    if(val == null){
                                      return "Please select unit";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            validator: (val){
                              if(val.isEmpty){
                                return "Please enter minimum buying price";
                              }else{
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(hintText: 'Enter minimum buying price', labelText: 'Minimum buying price'),
                            onChanged: (val){
                              minprice = int.parse(val);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            validator: (val){
                              if(val.isEmpty){
                                return "Please enter maximum buying price";
                              }else{
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(hintText: 'Enter maximum buying price',labelText: 'Maximum buying price'),
                            onChanged: (val){
                              maxprice = int.parse(val);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            validator: (val){
                              if(val.isEmpty){
                                return "Please enter quantity";
                              }else{
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(hintText: 'Enter available quantity',labelText: 'Quantity'),
                            onChanged: (val){
                              quantity = int.parse(val);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                  color: Colors.grey,
                                )
                            ),
                            child: DropdownButtonFormField(
                              hint: Text('Select Category'),
                              isExpanded: true,
                              value : category,
                              onChanged: (val){
                                print(val);
                                setState(() {
                                  category = val;
                                });
                              },
                              items: mycategories.map((val){
                                return DropdownMenuItem(
                                    value:  val,
                                    child: Text(val)
                                );
                              }).toList(),
                              validator: (val){
                                if(val == null){
                                  return "Please select category";
                                }else{
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (val){
                              if(val.isEmpty){
                                return "Please enter description";
                              }else{
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(hintText: 'Enter description for item',labelText: 'Item Description'),
                            onChanged: (val){
                              description = val;
                            },
                          ),
                          SizedBox(height: 20.0,),
                          ElevatedButton(
                            onPressed: () async {
                              if(_formkey.currentState.validate()){

                                Item item = new Item(name: name,sellingprice: sellingprice,maxprice: maxprice,minprice: minprice,
                                    id:id,category: category,image: itemimage,totalquantity: quantity,description: description,unit: unit
                                );
                                dbase.addItem(item);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHomePage()));
                              }
                            },
                            child: Text(
                              'Add Item',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }else{
              return Loading();
            }

          }
      ),
    );
  }

  Widget buildBottomSheet(){
    return Container(
      height: 100.0,
      child: Column(
        children: [
          Text(
            'Choose image from..',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextButton.icon(
              //     onPressed: (){
              //       takeImage(ImageSource.camera);
              //     },
              //     icon: Icon(Icons.camera_alt),
              //     label: Text('Camera')
              // ),
              TextButton.icon(
                  onPressed: (){
                    takeImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')
              ),
            ],
          )
        ],
      ),
    );
  }

  void takeImage(ImageSource source) async{
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
    uploadtostorage(_imageFile);
    Navigator.of(context).pop();
  }

  void uploadtostorage(PickedFile image) async{

    final _storage = FirebaseStorage.instance;
    var file = File(image.path);
    if(image != null){
      var snapshot = await _storage.ref().child('Item Images/${DateTime.now()}').putFile(file);

      var path = await snapshot.ref.getDownloadURL();

      print(path);

      setState(() {
        itemimage = path;
      });

      print(itemimage);

    }else{
      print('path not found');
    }
  }
}
