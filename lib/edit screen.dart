import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class editScreen extends StatefulWidget {
  editScreen({super.key, required this.docid});
  final String docid;
  @override
  State<editScreen> createState() => _editScreenState();
}
String _formatDateTime(DateTime dateTime) {
  return DateFormat.yMMMMEEEEd().format(dateTime);
}
class _editScreenState extends State<editScreen> {

  CollectionReference tasks = FirebaseFirestore.instance.collection("tasks");
  String selectedDate=_formatDateTime(DateTime.now());
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController name=TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Edit"),

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
          Container(margin:EdgeInsets.all(10) ,child: ElevatedButton(onPressed: () async
          {
             await tasks.doc(widget.docid).update
              (
                {
                  "name":name.text,
                  "DueDay":selectedDate,
                  "DueTime":selectedTime.toString(),
                }

            );
             Navigator.of(context).popUntil((route) => false);
             Navigator.of(context).pushReplacementNamed("/homepage");
            // Navigator.pop(context,[name.text,widget.selectedDate,widget.selectedTime]);
          }, child: Text("Accept changes?")))
        ],
      ),
    );
  }
}
