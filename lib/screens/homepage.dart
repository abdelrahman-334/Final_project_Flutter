import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../addScreen.dart';
import '../edit screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  void _createUserInFireStore(User? _user)
  {
    _firestoreDb.doc('/users/${_user!.uid}');
  }
  bool? val=false;
  @override
  List<QueryDocumentSnapshot> Data=[];
  getData() async
  {
    print(_user);
   QuerySnapshot querySnapshot = await  FirebaseFirestore.instance.collection("tasks").where('user',isEqualTo: "${_user?.uid}").get();
    Data.addAll(querySnapshot.docs);
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState()
  {
    getData();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        backgroundColor: Colors.red,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row
            (
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  decoration: BoxDecoration(color: Colors.blue[200],borderRadius: BorderRadius.all(Radius.circular(300))),
                  width: 40,
                  height:40,
                  alignment: Alignment.center,
                  child: Image.network(
                      width: 30,
                      height: 30,
                      fit:BoxFit.fill,
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Google_Tasks_2021.svg/791px-Google_Tasks_2021.svg.png"
                  )),
              MaterialButton(onPressed: () async
              {
                Navigator.of(context).pop();
                _createUserInFireStore(_user);
                final result = await Navigator.push(
                    context,
                MaterialPageRoute(
                  builder: (context) => addScreen()
                ));
              },child: Icon(Icons.add),)
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () async
        {
          GoogleSignIn google=GoogleSignIn();
          google.disconnect();
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
        }, icon: Icon(Icons.exit_to_app))],
      ),
      body:
        isLoading ? Center(child: CircularProgressIndicator()): ListView.builder(itemCount: Data.length,itemBuilder:(context, index)
        {
          return ListTile(
            title: SingleChildScrollView(

              scrollDirection: Axis.horizontal,
              child: Row(
                  children:[
              Task(Data: Data[index]),
                    Checkbox(value: Data[index]["Done"], onChanged: (val2) async
              {
                CollectionReference tasks = FirebaseFirestore.instance.collection("tasks");
                await tasks.doc(Data[index].id).update
                  (
                    {
                      "Done":val2
                    }
                );
                Navigator.pop(context);  // pop current page

                Navigator.pushNamed(context, "/homepage"); // push it back in
              }),

                ButtonTheme(
                  minWidth: 30,
                  child: MaterialButton(onPressed: () async
                  {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => editScreen(docid: Data[index].id),
                      ));
                      setState(() {


                    });
                  }, child: Icon(Icons.edit)),
                ),
                ButtonTheme(
                  minWidth: 30,
                  child: MaterialButton(onPressed: ()
                  {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: "Are you Sure?",
                      desc: "You are about to delete this task permanently",
                      btnCancelOnPress: ()
                      {
                      },
                      btnOkOnPress: () async
                      {
                        await FirebaseFirestore.instance.collection("tasks").doc(Data[index].id).delete();
                        print(DateTime.now().day);
                        AwesomeNotifications().createNotification(content: NotificationContent(id: 1, title: "Task time overdue",channelKey:"basic_channel",body: "Task Deleted"));
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/homepage");
                      },
                    ).show();

                  }, child: Icon(Icons.delete),
                  ),
                )
              ]),
            )
          );
        }, )
    );
  }

  _getTime() async
  {
    String _formatDateTime(DateTime dateTime) {
      return DateFormat.yMMMMEEEEd().format(dateTime);
    }
    final String now = _formatDateTime(DateTime.now());
    final TimeOfDay time = TimeOfDay.now();
    for (int i=0;i<Data.length;i++){

      if(now==Data[i]["DueDay"] && time.toString() == Data[i]["DueTime"] && !Data[i]["noted"])
      {
        if(Data[i]["Done"]==false)
        {
          AwesomeNotifications().createNotification(content: NotificationContent(id: 1, title: "Task time overdue",channelKey:"basic_channel",body: "Task ${Data[i]["name"]} time has passed"));
        }
        else
        {
          AwesomeNotifications().createNotification(content: NotificationContent(id: 1, title: "Task time Finished",channelKey:"basic_channel",body: "Task ${Data[i]["name"]} time was Done before it was finished"));
        }
        CollectionReference tasks = FirebaseFirestore.instance.collection("tasks");
        await tasks.doc(Data[i].id).update
          (
            {
              "noted":true,

            }
        );
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/homepage");
      }
    }
  }
}
class Task extends StatefulWidget {
  Task({super.key,required this.Data});
  QueryDocumentSnapshot Data;
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Card(child:
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            child: Column(
            
              children:
              [
                Text(widget.Data["name"]),
                Text(widget.Data["DueDay"].toString()),
                Text(widget.Data["DueTime"].toString()),
              ],),
          ),

        ],
      ),
    ),
    );
  }
}
