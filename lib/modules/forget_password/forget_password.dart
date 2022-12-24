import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import '../../shared/components/components.dart';
import '../login/login.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({Key? key}) : super(key: key);

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {

bool load=false;
  var emailController = TextEditingController();


  var formkey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Forget Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const SizedBox(
                  height: 40,
                ),
                Input(
                  con: emailController,
                  enter: TextInputType.emailAddress,
                  lab: "Email Address",
                  pre: const Icon(Icons.email),
                  validate: (p0) {
                    if(p0==""){
                      return "Email is required";
                    }
                    return null;
                  },
                ),


                const SizedBox(
                  height: 40,
                ),
                loginButton(()  async {
                  if(formkey.currentState!.validate()){
                   await sendPasswordResetEmail(emailController.text);


                  }

                }, buttonText: "Reset Password"),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                loginButton(()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen()));

                }, buttonText: "Cancel"),




              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    showload();
    setState(() {
      load=true;
    });
     FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value)
     async {
       setState(() {
         load=false;
       });
      await AwesomeDialog(
     context: context,
     dialogType: DialogType.INFO,
     headerAnimationLoop: false,
     animType: AnimType.TOPSLIDE,
     showCloseIcon: true,
     closeIcon: const Icon(Icons.close_fullscreen_outlined),
     title: 'Please check your email for a link to reset your password',
     onDissmissCallback: (type) {
     debugPrint('Dialog Dissmiss from callback $type');
     },
     btnOkOnPress: () {},
     ).show();


       Navigator.of(context).pushReplacement(MaterialPageRoute(
           builder: (BuildContext context) => const loginScreen()));

    }).catchError((e){
      setState(() {
        load=false;});
       AwesomeDialog(
         context: context,
         dialogType: DialogType.WARNING,
         headerAnimationLoop: false,
         animType: AnimType.TOPSLIDE,
         showCloseIcon: true,
         closeIcon: const Icon(Icons.close_fullscreen_outlined),
         title: 'Email not found',
         onDissmissCallback: (type) {
           debugPrint('Dialog Dissmiss from callback $type');
         },
         btnOkOnPress: () {},
       ).show();
    });
  }



}


