import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture
import 'package:yamudacarpooling/Colors/Colors.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({Key? key}) : super(key: key);

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display image
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SvgPicture.asset(
                "assets/LogoBlack.svg",
                width: 0.2 * width,
                color: Primary,
              ),
            ),
            SizedBox(
              height: height * 0.3, // Set height of SizedBox using MediaQuery
            ),
            // Display text
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Awaiting for Ride Join Confirmation",
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
                "Please wait while the Rider Accepts your invite...",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            // Display button
            SizedBox(
              height: height * 0.3, // Set height of SizedBox using MediaQuery
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                  // backgroundColor: Primary, // Replace Primary with desired color
                ),
                onPressed: () {
                  // Implement your logic here
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: const Center(
                    child: Text(
                      "Confirm Ride",
                      style: TextStyle(
                        // color: Secondary, // Replace Secondary with desired color
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
