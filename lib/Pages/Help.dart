import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture
import 'package:yamudacarpooling/Colors/Colors.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        // Title
        title: Text(
          'Help And Support',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Set the background color of the app bar
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display image
            SizedBox(
              height: height * 0.25, // Set height of SizedBox using MediaQuery
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SvgPicture.asset(
                "assets/LogoBlack.svg",
                width: 0.2 * width,
                color: Primary,
              ),
            ),
            SizedBox(
              height: height * 0.01, // Set height of SizedBox using MediaQuery
            ),
            // Display text
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "We’re Here for you!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Please send us an email regarding your",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "queries to help@yamudha.com",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.25, // Set height of SizedBox using MediaQuery
            ),
            // Display button
            Padding(
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                ),
                onPressed: () {
                  // Implement your logic here
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: const Center(
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                        color: Secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
