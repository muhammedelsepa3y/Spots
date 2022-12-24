import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../welcome_page/welcome_page.dart';


class about_us extends StatefulWidget {

  @override
  State<about_us> createState() => _about_usState();
}

class _about_usState extends State<about_us> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text('Spots' ,style: TextStyle(color: Colors.white ),)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About Us",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),
              ),
              const SizedBox(height: 20,),

              Stack(
                children: [

                  TextField(
                    enabled: false,
                    controller: TextEditingController(text:
                    """Drive like you stole it! 
                    
Spots holds Egypt’s largest cheap car racing events that YOU can be involved in!

No huge expenses to get started, no confusing rules or restrictions.

Now you’re ready to hit the track and join in on the excitement.

Spots is not that serious and a hell of a lot of FUN!"""),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: "About Us",
                      border: OutlineInputBorder(),


                    ),



                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
