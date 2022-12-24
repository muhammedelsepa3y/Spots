import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/components/components.dart';
import '../../home/home.dart';
import '../../payment/payment.dart';

class EnrollViewer extends StatefulWidget {
  int Price;
  int id;

  EnrollViewer({required this.Price, required this.id});

  @override
  State<EnrollViewer> createState() => _EnrollViewerState();
}

class _EnrollViewerState extends State<EnrollViewer> {
  bool load=false;
  var emailController = TextEditingController();
  List<int> enrolled = [];
  var nameController = TextEditingController();

  var nationalidController = TextEditingController();

  var phoneController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return load?Center(
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
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Text("Name", style: TextStyle(fontSize: 18)),
            ),
            Input(
              con: nameController,
              hint: "Enter your name",
              pre: const Icon(Icons.person),
              validate: (p0) {
                if (p0 == "") {
                  return "Name is required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Text("National ID", style: TextStyle(fontSize: 18)),
            ),
            Input(
              con: nationalidController,
              enter: TextInputType.number,
              hint: "Enter your national id",
              pre: const Icon(Icons.numbers_outlined),
              validate: (p0) {
                if (p0 == "") {
                  return "National ID is required";
                }else if(p0!.length != 14){
                  return "National ID must be 14 digits";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Text("Phone", style: TextStyle(fontSize: 18)),
            ),
            Input(
              con: phoneController,
              enter: TextInputType.phone,
              hint: "Enter your phone",
              pre: const Icon(Icons.phone),
              validate: (p0) {
                if (p0 == "") {
                  return "Phone is required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 8),
              child: Text("Payment Data",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Total Price:", style: TextStyle(fontSize: 18)),
                Text("\$ ${widget.Price}.00",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            loginButton(
              buttonText: "Confirm",
              () async {

                   updatetransData().then((value) {

                   });
                }

            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context, String title, String text,void Function()? onpress) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: onpress,
            ),
          ],
        );
      },
    );
  }

  updatetransData() async {
    setState(() {
      load=true;
    });
      if(formkey.currentState!.validate()){
      var test = await FirebaseFirestore.instance.collection('Users').where(
          "userid",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid);
      test.get().then((value) {
        value.docs.forEach((element) async {
          element['EnrolledEvents'].forEach((element) {
            setState(() {
              enrolled.add(element);
            });
          });
          if(element["OnlineWallet"]<(widget.Price)){
            setState(() {
              load=false;
            });
            await _showMyDialog(context, "Error",
                "You don't have enough money in your wallet",(){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Payment_PAGE()));
            });
          }else if(element["OnlineWallet"]>=(widget.Price)){
            enrolled.add(widget.id);
            FirebaseFirestore.instance.collection('Users').doc(element.id).update({
              "OnlineWallet": element['OnlineWallet'] - widget.Price,
              "EnrolledEvents": enrolled,
              "EnrolledName": nameController.text,
              "EnrolledNationalID": nationalidController.text,
              "EnrolledPhone": phoneController.text,
            });
            setState(() {
              load=false;
            });
            await _showMyDialog(context, "Error",
                "Successfully, you paid \$ ${widget.Price}.00 in this event",(){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => racingflags()));
                });
          }
        });
      });




      }

      }


}
