import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package
import 'package:yamudacarpooling/Pages/Auth/LogIn.dart';
import 'package:yamudacarpooling/Pages/Auth/LogInAs.dart'; // Import your login screen file

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool singinPage = true;
  //toggle pages
  void switchPages() {
    setState(() {
      singinPage = !singinPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    void resetPassword() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        // Show a success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password Reset Email Sent'),
            content: Text(
              'An email has been sent to ${emailController.text} with instructions to reset your password.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LogIn(toggle: switchPages),
                    ),
                  );
                },
                child: Text('OK', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      } catch (e) {
        // Show an error message if password reset fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password Reset Failed'),
            content: Text(
              'Error: ${e.toString()}',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        backgroundColor: Colors.grey[800], // Use dark grey as background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/LogoBlack.svg', // Path to your SVG logo file
              width: 150, // Set the width as per your design
            ),
            SizedBox(height: 20), // Add space between logo and form
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.grey[800], // Use dark grey as button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
