import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';

class PassengerView2 extends StatefulWidget {
  final String passengerName;
  final bool isPickup;
  final String passengerId;
  final String status;
  final String destination;
  const PassengerView2(
      {super.key,
      required this.passengerName,
      required this.isPickup,
      required this.passengerId,
      required this.status,
      required this.destination});

  @override
  State<PassengerView2> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PassengerView2> {
  final ConfirmRoute confirmRoute = ConfirmRoute();

  AuthServices auth = AuthServices();

  Future<void> makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    Uri telUri = Uri.parse(telScheme); // Convert string to Uri

    if (await canLaunchUrl(telUri)) {
      // Pass Uri object to canLaunchUrl
      await launch(telScheme);
    } else {
      throw 'Could not launch $telScheme';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: widget.isPickup, onChanged: null),
                    Text(widget.passengerName),
                  ],
                ),
                OutlinedButton(
                    onPressed: () async {
                      UserModel user =
                          await auth.getReleventAppUser(widget.passengerId);
                      makePhoneCall(user.contact);
                    },
                    child: const Text("     Call    "))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
