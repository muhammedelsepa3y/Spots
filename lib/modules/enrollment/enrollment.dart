import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../welcome_page/welcome_page.dart';
import 'racer/racer.dart';
import 'viewer/viewer.dart';



class Enrollment extends StatefulWidget {
  String eventType;
  int eventId;
  String location;
  String date;
  String photo;
  int Price;

  Color border; Widget? widg;
  Enrollment(this.border, this.widg, {required this.eventType,required this.eventId,required this.location,required this.date,required this.Price,required this.photo});
  @override
  State<Enrollment> createState() => _EnrollmentState(border,widg,eventType: eventType,eventId: eventId,location: location,date: date,Price: Price,photo: photo,);
}

class _EnrollmentState extends State<Enrollment> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  String eventType;
  int eventId;
  String location;
  String date;
  int Price;
  String photo;

bool viewer=false;


  Color border;Widget? widg;
_EnrollmentState( this.border,this.widg ,  {required this.eventType,required this.eventId,required this.location,required this.date,required this.Price,required this.photo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Center(
            child: Text('Spots' ,style: TextStyle(color: Colors.white ),)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Booking",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),
                ),
              ),
const SizedBox(
                height: 25,
              ),
              const Text(
                "You will Book in this event",
                style: TextStyle(fontSize: 16,),
              ),
              const SizedBox(
                height: 10,
              ),
              eventCard(context,eventType:  eventType, eventId: eventId,location:  location,date:  date, Price: Price, photo: photo, border:border ,widg: widg),
              const SizedBox(
                height: 25,
              ),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          viewer=true;
                        });
                      },
                      child: Column(
                        children: [
                          const Text("As a Viewer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                          const SizedBox(height: 6,),
                          Container(width: 200,height: 2,color: viewer?Colors.blue:Colors.grey[300],)


                        ],
                      ),
                    ),
                  ),
const SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          viewer=false;
                        });
                      },
                      child: Column(
                        children: [
                          const Text("As a Racer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                          const SizedBox(height: 4,),
                          Container(width: 200,height: 2,color: viewer?Colors.grey[300]:Colors.blue,)



                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // EDIT
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: viewer?EnrollViewer(Price:Price ,id: eventId,): EnrollRacer(Price:Price ,id: eventId,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
