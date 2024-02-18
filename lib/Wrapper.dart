import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Pages/WelcomeScreen.dart';

import 'Pages/HomePage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // User is signed in
            return HomePage();
          } else {
            // User is not signed in
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
