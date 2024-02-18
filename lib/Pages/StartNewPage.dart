import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class StartNewPage extends StatefulWidget {
  const StartNewPage({Key? key}) : super(key: key);

  @override
  State<StartNewPage> createState() => _StartNewPageState();
}

class _StartNewPageState extends State<StartNewPage> {
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool location1Selected = false;
  bool location2Selected = false;
  bool vehicle1Selected = false;
  bool vehicle2Selected = false;

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
                          hintText: 'Start Location',
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
                          hintText: 'End Location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
              // Your Route
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Your Route",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Image with Black Border
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: width, // Set width to full width of the screen
                  height:
                      height * 0.25, // Set height to 25% of the screen height
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 110, 110, 110), width: 2),
                    // Add black border
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/1.png",
                      fit: BoxFit
                          .cover, // Adjust the image's size to cover the entire box
                    ),
                  ),
                ),
              ),
              // Select Route
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
                        "Select Route",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // First set of radio buttons with border
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(
                                255, 110, 110, 110)), // Add border
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Row(
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
                              Text('Location 1'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Second set of radio buttons with border
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(
                                255, 110, 110, 110)), // Add border
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: location2Selected,
                                groupValue: location2Selected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    location2Selected = value ?? false;
                                  });
                                },
                              ),
                              Text('Location 2'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Select Vehicle
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
                        "Select Vehicle",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // First set of radio buttons with border
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(
                                255, 110, 110, 110)), // Add border
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Row(
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
                              Text('Location 1'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Second set of radio buttons with border
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(
                                255, 110, 110, 110)), // Add border
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: location2Selected,
                                groupValue: location2Selected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    location2Selected = value ?? false;
                                  });
                                },
                              ),
                              Text('Location 2'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        "Start Ride",
                        style: TextStyle(
                          color: Secondary,
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
