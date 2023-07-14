import 'package:flutter/material.dart';
import 'package:task_manager_project/screens/login_screen.dart';
import 'package:task_manager_project/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Show Login Screen Initially
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showSignUpScreen: toggleScreens);
    } else {
      return SignUpScreen(showLoginScreen: toggleScreens);
    }
  }
}
