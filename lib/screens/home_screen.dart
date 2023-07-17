import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_project/custom_page_route.dart';
import 'package:task_manager_project/database.dart';
// import 'package:intl/intl.dart';
import 'package:task_manager_project/screens/add_task_screen.dart';
import 'package:task_manager_project/screens/edit_task_screen.dart';
import 'package:task_manager_project/screens/task_view_screen.dart';

import '../auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final AuthService _auth = AuthService();

  showSnackBar(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        backgroundColor: success ? Colors.lightGreen : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Page Background
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
                try {
                  await _auth.signout();
                } catch (e) {
                  showSnackBar(e.toString(), false);
                }
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: readTasks(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((task) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListTile(
                      onTap: () {
                        // Go to Task View Page to view the additional information
                        // about the task
                        Navigator.push(
                          context,
                          // Custom Slide Transition
                          CustomSlidePageRoute(
                            child: TaskViewScreen(
                              task: task,
                            ),
                            direction: AxisDirection.right,
                          ),
                        );
                      },
                      leading: GestureDetector(
                        onTap: () async {
                          try {
                            await updateTaskStatus(
                                task.id, !task['is_completed']);
                          } catch (e) {
                            showSnackBar(e.toString(), false);
                          }
                        },
                        child: Icon(
                          // Changes the icon depending on if the task is marked as complete
                          task['is_completed']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.lightBlue,
                        ),
                      ),
                      title: Text(task['title']),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${task['description']}'),
                              Text(DateFormat('MM/dd/yyyy')
                                  .format(task['dueDate'].toDate())),
                              Text(task['location']),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await Navigator.push(
                              context,
                              CustomSlidePageRoute(
                                child: EditTaskScreen(task: task),
                                direction: AxisDirection.left,
                              ),
                            );
                          }
                          if (value == 'delete') {
                            try {
                              await deleteTask(task.id);
                            } catch (e) {
                              showSnackBar(e.toString(), false);
                            }
                          }
                        },
                        icon: const Icon(Icons.more_horiz),
                        tooltip: 'Edit/Delete Task',
                        itemBuilder: (context) {
                          return [
                            // Edit Button
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Edit"),
                            ),
                            // Delete Button
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text("Delete"),
                            ),
                          ];
                        },
                      ),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Form for adding new tasks
          Navigator.push(
            context,
            CustomSlidePageRoute(
              child: const TaskManipulation(),
              direction: AxisDirection.up,
            ),
          );
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
