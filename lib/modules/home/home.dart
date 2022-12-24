

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spots_msp_project/shared/components/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../shared/components/constants.dart';
import '../events/events.dart';
import '../welcome_page/welcome_page.dart';

class racingflags  extends StatefulWidget {

  @override
  State<racingflags> createState() => _racingflagsState();
}

class _racingflagsState extends State<racingflags> {
  bool notification=true;
  int _current = 0;
  int onlinecash=1000;
  int payment=1500;



  final CarouselController _controller = CarouselController();
 String? name;
 String?img;
 bool load=false;
  Future<void> getData() async {
    setState(() {
      load=true;
    });
   await FirebaseFirestore.instance.collection("Users").where("Email", isEqualTo:FirebaseAuth.instance.currentUser?.email )
        .snapshots().listen((value)  {
      setState(() {
        name=value.docs[0]['Name'];
        img=value.docs[0]['Image'];
      });
    });
    setState(() {
      load=false;
    });
  }
  notifcation()async{
    FirebaseMessaging.onMessage.listen((value) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.WARNING,
        title: 'Notification',
        desc: value.notification!.body,
        body: Text("${value.data['message']}\nat ${value.data['time']}"),
        btnOkOnPress: () {
          Navigator.pop(context);
        },
        btnOkText: 'Ok',
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.green,
      )..show();
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      var userRef = await FirebaseFirestore.instance
          .collection("Users")
          .where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid);
      userRef.get().then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(element.id)
              .update({
            "Token": fcmToken,
          });
        });
      });
    });

  }
  @override
  void initState() {
    notifcation();
    getData().then((value)  {
    });
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


        ),
        drawer:drawer(context,name.toString(),img.toString()),
        body: load? Center(
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
        ):SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height:10,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("See Our Previous Events",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              ),
              const SizedBox(
                height:10,
              ),
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: alleventime.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              Center(child: Container(width: MediaQuery.of(context).size.width*7/10,height: 2,color: Colors.grey[300],)),
              const SizedBox(height: 20,),

              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Choose Your Favourite Category",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Events( eventType: 'Cars',)));
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(radius: 60,
                          backgroundImage: AssetImage('Assets/car.jpg'),
                        ),
                        SizedBox(height: 10,),
                        Text("Cars",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Events( eventType: 'Bikes',)));
                    },
                    child: Column(
                      children: const [
                        CircleAvatar(radius: 60,

                          backgroundImage: AssetImage('Assets/bik.jpg'),
                        ),
                        SizedBox(height: 10,),
                        Text("Bikes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                      ],
                    ),
                  ),


                ],
              ),
const SizedBox(height: 50,),



            ],
          ),
        ),
        //backgroundColor: Colors.cyanAccent,

    );
  }
}
