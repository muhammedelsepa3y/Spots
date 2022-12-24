import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../models/chat_model/chat.dart';
import '../welcome_page/welcome_page.dart';

import 'package:cached_network_image/cached_network_image.dart';

class chat extends StatefulWidget {
  String name;
  List<messagesss> chatContent = [];
  String photo;
  String UID;
  chat({required this.name, required this.photo, required this.UID});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  bool load = false;
  ScrollController listScrollController = ScrollController();
  initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage('${widget.photo}'),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.name}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                    child: load
                        ? Center(
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('Messages')
                                .doc(widget.UID)
                                .collection('chats')
                                .orderBy("Time", descending: true)

                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  reverse: true,
                                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  itemBuilder: (context, index) {
                                    bool fromcurrent = (snapshot.data! as QuerySnapshot).docs[index]['MSID'] == FirebaseAuth.instance.currentUser?.uid;
                                    return Row(
                                      mainAxisAlignment: fromcurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                              top: 10,
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: (fromcurrent?Colors.blue[200]:Colors.grey.shade200),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              (snapshot.data! as QuerySnapshot).docs[index]['content'],

                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 6, bottom: 6, top: 6, right: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                ),
                width: double.infinity,
                child: Form(
                  key: formkey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              hintText: "Write a message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          send();
                        },
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String serverToken = 'AAAAYnp4SWM:APA91bFgPZdvQG6JUng7Cl1fwTDrlBpISPtmxYb85rMTnvWo2MN-I34siQ_akArl0KuLgdQvdPRwCNZ6_IhlHzrjQxibpvDv5uNzZHvGban9DPtZfClquRNGiXnpV-09ZNgncBZLWEe0';


   sendAndRetrieveMessage(String name,String message,String time,String targetToken) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'You have a new message from $name',
            'title': 'Spots'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            "message": message,
            'name': name,
            'time': time,
          },
          'to': targetToken,
        },
      ),
    );
  }
  send() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        load = true;
      });




      String message = messageController.text;


      messageController.clear();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Messages')
          .doc(widget.UID)
          .collection('chats')
          .add({
        "MSID": FirebaseAuth.instance.currentUser?.uid,
        "MRID": widget.UID,
        "content": message,
        "Time": DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.UID)
          .collection('Messages')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("chats")
          .add({
        "MSID": FirebaseAuth.instance.currentUser?.uid,
        "MRID": widget.UID,
        "content": message,
        "Time": DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
      });
      notif()async{
        var n;
        await FirebaseFirestore.instance
            .collection("Users")
            .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
            .snapshots()
            .listen((value) {
          setState(() {
            n = value.docs.first['Name'];
          });
        });
        var t;
        await FirebaseFirestore.instance
            .collection("Users")
            .where("userid", isEqualTo: widget.UID)
            .snapshots()
            .listen((value) {
          setState(() {
            t = value.docs.first['Token'];
          });
        });
        sendAndRetrieveMessage(n, message, DateTime.now().toString(), t);
      }
      setState(() {
        load = false;
        notif();
      });


    }
  }

}
