import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/weather_api.dart';
import '../database.dart';
import '../models/weather.dart';
import 'edit_task_screen.dart';

class TaskViewScreen extends StatefulWidget {
  final QueryDocumentSnapshot task;
  const TaskViewScreen({super.key, required this.task});

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  String getApi(DateTime date) {
    // Get time to/from today's date to the task date
    int dateDifference = date.compareTo(DateTime.now());
    debugPrint('Date Difference: ${dateDifference.toString()}');

    // Check if date distance is out of API range -365 to 300
    if (dateDifference > 300 || dateDifference < -365) {
      return "";
    }

    // Date is in the past
    if (dateDifference < 0) {
      return "history";
    }

    // Date is less than or equal to 14 days ahead
    if (dateDifference <= 14) {
      return "forecast";
    }

    // Date is more than 14 days ahead
    if (dateDifference > 14) {
      return "future";
    }

    return "forecast";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          // Edit Task
          IconButton(
            onPressed: () async {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EditTaskScreen(task: widget.task),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),

          // Delete Task
          IconButton(
            onPressed: () async {
              await deleteTask(widget.task.id);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10.0),

                // Title
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      label: const Text(
                        'Task Title',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19.0,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.task['title'],
                      style: const TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Description
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      label: const Text(
                        'Task Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.task['description'],
                      softWrap: true,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Location
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      label: const Text(
                        'Task Location',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.task['location'],
                      softWrap: true,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Date
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      label: const Text(
                        'Task Due Date',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Text(
                      DateFormat('MM/dd/yyyy')
                          .format(widget.task['dueDate'].toDate()),
                      softWrap: true,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Task Completed?
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      label: const Text(
                        'Task Completed',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.task['is_completed']
                              ? 'Task Completed'
                              : 'Task Not Completed',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          widget.task['is_completed']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.lightBlue,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                FutureBuilder<Weather>(
                  future: WeatherApi.getWeather(
                    location: widget.task['location'],
                    date: widget.task['dueDate'].toDate(),
                    apiType: getApi(
                      widget.task['dueDate'].toDate(),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: {$snapshot.error}');
                    } else {
                      final weatherData = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Average Temp (F): ${weatherData!.degrees.toString()}',
                          ),
                          Text(
                            'Condition: ${weatherData.description}',
                          ),
                          Image.network(
                            'https:${weatherData.icon}',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
