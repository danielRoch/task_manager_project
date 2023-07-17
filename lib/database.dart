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
    throw 'An Error occured while attemping to add a task. Please try again shortly.';
  }
}

// Read all tasks
Stream<QuerySnapshot> readTasks() {
  // Order by puts the tasks with the earliest dueDates first
  return tasksCollection.orderBy('dueDate', descending: false).snapshots();
}

// Update task
Future<void> updateTask(String taskId, String title, String description,
    String location, DateTime dueDate, bool status) async {
  try {
    await tasksCollection.doc(taskId).update({
      'title': title,
      'description': description,
      'location': location,
      'dueDate': Timestamp.fromDate(dueDate),
      'is_completed': status,
    });
    debugPrint('Task $taskId has been updated');
  } catch (e) {
    debugPrint('Error updating task: $e');
    throw 'An Error occured while attempting to update task $taskId. Please try again shortly';
  }
}

// Update task
Future<void> updateTaskStatus(String taskId, bool status) async {
  try {
    await tasksCollection.doc(taskId).update({
      'is_completed': status,
    });
  } catch (e) {
    debugPrint('Error updating status on task $taskId with the error $e');
    throw 'Error updating the status of task $taskId';
  }
}

// Delete task
Future<void> deleteTask(String taskId) async {
  try {
    await tasksCollection.doc(taskId).delete();
    debugPrint('Task deleted!');
  } catch (e) {
    debugPrint('Error adding task: $e');
    throw 'Error deleting task $taskId. Please try again shortly.';
  }
}
