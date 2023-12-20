import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  @override
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController con_pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  Icon eye = Icon(Icons.remove_red_eye_outlined);
  bool eyeState = true;
  Icon con_eye = Icon(Icons.remove_red_eye_outlined);
  bool con_eyeState = true;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.all(Radius.circular(300))),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    child: Image.network(
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Google_Tasks_2021.svg/791px-Google_Tasks_2021.svg.png")),
              ],
            ),
            Container(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Signup",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Signup to start using our app",
                        style: TextStyle(color: Colors.grey)),
                  ]),
            )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Userame",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextField(
                        controller: name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100))))
                  ],
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextField(
                        controller: email,
                        decoration: InputDecoration(
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100))))
                  ],
                )),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Password",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: pass,
                  obscureText: eyeState,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                      suffixIcon: MaterialButton(
                        child: eye,
                        onPressed: () {
                          setState(() {
                            if (eyeState == true) {
                              eye = Icon(Icons.panorama_fish_eye);
                              eyeState = false;
                            } else {
                              eye = Icon(Icons.remove_red_eye_outlined);
                              eyeState = true;
                            }
                          });
                        },
                      )),
                )
              ],
            )),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Confirm password",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: con_pass,
                  obscureText: con_eyeState,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                      suffixIcon: MaterialButton(
                        child: con_eye,
                        onPressed: () {
                          setState(() {
                            if (con_eyeState == true) {
                              con_eye = Icon(Icons.panorama_fish_eye);
                              con_eyeState = false;
                            } else {
                              con_eye = Icon(Icons.remove_red_eye_outlined);
                              eyeState = true;
                            }
                          });
                        },
                      )),
                )
              ],
            )),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(10),
              onPressed: () async
              {
                try {
                  if(pass.text!=con_pass.text)
                  {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'error',
                        desc: "password doesnt match",
                        ).show();
                    throw Exception();
                  }
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text,
                    password: pass.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed("/login");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'error',
                      desc: "password too weak",
                    ).show();
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'error',
                      desc: "account already exists",
                    ).show();
                  }
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.blueAccent[100],
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  child: Text("Login!",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/login");
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
