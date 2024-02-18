import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices extends ChangeNotifier {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //firestore instance
  final firestore = FirebaseFirestore.instance;

  //log in
  Future<dynamic> signWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (e) {
      // Handle specific Firebase authentication errors
      String errorMessage = "An error occurred. Invalid User Credentials";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "User not found. Please check your email.";
            break;
          case 'wrong-password':
            errorMessage = "Wrong password. Please try again.";
            break;
        }
      }

      return errorMessage;
    }
  }

  //Register
  Future registerWithEmail(
      String email, String password, String name, String contact) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      // store user in database
      firestore.collection("AppUser").doc(user!.uid).set({
        'appUserId': result.user!.uid,
        'email': result.user!.email,
        'name': name,
        'contact': contact,
        'rides': 0,
        'passengers': 0,
      });

      return user;
    } catch (e) {
      return e.toString();
    }
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
