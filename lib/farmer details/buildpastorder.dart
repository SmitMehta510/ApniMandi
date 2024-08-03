import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/model/pastorder.dart';

class BuildPastOrder extends StatefulWidget {

  List<List<PastOrder>> mydocuments ;
  int index;

  BuildPastOrder({this.mydocuments,this.index});

  @override
  _BuildPastOrderState createState() => _BuildPastOrderState();
}

class _BuildPastOrderState extends State<BuildPastOrder> {

  bool showdetails = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          //width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 290.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order: ${widget.index +1}',
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                          ),
                        ),
                        showdetails == true?Text(
                          'Date : ${widget.mydocuments[widget.index][widget.index].datetime}',
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                          ),
                        ):
                        Text(
                          'Amount = ${widget.mydocuments[widget.index][widget.index].total}',
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: (){
                        setState(() {
                          showdetails = !showdetails;
                        });
                      }
                  )
                ],
              ),
              showdetails == false ? SizedBox() :
              Column(
                children: [
                  buildPastOrdersList(widget.mydocuments[widget.index]),
                  Divider(thickness: 4.0,indent: 155.0,endIndent: 25.0,),
                  Container(
                    width: 275.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total =  ${widget.mydocuments[widget.index][widget.index].total}',
                          style: GoogleFonts.lato(
                            fontSize: 25.0,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  buildPastOrdersList(List<PastOrder> order){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: order.length,
      itemBuilder: (context,secIndex){
        return Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10.0,),
                  Container(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(order[secIndex].image),
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Container(
                    width: 15.0,
                    child: Text(
                        'X',
                        style: GoogleFonts.aladin(
                          fontSize: 20.0,
                        )
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Container(
                    width: 50.0,
                    child: Center(
                      child: Text(
                        order[secIndex].quantity.toString(),
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Container(
                    width: 60.0,
                    child: Text(
                      '@ ${order[secIndex].price} ',
                      style: GoogleFonts.lato(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    '=  ${order[secIndex].quantity * order[secIndex].price}',
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        );
      }
    );
  }

}
