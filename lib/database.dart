import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference tasksCollection =
    FirebaseFirestore.instance.collection('tasks');

// Add task
Future<void> addTask(
    String title, String description, DateTime dueDate, String status) async {
  await tasksCollection.add({
    'title': title,
    'description': description,
    'dueDate': Timestamp.fromDate(dueDate),
    'status': status,
  });
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
Future<void> deleteTask(String taskId) {
  return tasksCollection.doc(taskId).delete();
}
