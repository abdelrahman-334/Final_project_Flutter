import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class addScreen extends StatefulWidget {
  addScreen({super.key});
  @override
  State<addScreen> createState() => _addScreenState();
}
String _formatDateTime(DateTime dateTime) {
  return DateFormat.yMMMMEEEEd().format(dateTime);
}
class _addScreenState extends State<addScreen> {
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  String selectedDate=_formatDateTime(DateTime.now());
  TimeOfDay selectedTime=TimeOfDay.now();
  String Name=" ";
  TextEditingController name=TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        selectedDate = _formatDateTime(picked);
      });
    }
  }
  Future<void> _selectTime(BuildContext context) async {

    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    };
  }

   addTask() async {
    // Call the user's CollectionReference to add a new user
     try{
     tasks
        .add({
       'user':FirebaseAuth.instance.currentUser!.uid,
      'name': name.text, // John Doe
      'DueDay': selectedDate, // Stokes and Sons
      'DueTime': selectedTime.toString(), // 42
      'Done':false,
       'noted':false
      });
     }
     catch(e)
     {
       print(e);
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Add"),

      ),
      body: ListView
        (
        children:
        [
          Container(child: TextField(controller: name)),
          MaterialButton(onPressed: (){_selectDate(context);},child: Text("Edit Date"),),
          Text(selectedDate.toString(),textAlign: TextAlign.center,),
          MaterialButton(onPressed: (){_selectTime(context);},child: Text("Edit Time"),),
          Text(selectedTime.toString(),textAlign: TextAlign.center,),
          Container(margin:EdgeInsets.all(10) ,child: ElevatedButton(onPressed: ()
          {
            addTask();
            Navigator.of(context).pushReplacementNamed("/homepage");
            //Navigator.pop(context,[name.text,selectedDate,selectedTime]);
          }, child: Text("Accept changes?")))
        ],
      ),
    );
  }
}
