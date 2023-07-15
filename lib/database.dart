import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference tasksCollection =
    FirebaseFirestore.instance.collection('tasks');

// Add task
Future<void> addTask(
    String title, String description, DateTime dueDate, String status) async {
  try {
    await tasksCollection.add({
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status,
    });
    print('Task created!');
  } catch (e) {
    print('Error adding task: $e');
  }
}

// Read all tasks
Stream<QuerySnapshot> readTasks() {
  return tasksCollection.snapshots();
}

// Update task
Future<void> updateTask(String taskId, String title, String description,
    DateTime dueDate, String status) {
  return tasksCollection.doc(taskId).update({
    'title': title,
    'description': description,
    'dueDate': Timestamp.fromDate(dueDate),
    'status': status,
  });
}

// Delete task
Future<void> deleteTask(String taskId) async {
  try {
    await tasksCollection.doc(taskId).delete();
    print('Task deleted!');
  } catch (e) {
    print('Error adding task: $e');
  }
}
