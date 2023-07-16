import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_project/database.dart';
import 'package:task_manager_project/screens/location_lookup_screen.dart';

// import '../auth.dart';

class TaskManipulation extends StatefulWidget {
  const TaskManipulation({super.key});

  @override
  State<TaskManipulation> createState() => _TaskManipulationState();
}

class _TaskManipulationState extends State<TaskManipulation> {
  // final AuthService _auth = AuthService();

  // Completed Status
  bool? _isCompleted = false;

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
        title: const Text('New Task'),
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
                  readOnly: true,

                  // Take user to new page to look up their locaiton and return
                  // the resulting location
                  onTap: () async {
                    final location = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LocationSearchScreen(),
                      ),
                    );
                    setState(() {
                      // Verify that the value returned from location selection
                      // is not null
                      if (location != null) {
                        _locationController.text = location;
                      }
                    });
                  },
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
                      initialDate: date,
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
                      _isCompleted = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Submit Button
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: () async {
                  // Create the task in FireStore
                  await addTask(
                      _taskController.text,
                      _descriptionController.text,
                      _locationController.text,
                      date,
                      _isCompleted!);

                  Navigator.pop(context);
                },
                child: const Text(
                  'Submit',
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
