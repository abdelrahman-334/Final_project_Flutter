
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/edit%20screen.dart';


class Task extends StatefulWidget {
   Task({super.key,required this.Data});
   QueryDocumentSnapshot Data;
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool? val=false;
  @override
  Widget build(BuildContext context) {
    return Card(child:
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(

            children:
            [
               Text(widget.Data["name"]),
               Text(widget.Data["DueDay"].toString()),
               Text(widget.Data["DueTime"].toString()),
            ],),
          Checkbox(value: val, onChanged: (val2)
          {
            setState(() {
             val=val2;
            });
          }),
          MaterialButton(onPressed: () async
          {

            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => editScreen(name:widget.Data["name"],selectedDate:widget.Data["DueDay"] ,selectedTime:widget.Data["DueTime"] ),
                ));
            setState(() {
            });
          }, child: Icon(Icons.edit)),
          MaterialButton(onPressed: (){}, child: Icon(Icons.delete),),
        ],
      ),
    ),
    );
  }
}
