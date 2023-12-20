import 'package:flutter/material.dart';

class passwordField extends StatefulWidget {
  const passwordField({super.key});

  @override
  State<passwordField> createState() => _passwordFieldState();
}

class _passwordFieldState extends State<passwordField> {
  @override
  final TextEditingController pass=TextEditingController();
  Icon eye=Icon(Icons.remove_red_eye_outlined);
  bool eyeState=true;
  Widget build(BuildContext context) {
    return Container
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
    );
  }
}
