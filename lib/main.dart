import 'package:admin_app/adminhome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp defaultApp= await Firebase.initializeApp(name: "admin",
      options: FirebaseOptions(
        appId: '1:567448421858:android:a1c1327a4c580dda9ba5bb',
        apiKey: 'AIzaSyArQ6634xxRE1t1jBjR5twNzKscopOkiOg',
        projectId: 'test-apnimandi',
        messagingSenderId: '567448421858',
      )
  );

  List<FirebaseApp> apps=Firebase.apps;

  apps.forEach((app) {
    print('AppName:  ${app.name}');

  });


  FirebaseFirestore firebaseFirestoreInstance= FirebaseFirestore.instanceFor(app: defaultApp);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminHomePage(),
    );
  }
}