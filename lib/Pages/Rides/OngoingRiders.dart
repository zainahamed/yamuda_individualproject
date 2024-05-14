import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class OngoingRiders extends StatefulWidget {
  const OngoingRiders({Key? key}) : super(key: key);

  @override
  State<OngoingRiders> createState() => _OngoingRidersState();
}

class _OngoingRidersState extends State<OngoingRiders> {
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
          "On Going Rides",
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Available Passengers",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Passenger List Container
              Container(
                height: height * 0.2, // Set height to 50% of the screen height
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: 5, // Replace 5 with your actual number of passengers
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Passenger ${index + 1}"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Implement pick passenger logic
                        },
                        child: Text("Pick Passenger"),
                      ),
                    );
                  },
                ),
              ),
              // Start Ride Button
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                        "End Ride",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Share to Community Chat Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Secondary,
                  ),
                  onPressed: () {
                    // Implement your logic here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: const Center(
                      child: Text(
                        "Share to Community Chat",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Call Emergency Contact Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Secondary,
                  ),
                  onPressed: () {
                    // Implement your logic here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: const Center(
                      child: Text(
                        "Call Emergency Contact",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
