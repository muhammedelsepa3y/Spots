

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'modules/welcome_page/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Stripe.publishableKey = '	pk_test_51LPtB4KFel8iWkwG7ElKieUKgFBBLk3fiisA3TjiyRcuUIXzZnA03XFOHFZG053a0tUr4ssl05bTAO2fB45VUxZr00abuTI3AZ';
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyCIMGBF7g-WqNPBQytQEaMLYyuf0yFljF8",
        appId: "1:394099894317:android:2c7d10755c43a271fdf0a4",
        messagingSenderId: "",
        projectId: "spots-application-msp",
        storageBucket: "spots-application-msp.appspot.com"),
  );


  runApp(const Spots_app());
}


class Spots_app extends StatefulWidget {
  const Spots_app({Key? key}) : super(key: key);

  @override
  State<Spots_app> createState() => _Spots_appState();
}

class _Spots_appState extends State<Spots_app> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

    );
  }
}
