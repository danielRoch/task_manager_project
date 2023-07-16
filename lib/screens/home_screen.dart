import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_project/database.dart';
// import 'package:intl/intl.dart';
import 'package:task_manager_project/screens/add_task_screen.dart';

import '../auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final AuthService _auth = AuthService();

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
        child: StreamBuilder<QuerySnapshot>(
          stream: readTasks(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((task) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () async {
                            await updateTaskStatus(
                                task.id, !task['is_completed']);
                          },
                          child: Icon(
                            task['is_completed']
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.lightBlue,
                          ),
                        ),
                        title: Text(task['title']),
                        subtitle: Text(
                            '${task['description']}\n${DateFormat('MM/dd/yyyy').format(task['dueDate'].toDate())}'),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_horiz),
                          tooltip: 'Edit/Delete Task',
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () {},
                                value: 'edit',
                                child: const Text("Edit"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  deleteTask(task.id);
                                },
                                value: 'delete',
                                child: const Text("Delete"),
                              ),
                            ];
                          },
                        ),
                        isThreeLine: true,
                        onLongPress: () {
                          task.reference.delete();
                        },
                      ),
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
          //Form for adding new tasks
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const TaskManipulation(),
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
