
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart';

import '../../models/storage.dart';
import '../login/login.dart';
class profile extends StatefulWidget {

  @override
  State<profile> createState() => _profileState();
}
class user{
  String name;
  String email;
  String username;
  user(this.name, this.email, this.username);
}
class _profileState extends State<profile> {

  FirebaseStorage _storage = FirebaseStorage.instance;


  var user;
  var formkey= GlobalKey<FormState>();
bool load=false;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text('Spots', style: TextStyle(color: Colors.white),)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: (load || (user==null))?Center(
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
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 40,),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(radius:80 ,backgroundImage:NetworkImage("${user['Image']}"),),
                      const CircleAvatar(radius:10 ,backgroundColor:Colors.white),
                      Padding(
                          padding: EdgeInsets.only(left: 12 ),
                          child: IconButton(onPressed: () async {

                            await uploadImage(context);
                          }, icon: CircleAvatar(
                            radius:22,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          )))
                    ],
                  ),
                )
                ,

                SizedBox(height: 25,),
                TextFormField(
                  enabled: false,
                  initialValue: "${user['Name']}",
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),

                  ),
                ),

                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: "${user['Email']}",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),

                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: "${user['username']}",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.contact_page_outlined),

                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  enabled: false,
                  initialValue: "${user['EnrolledPhone']}",
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                Center(
                  child: MaterialButton(child:  Text("Delete Account",style: TextStyle(color: Colors.white),),color: Colors.red,onPressed: ((){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Warning',
                      desc: 'Are you sure you want to delete your account?',
                      btnOkOnPress: () {
                        FirebaseAuth.instance.currentUser!.delete();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => const loginScreen()));
                      },
                      btnOkIcon: Icons.delete,
                      btnOkColor: Colors.red,
                      btnCancelOnPress: () {
                      },
                      btnCancelIcon: Icons.cancel,
                      btnCancelColor: Colors.green,
                    ).show();

                  }),


                  ),
                )



              ],
            ),
          ),
        ),
      ),

    );
  }
  uploadImage(context) async {
    setState(() {
      load=true;
    });
    ImagePicker objj = ImagePicker();
    var _image = await objj.pickImage(source: ImageSource.gallery);
    var user = FirebaseAuth.instance.currentUser;
      var storage = FirebaseStorage.instance;
      var storageRef = storage.ref();
      var imagesRef = storageRef.child('${user!.email}/${basename(_image!.path)}');
      var selectedImage = File(_image.path);
      var uploadTask = imagesRef.putFile(selectedImage);
      var url = await (await uploadTask).ref.getDownloadURL();
      var userRef = await FirebaseFirestore.instance.collection("Users").where(
          "userid",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid);
      userRef.get().then((value) {
value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("Users").doc(element.id).update({
            "Image": url,
          });
        });
      });
      getData();
      setState(() {
        load=false;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Success',
        desc: 'Your profile picture has been updated',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();


  }
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
        user = value.docs.first.data();
      });
    });
    setState(() {
      load=false;
    });
  }



}


