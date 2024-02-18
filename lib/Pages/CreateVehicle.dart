import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart'; // Import your Colors.dart file

class CreateVehicle extends StatefulWidget {
  const CreateVehicle({Key? key}) : super(key: key);

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  // Controller for the text fields
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _seatsCapacityController =
      TextEditingController();
  final TextEditingController _outerViewController = TextEditingController();
  final TextEditingController _innerViewController = TextEditingController();
  final TextEditingController _registrationDocController =
      TextEditingController();

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
          'Create Vehicle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
              height: height * 0.02, // Set height of SizedBox using MediaQuery
            ),
            // Input fields for vehicle details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _makeController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Make',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Vehicle Make',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Model',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Vehicle Model',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _registrationNumberController,
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Registration Number',
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _seatsCapacityController,
                    decoration: InputDecoration(
                      labelText: 'Seats Capacity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Seats Capacity',
                      prefixIcon: Icon(Icons.event_seat),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _outerViewController,
                    decoration: InputDecoration(
                      labelText: 'Upload Vehicle Outer View',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Upload Vehicle Outer View',
                      prefixIcon: Icon(Icons.image),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _innerViewController,
                    decoration: InputDecoration(
                      labelText: 'Upload Vehicle Inner View',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Upload Vehicle Inner View',
                      prefixIcon: Icon(Icons.image),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _registrationDocController,
                    decoration: InputDecoration(
                      labelText: 'Upload Vehicle Registration Doc',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Upload Vehicle Registration Doc',
                      prefixIcon: Icon(Icons.file_copy),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.2, // Set height of SizedBox using MediaQuery
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
                      "Save",
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
