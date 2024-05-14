import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';

class AuthServices extends ChangeNotifier {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //firestore instance
  final firestore = FirebaseFirestore.instance;

  UserModel currentUserModel = UserModel('....', 'contact', 0, 0, '',
      'username', 'company', 'occupation', 'imageUrl', 'linkedin');

  //log in
  Future<dynamic> signWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      notifyListeners();
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
      notifyListeners();

      return errorMessage;
    }
  }

  //Register
  Future registerWithEmail(
      String email,
      String password,
      String name,
      String contact,
      String company,
      String occupation,
      String linkedin) async {
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
        'imageUrl': '',
        'company': company,
        'occupation': occupation,
        'linkedin': linkedin
      });

      return user;
    } catch (e) {
      return e.toString();
    }
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  //get User from database
  Future<dynamic> getAppUser(String id) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("AppUser").doc(id).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // debugPrint(userData.toString());

          UserModel userModel = UserModel(
              userData['email'],
              userData['contact'],
              userData['rides'],
              userData['passengers'],
              userData['appUserId'],
              userData['name'],
              userData['company'],
              userData['occupation'],
              userData['imageUrl'],
              userData['linkedin']);
          currentUserModel = userModel;

          notifyListeners();
          return userModel;
        } else {
          return null;
        }
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  Future<dynamic> getReleventAppUser(String id) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("AppUser").doc(id).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // debugPrint(userData.toString());

          UserModel userModel = UserModel(
              userData['email'],
              userData['contact'],
              userData['rides'],
              userData['passengers'],
              userData['appUserId'],
              userData['name'],
              userData['company'],
              userData['occupation'],
              userData['imageUrl'],
              userData['linkedin']);

          notifyListeners();
          return userModel;
        } else {
          return null;
        }
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  //Update user
  Future<bool> updateUser(
      String name,
      String email,
      String contact,
      String company,
      String occupation,
      String imageUrl,
      String linkdnUrl) async {
    try {
      await firestore.collection('AppUser').doc(_auth.currentUser!.uid).update({
        'name': name,
        'contact': contact,
        'occupation': occupation,
        'company': company,
        'imageUrl': imageUrl,
        'linkedin': linkdnUrl,
      });
      return true;
    } catch (error) {
      print("Error updating userName in Firestore: $error");
      return false;
    }
  }
}
