import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("/homepage", (route) => false);
  }
  @override
  final TextEditingController email=TextEditingController();
  final TextEditingController pass=TextEditingController();
  Icon eye=Icon(Icons.remove_red_eye_outlined);
  bool eyeState=true;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15) ,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                    decoration: BoxDecoration(color: Colors.blue[200],borderRadius: BorderRadius.all(Radius.circular(300))),
                    width: 70,
                    height:70,
                    alignment: Alignment.center,
                    child: Image.network(
                      width: 50,
                      height: 50,
                      fit:BoxFit.fill,
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Google_Tasks_2021.svg/791px-Google_Tasks_2021.svg.png"
               )),
              ],
            ),
            Container(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child:const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                    Text("Login",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                    Text("Login to continue using the app",style: TextStyle(color: Colors.grey)),

                  ]),
                )),
            Container
              (
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:
              [
                Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                SizedBox(height: 12,),
                TextField(controller: email,decoration: InputDecoration(fillColor: Colors.grey,border: OutlineInputBorder(borderRadius: BorderRadius.circular(100))))
              ],)
            ),
            Container
              (
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:
                [

                  Text("Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
                  SizedBox(height: 12,),
                  TextField(controller: pass,obscureText: eyeState,decoration: InputDecoration(fillColor: Colors.grey,border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),suffixIcon: MaterialButton(child: eye,onPressed: ()
                  {
                    setState(() {
                      if (eyeState==true)
                      {
                        eye=Icon(Icons.panorama_fish_eye);
                        eyeState=false;
                      }
                      else
                      {
                        eye=Icon(Icons.remove_red_eye_outlined);
                        eyeState=true;
                      }
                    });

                  },)),)
                ],)
            ),
            Container(

              margin:EdgeInsets.only(top: 5,bottom: 20) ,alignment: Alignment.topRight,
                child:MaterialButton(child:  Text("forgot password ?",style: TextStyle(fontSize: 12)),onPressed:  () async
                {
                  if (email.text == ""){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'Email is empty',
                  ).show();
                  return;
                  }
                  else
                  {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email.text);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Sent',
                        desc: 'Reset mail sent',
                      ).show();

                    }
                    on FirebaseAuthException catch(e)
                    {

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: "check the entered email",
                      ).show();
                    }
                  }

                },)
                    ,
            ),
            MaterialButton(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),padding: EdgeInsets.all(10),onPressed: () async
            {
              try {
                final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.text,
                    password: pass.text,
                );
                if(credential.user!.emailVerified){
                Navigator.of(context).pushReplacementNamed("/homepage");
                }
                else
                {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'Verify your Email',
                  ).show();
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'User not found',
                      ).show();
                } else if (e.code == 'wrong-password') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: "email not found",
                  ).show();
                }
              }
            },color: Colors.blueAccent[100],child: Text("Login",style: TextStyle(fontSize: 24),),),
            SizedBox(height: 20,),

            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                SizedBox(width: 10,),
                MaterialButton(child: Text("Register!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),onPressed: ()
                {
                  Navigator.of(context).pushNamed("/signin");
                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}
