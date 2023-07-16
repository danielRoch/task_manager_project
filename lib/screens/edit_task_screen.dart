import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final QueryDocumentSnapshot task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.task['title'],
            ),
            Text(
              widget.task['description'],
            ),
            Text(
              widget.task['location'],
            ),
          ],
        ),
      ),
    );
  }
}
