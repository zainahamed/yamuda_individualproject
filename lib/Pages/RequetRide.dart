import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class RequestRide extends StatefulWidget {
  const RequestRide({Key? key}) : super(key: key);

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool location1Selected = false;
  bool location2Selected = false;
  bool vehicle1Selected = false;
  bool vehicle2Selected = false;

  List<String> availableRiders = ['Rider 1', 'Rider 2', 'Rider 3']; // List of available riders

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
        title: Text(
          "Start New Ride",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start and End Location
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Start and End Location",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Nearby locations of a radius of 500m will be detected",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // First Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Start Location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
              // Second Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by End Location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black), // Add border
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        "Available Riders ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // Generate radio buttons for each available rider
                    Column(
                      children: availableRiders
                          .map(
                            (rider) => Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 110, 110, 110),
                                ), // Add border
                                borderRadius: BorderRadius.circular(10),
                                // Rounded corners
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: location1Selected,
                                    groupValue: location1Selected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        location1Selected = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(rider),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              // Select Vehicle
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "No of Passengers",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Quantity Increase and Decrease Buttons
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Implement your logic here
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text('Quantity'),
                    IconButton(
                      onPressed: () {
                        // Implement your logic here
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              // Start Ride Button
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
                        "Request Ride",
                        style: TextStyle(
                          // color: Secondary, // Replace Secondary with desired color
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Login button

              // Text and Sign Up option

              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
