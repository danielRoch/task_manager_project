import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference tasksCollection =
    FirebaseFirestore.instance.collection('tasks');

// Add task
Future<void> addTask(String title, String description, String location,
    DateTime dueDate, bool status) async {
  try {
    await tasksCollection.add({
      'title': title,
      'description': description,
      'location': location,
      'dueDate': Timestamp.fromDate(dueDate),
      'is_completed': status,
    });
    debugPrint('Task created!');
  } catch (e) {
    debugPrint('Error adding task: $e');
  }
}

// Read all tasks
Stream<QuerySnapshot> readTasks() {
  return tasksCollection.snapshots();
}

// Update task
Future<void> updateTask(String taskId, String title, String description,
    String location, DateTime dueDate, bool status) {
  return tasksCollection.doc(taskId).update({
    'title': title,
    'description': description,
    'location': location,
    'dueDate': Timestamp.fromDate(dueDate),
    'is_completed': status,
  });
}

// Delete task
Future<void> deleteTask(String taskId) async {
  try {
    await tasksCollection.doc(taskId).delete();
    debugPrint('Task deleted!');
  } catch (e) {
    debugPrint('Error adding task: $e');
  }
}
