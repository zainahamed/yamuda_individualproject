import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/WelcomeScreen.dart';

import 'Pages/HomePage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return LoadingAnimationWidget.staggeredDotsWave(
              color: Primary,
              size: 40,
            );
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
