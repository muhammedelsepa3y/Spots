import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../chats/chats.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

  List events = [];
  bool loading = false;
  List <int> enrolled=[];
  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .snapshots()
        .listen((value) {
      setState(() {
        value.docs[0]['EnrolledEvents'].forEach((element) {
          enrolled.add(element);
        });
      });
    });
    CollectionReference USERSREF = FirebaseFirestore.instance.collection("Events");
    await USERSREF.get().then((value) => {
      value.docs.forEach((element){
        setState(() {
          if(enrolled.contains(element['EventId'])){
            events.add(element);
          }
        });
      })});

setState(() {
  loading = false;
});


  }
  @override
  void initState() {
    // TODO: implement
    getData();
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
      body: loading?Center(
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
      ):Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:10,
              ),
              Text("My Events",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(
                height:10,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context,index)=>Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: Container(width: MediaQuery.of(context).size.width*7/10,height: 2,color: Colors.grey[300],)),
                ),
                itemBuilder: (context,index) {
                  return eventCard(
                    bt: "Chat",
                      context, eventType: events[index]['EventType'],
                      isSuper: events[index]['IsSuper'],
                      Price: events[index]['Price'],
                      date: events[index]['Date'],
                      eventId: events[index]['EventId'],
                      location: events[index]['Location'],
                      photo:events[index]['Photo'],
                      border:events[index]['IsSuper']? Colors.orange:Colors.grey,
                      widg:events[index]['IsSuper']? supercb(events[index]['EventType']):SizedBox(),
                    onPressed: () {
                      print( events[index]['EventId']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chats(
                            eventId: events[index]['EventId'],
                          ),
                        ),
                      );
                    },
                  );
                },
                itemCount: events.length,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
