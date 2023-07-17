import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signin Email and Password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found with this email';
      }

      if (e.code == 'wrong-password') {
        throw 'Incorrect Email or Password';
      }

      if (e.code == 'too-many-requests') {
        throw 'Too many authentication attempts. Please wait a few seconds and try again.';
      }

      debugPrint('Sign In Error: ${e.toString()}');
      throw 'An unexpected error occured during Sign in. Please try again later';
    }
  }

  // Register with email and Password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email already in use. Please Sign in instead.';
      }

      if (e.code == 'weak-password') {
        throw 'Password is too week. Please enter a stronger password. \nPassword must be at least 6 characters.';
      }

      if (e.code == 'invalid-email') {
        throw 'Email entered is not a valid email. Please enter a valid Email.';
      }

      if (e.code == 'too-many-requests') {
        throw 'Too many authentication attempts. Please wait a few seconds and try again.';
      }

      debugPrint('Sign In Error: ${e.toString()}');
      throw 'An unexpected error occured during Sign up. Please try again later';
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign Out Error: ${e.toString}');
      throw 'An error occured during Sign out. Please try again shortly.';
    }
  }
}
