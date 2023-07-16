import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database.dart';

class EditTaskScreen extends StatefulWidget {
  final QueryDocumentSnapshot task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // Completed Status
  bool _isCompleted = false;

  // Text Controllers
  final _taskController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  // Text Controller resource disposal
  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _taskController.text = widget.task['title'];
    _descriptionController.text = widget.task['description'];
    _locationController.text = widget.task['location'];
    _dateController.text =
        DateFormat('MM/dd/yyyy').format(widget.task['dueDate'].toDate());
    _isCompleted = widget.task['is_completed'];

    date = widget.task['dueDate'].toDate();
    super.initState();
  }

  // Date Picker Defaut Date
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Close the page by popping the page
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Edit Task'),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              // Task Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Task',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Task Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  minLines: 4,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Task Description',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Task Location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Task Location',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Task Date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      helpText: 'Select Task Date',
                      context: context,
                      initialDate: widget.task['dueDate'].toDate(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );

                    // Cancel clicked
                    if (newDate == null) return;

                    // Ok clicked
                    String formattedDate =
                        DateFormat('MM/dd/yyyy').format(newDate);

                    setState(() {
                      _dateController.text =
                          formattedDate; // Set the Date displayed
                      date = newDate; // Set the date selected in the DatePicker
                    });
                  },
                  controller: _dateController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Date',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CheckboxListTile(
                  activeColor: Colors.lightBlue,
                  tileColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white),
                  ),
                  title: const Text('Task Complete?'),
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Update Button
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: () async {
                  // Create the task in FireStore
                  await updateTask(
                      widget.task.id,
                      _taskController.text,
                      _descriptionController.text,
                      _locationController.text,
                      date,
                      _isCompleted);

                  Navigator.pop(context);
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
