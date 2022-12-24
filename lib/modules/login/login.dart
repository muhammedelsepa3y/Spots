import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';

import '../../shared/components/components.dart';
import '../forget_password/forget_password.dart';
import '../home/home.dart';
import '../signup/signup.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}


class _loginScreenState extends State<loginScreen> {
  bool secure = true;
bool load=false;
  initState()  {
    super.initState();

  }

  var emailController = TextEditingController();

  var passwordController = TextEditingController();
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
    ):Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Input(
                  con: emailController,
                  enter: TextInputType.emailAddress,
                  lab: "Email",
                  pre: const Icon(Icons.email),
                  validate: (p0) {
                    if (p0 == "") {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
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
                  height: 6,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const forgetPassword()));
                      });
                    },
                    child: const Text("Forget Passaword?",style: TextStyle(

                    ),)),
                const SizedBox(
                  height: 20,
                ),
                loginButton(
                  ()  async {
                    await loginn();
                  },

                ),


const SizedBox(height: 25,),




                const Padding(
                  padding: EdgeInsets.only(left:20,top: 30),
                  child: Text("Don't have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: const SignUpScreen(),
                          duration: const Duration(milliseconds: 900),
                        ),
                      );
                    });
                  },
                  child: Center(
                    child: Column(
                      children: const [
                        Text("Sign Up Now",style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(
                          height: 8,
                        ),
                        Icon(Icons.arrow_upward_outlined,size: 30,color: Colors.blue,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginn() async {

    if (formkey.currentState!.validate()) {


         FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        ).then((value) async {
          setState(() {
            load=false;
          });
          await AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              showCloseIcon: true,
              closeIcon: const Icon(Icons.close_fullscreen_outlined),
          title: 'Login Success.',
          onDissmissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
          },
          btnOkOnPress: () {},
          ).show();

          Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => racingflags()));

        }).catchError((e){
          if (e.code == 'user-not-found') {
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
              title: 'No user found for that email.',
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
              btnOkOnPress: () {},
            ).show();
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
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
              title: 'Wrong password provided for that user.',
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
              btnOkOnPress: () {},
            ).show();
            print('Wrong password provided for that user.');
          }else if(e.code=="invalid-email"){
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
              title: 'Invalid Email',
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
              btnOkOnPress: () {},
            ).show();

            print("Invalid Email");
          }
          else{setState(() {
            load=false;
          });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              showCloseIcon: true,
              closeIcon: const Icon(Icons.close_fullscreen_outlined),
              title: e.code,
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
              btnOkOnPress: () {},
            ).show();
            print(e.code);
          }
        });




    }
}}
