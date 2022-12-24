import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'package:page_transition/page_transition.dart';

import '../../shared/components/components.dart';
import '../home/home.dart';
import '../login/login.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool secure = true;
bool load=false;
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var userController = TextEditingController();
  var phoneController = TextEditingController();

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
      ): SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:20,top: 10),
                    child: Text("Exiting User?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.topToBottom,
                            child: const loginScreen(),
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                      });
                    },
                    child: Center(
                      child: Column(
                        children: const [

                          Text("Sign in Now",style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(
                            height: 8,
                          ),
                          Icon(Icons.arrow_downward_outlined,size: 30,color: Colors.blue,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),



                  const Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Input(
                    con: nameController,
                    lab: "Name",
                    pre: const Icon(Icons.person_outline),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: emailController,
                    lab: "Email",
                    enter: TextInputType.emailAddress,
                    pre: const Icon(Icons.email),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),


                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: userController,
                    lab: "Username",
                    pre: const Icon(Icons.person),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: phoneController,
                    lab: "Phone",
                    enter: TextInputType.phone,
                    pre: const Icon(Icons.phone),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Phone is required";
                      }
                      return null;
                    },
                  ),


                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: passwordController,
                    lab: "Password",

                    pre: const Icon(Icons.lock),
                    validate: (p0) {
                      if (p0 == "") {
                        return "Password is required";
                      }
                      return null;
                    },
                    isObsecure: secure,
                    suf: secure ? Icons.visibility : Icons.visibility_off,
                    suffunf: () {
                      setState(() {
                        secure ? secure = false : secure = true;
                        print(secure);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Input(
                    con: confirmPasswordController,
                    lab: "Repeat Password",
                    pre: const Icon(Icons.lock),
                    validate: (p0) {
                      if (p0 == "" ) {
                        return "Password is required";
                      }else if(p0 != passwordController.text){
                        return "Password does not match";
                      }
                      return null;
                    },
                    isObsecure: secure,
                    suf: secure ? Icons.visibility : Icons.visibility_off,
                    suffunf: () {
                      setState(() {
                        secure ? secure = false : secure = true;
                        print(secure);
                      });
                    },
                  ),


                  const SizedBox(
                    height: 25,
                  ),
                  loginButton(
                    buttonText: "Register",
                        () async {
                      await signup();

                    },

                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> signup() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        load = true;
      });
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        await FirebaseFirestore.instance
            .collection("Users").add({
          "Name": "${nameController.text}",
          "Email": "${emailController.text}",
          "username": "${userController.text}",
          "OnlineWallet": 1000,
          "userid": FirebaseAuth.instance.currentUser!.uid,
          "EnrolledEvents": [0],
          "EnrolledNationalID": 0000,
          "EnrolledPhone": phoneController.text,
          "EnrolledCarType": " ",
          "EnrolledLicence": 0000,
          "Image":"https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
        });
        setState(() {
          load = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          showCloseIcon: true,
          closeIcon: const Icon(Icons.close_fullscreen_outlined),
          title: 'Registration Successful',
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    racingflags()));
          },
        ).show();

      } on FirebaseException catch (e)  {
        if (e.code == 'weak-password') {
setState(() {
  load=false;
});
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            showCloseIcon: true,
            closeIcon: const Icon(Icons.close_fullscreen_outlined),
            title: 'The password provided is too weak.',
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            btnOkOnPress: () {},
          )
            ..show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            load=false;
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            showCloseIcon: true,
            closeIcon: const Icon(Icons.close_fullscreen_outlined),
            title: 'The account already exists for that email.',
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            btnOkOnPress: () {},
          )
            ..show();
          print('The account already exists for that email.');
        }
        else {
          setState(() {
            load=false;
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            showCloseIcon: true,
            closeIcon: const Icon(Icons.close_fullscreen_outlined),
            title: "$e",
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
            btnOkOnPress: () {},
          )
            ..show();
          print(e);
        }
      }
    }
  }
}
