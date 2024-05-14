import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';

class ConfirmationAlert extends StatefulWidget {
  final String pickup;
  final String dropoff;
  final String name;
  final String company;
  final String seats;
  final String btnName;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  const ConfirmationAlert(
      {Key? key,
      required this.pickup,
      required this.dropoff,
      required this.name,
      required this.company,
      required this.seats,
      required this.btnName,
      required this.onConfirmPressed,
      required this.onCancelPressed})
      : super(key: key);

  @override
  State<ConfirmationAlert> createState() => _ConfirmationAlertState();
}

class _ConfirmationAlertState extends State<ConfirmationAlert> {
  final confirmation = ConfirmRoute();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the dialog from being closed when tapping outside
        return false;
      },
      child: AlertDialog(
        backgroundColor: Secondary,
        content: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pick Up at  :"),
                  Text((widget.pickup.length >= 30)
                      ? widget.pickup.substring(0, 30)
                      : widget.pickup),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Drop off at :"),
                  Text((widget.dropoff.length >= 30)
                      ? widget.dropoff.substring(0, 30)
                      : widget.dropoff),
                ],
              ),
              Container(
                color: third,
                width: 300,
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Name :"),
                  Text(widget.name),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Company  :"),
                  Text(widget.company),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Seats Needed  :"),
                  Text(widget.seats),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                  ),
                  onPressed: () {
                    widget.onConfirmPressed();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: 250,
                    child: Center(
                      child: Text(
                        widget.btnName,
                        style: const TextStyle(
                          color: Secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    widget.onCancelPressed();
                    // Close the dialog
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: 250,
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
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
      ),
    );
  }
}
