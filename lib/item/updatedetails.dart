import 'package:flutter/material.dart';
import 'package:admin_app/services/database.dart';
import 'package:admin_app/model/item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/shared/loading.dart';
import 'package:admin_app/adminhome.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';

class UpdateDetails extends StatefulWidget {

  final Item item;
  UpdateDetails({this.item});

  @override
  _UpdateDetailsState createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {

  DatabaseService dbase = DatabaseService();

  List<String> mycategories =[];


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

  List<String> unitslist =[];

  Future<void> getunitslist(){
    return Future.delayed(Duration(seconds: 0),() async{
      await FirebaseFirestore.instance.collection('units').get().then((snap){
        snap.docs.forEach((element) {
          String string  = element.get('unit');
          unitslist.add(string);
        });
      });
    });
  }

  String docid;

  Future<void> getdocid(){
    return Future.delayed(Duration(seconds: 0),() async{
      await FirebaseFirestore.instance.collection('items').where('id' , isEqualTo: widget.item.id).get().then((snap){
        docid = snap.docs.first.id;
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

    getdocid().whenComplete((){
      setState(() {
        build(context);
      });
    });

    getunitslist().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }


  final _formkey = GlobalKey<FormState>();

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();



  String name;
  int maxprice;
  int minprice;
  int sellingprice;
  String image ;
  String category;
  int quantity;
  String description;
  String unit;

  @override
  Widget build(BuildContext context) {

    return mycategories.isEmpty ? Loading(): Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Update item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
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
                        backgroundImage: _imageFile ==null? NetworkImage(widget.item.image):FileImage(File(_imageFile.path)),
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
                      )
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                      height: 40.0,
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
                            'Id : ${widget.item.id}',
                            style: GoogleFonts.b612(
                              fontSize: 20.0,
                            ),
                          )
                      )
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    readOnly: true,
                    initialValue: widget.item.name,
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
                          initialValue: widget.item.sellingprice.toString(),
                          validator: (val){
                            if(val.isEmpty){
                              return "Please enter selling price";
                            }else{
                              return null;
                            }
                          },
                          decoration: textInputDecoration.copyWith(hintText: 'Enter selling price',labelText: 'Selling price'),
                          onChanged: (val){
                            sellingprice = int.tryParse(val) ?? 0;
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
                          value : widget.item.unit,
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
                    initialValue: widget.item.minprice.toString(),
                    validator: (val){
                      if(val.isEmpty){
                        return "Please enter minimum buying price";
                      }else{
                        return null;
                      }
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'Enter minimum buying price', labelText: 'Minimum buying price'),
                    onChanged: (val){
                      minprice = int.tryParse(val) ?? 0;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    initialValue: widget.item.maxprice.toString(),
                    validator: (val){
                      if(val.isEmpty){
                        return "Please enter maximum buying price";
                      }else{
                        return null;
                      }
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'Enter maximum buying price', labelText: 'Maximum buying price'),
                    onChanged: (val){
                      maxprice = int.tryParse(val) ?? 0;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    initialValue: widget.item.totalquantity.toString(),
                    validator: (val){
                      if(val.isEmpty){
                        return "Please enter quantity";
                      }else{
                        return null;
                      }
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'Enter available quantity',labelText: 'Quantity'),
                    onChanged: (val){
                      quantity = int.tryParse(val) ?? 0;
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
                      value : widget.item.category,
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
                    minLines: 4,
                    initialValue: widget.item.description,
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () async {
                      if(_formkey.currentState.validate()){
                        Item item = new Item(
                            name: name ?? widget.item.name,
                            sellingprice: sellingprice ?? widget.item.sellingprice,
                            maxprice: maxprice ?? widget.item.maxprice,
                            minprice: minprice ?? widget.item.minprice,
                            category: category ?? widget.item.category,
                            image: image ?? widget.item.image,
                            totalquantity: quantity ?? widget.item.totalquantity,
                            id: widget.item.id,
                            description: description ?? widget.item.description,
                            unit: unit ?? widget.item.unit
                        );
                        dbase.updateitem(item, docid);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHomePage()));
                      }
                    },
                    child: Text(
                      'Update Item',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
              TextButton.icon(
                  onPressed: (){
                    takeImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera')
              ),
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
    Navigator.of(context).pop();
  }
}
