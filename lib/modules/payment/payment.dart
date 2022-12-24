import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../home/home.dart';

class Payment_PAGE extends StatefulWidget {
  const Payment_PAGE({Key? key}) : super(key: key);

  @override
  State<Payment_PAGE> createState() => _Payment_PAGEState();
}

class _Payment_PAGEState extends State<Payment_PAGE> {

  var formkey = GlobalKey<FormState>();
  var cardnumberController = TextEditingController();
  var cvvController = TextEditingController();
  var expirydateController = TextEditingController();
  var _controller = TextEditingController();
  initState() {


    super.initState();
  }
bool load=false;
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
      body: load?Center(
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
              const Text(
                "Payment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),
              ),
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 3),

                ),

                child: Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          child: Input(
                            con: _controller,
                            enter: TextInputType.number,
                            lab: "Price you want to charge in your online wallet",
                            pre: const Icon(Icons.attach_money),
                            validate: (p0) {
                              if (p0 == "") {
                                return "This Field is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 8),
                          child: Text("Payment Data", style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8,),

                        const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 8),
                          child: Text("Card Number",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Input(
                          con: cardnumberController,
                          enter: TextInputType.text,
                          hint: "****  ****  **** ****",

                          pre: const Icon(Icons.credit_card),
                          validate: (p0 ) {
                            if (p0 == "" ) {
                              return "Card Number is required ";
                            }else if(p0!.length != 16){
                              return "Card Number must be 16 digits";}
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 8),
                              child: Text("Valid Until",
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Input(
                              con: expirydateController,
                              enter: TextInputType.text,
                              hint: "Month / Year",
                              pre: const Icon(Icons.calendar_today),
                              validate: (p0) {
                                if (p0 == "" || p0 == null ) {
                                  return "Expiry Date is required";
                                }else if(p0.length != 5){
                                  return "Invalid Expiry Date";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 8),
                              child: Text(
                                  "CVV", style: TextStyle(fontSize: 18)),
                            ),
                            Input(
                              con: cvvController,
                              hint: "***",
                              enter: TextInputType.number,
                              pre: const Icon(Icons.security_outlined),
                              validate: (p0) {
                                if (p0 == "" ) {
                                  return "CVV is required";
                                }else if( p0?.length != 3){
                                  return "CVV must be 3 digits";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),


                        const SizedBox(
                          height: 20,
                        ),
                        loginButton(buttonText: "Confirm", () async {
                          if (formkey.currentState!.validate()) {


                            updatetransData().then((value)
                            async {
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.SUCCES,
                                headerAnimationLoop: false,
                                animType: AnimType.TOPSLIDE,
                                showCloseIcon: true,
                                closeIcon: const Icon(Icons.close_fullscreen_outlined),
                                title: 'Payment Status',
                                desc: 'Payment Successful, You charged \$ ${_controller.text} to your online wallet',
                                onDissmissCallback: (type) {
                                  debugPrint('Dialog Dissmiss from callback $type');
                                },
                                btnOkOnPress: () {},
                              ).show();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>  racingflags()));
                            });


                          }
                        },),
                      ],
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
  updatetransData() async {
    setState(() {
      load = true;
    });
    var test = FirebaseFirestore.instance.collection('Users').
    where("userid",isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    test.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('Users').doc(element.id).update({
          "OnlineWallet": element.data()['OnlineWallet'] + int.parse(_controller.text),
        });
      });
    });
    setState(() {
      load = false;
    });
  }
}
