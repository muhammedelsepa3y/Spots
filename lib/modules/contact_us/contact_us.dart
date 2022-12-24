import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class contact_us extends StatefulWidget {

  @override
  State<contact_us> createState() => _contact_usState();
}

class _contact_usState extends State<contact_us> {
  initState(){
    super.initState();
  }
bool loading = false;

  var messageController = TextEditingController();
  var email = TextEditingController(text: '${FirebaseAuth.instance.currentUser!.email}');
  Future<void> send() async {
    setState(() {
      loading = true;
    });
    CollectionReference USERSREF = await FirebaseFirestore.instance
        .collection("ContactUs");
    var use=await USERSREF.add({
      "Email": "${email.text}",
      "Message": "${messageController.text}",
    });
    setState(() {
      loading = false;
    });
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

      body:loading?Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ): Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contact Us",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),
              ),
const SizedBox(height: 20,),

               TextField(
                controller: messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),

                ),

              ),
              const SizedBox(height: 30,),
              loginButton(
                () async {
                  await send();
                  await AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    headerAnimationLoop: false,
                    animType: AnimType.TOPSLIDE,
                    showCloseIcon: true,
                    closeIcon: const Icon(Icons.close_fullscreen_outlined),
                    title: 'Your Message Send Successfully',
                    onDissmissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                    btnOkOnPress: () {},
                  ).show();
                  Navigator.pop(context);

                },
                buttonText: "Send",
              ),



            ],
          ),
        ),
      ),
    );
  }
}

