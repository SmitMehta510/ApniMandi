import 'package:admin_app/admindrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Admin Home',
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
          ),
        ),
        // actions: [
        //   TextButton.icon(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.person,
        //       color: Colors.white,
        //     ),
        //     label: Text(
        //       'Logout',
        //       style: GoogleFonts.montserrat(
        //         fontSize: 15.0,
        //         color: Colors.white,
        //       ),
        //     ),
        //   )
        // ],
      ),
      drawer: AdminDrawerPage(),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: GoogleFonts.montserrat(
                fontSize: 40.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Apni Mandi',
              style: GoogleFonts.montserrat(
                fontSize: 40.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Admin Home',
              style: GoogleFonts.montserrat(
                fontSize: 30.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
      )
    );
  }
}
