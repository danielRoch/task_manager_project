import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final AuthService _auth = AuthService();

  // Text Controllers
  final _taskController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  // Date Picker Defaut Date
  DateTime date = DateTime.now();
  // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Modal for task creation
  showTaskModal(context, label) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: label,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                // Close the modal by popping the page
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            title: Text(label),
          ),
          backgroundColor: Colors.white.withOpacity(0.90),
          body: Container(
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
                        date =
                            newDate; // Set the date selected in the DatePicker
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

                // Submit Button
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  onPressed: () async {
                    // TODO: Add task submittion
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        actions: [
          GestureDetector(
            onTap: () async {
              await _auth.signout();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await _auth.signout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed In as ${user.email!}'),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              onPressed: () async {
                await _auth.signout();
              },
              child: const Text(
                'Sign out',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add form for adding new tasks
          showTaskModal(context, 'New Task');
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
