

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spots_msp_project/shared/components/constants.dart';

import '../../models/events/event_model.dart';
import '../../shared/components/components.dart';
import '../enrollment/enrollment.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  String eventType;
  Events({required this.eventType});
  @override
  State<Events> createState() => _EventsState(eventType);
}

class _EventsState extends State<Events> {
  List events = [];

  bool load=false;
  List <int> enrolled=[];
  String eventType;
  var vv = Colors.grey[300];
  bool bike = false;
  _EventsState(this.eventType) {
    eventType == "Cars" ? bike = false : bike = true;
  }

  String? name;
  String? img;

  Future<void> getData() async {
    setState(() {
      load=true;
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .snapshots()
        .listen((value) {
      setState(() {
        name = value.docs[0]['Name'];
        img=value.docs[0]['Image'];
        value.docs[0]['EnrolledEvents'].forEach((element) {
          enrolled.add(element);
        });
      });

    });
  CollectionReference USERSREF = FirebaseFirestore.instance.collection("Events");
  await USERSREF.where("EventType",isEqualTo: eventType).get().then((value) {
    value.docs.forEach((element){
      setState(() {
        if(!enrolled.contains(element['EventId'])){
          events.add(element);
          events.sort((a,b)=>a['Date'].compareTo(b['Date']));
        }
      });
    });
  });



setState(() {
  load=false;
});
  }

  @override
  void initState() {
load=true;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text(
          'Spots',
          style: TextStyle(color: Colors.white),
        )),
      ),
      drawer: drawer(context, name.toString(),img.toString()),
      body:load? Center(
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
              SizedBox(
                height:10,
              ),
              Text("${eventType} Events",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
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
                      context, eventType: events[index]['EventType'],
                      isSuper: events[index]['IsSuper'],
                      Price: events[index]['Price'],
                      date: events[index]['Date'],
                      eventId: events[index]['EventId'],
                      location: events[index]['Location'],
                      photo: events[index]['Photo'],
                      border:events[index]['IsSuper']? Colors.orange:Colors.grey,
                      widg:events[index]['IsSuper']? supercb(eventType):SizedBox(),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Enrollment(events[index]['IsSuper']? Colors.orange:Colors.grey,events[index]['IsSuper']? supercb(eventType):SizedBox(),
                        eventType: events[index]['EventType'],eventId:events[index]['EventId'] , date: events[index]['Date'],
                        location: events[index]['Location'], Price: events[index]['Price'], photo: events[index]['Photo'],)));
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