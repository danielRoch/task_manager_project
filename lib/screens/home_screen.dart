import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
