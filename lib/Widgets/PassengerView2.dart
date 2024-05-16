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
  State<PassengerView2> createState() => _PassengerView2State();
}

class _PassengerView2State extends State<PassengerView2> {
  final ConfirmRoute confirmRoute = ConfirmRoute();

  AuthServices auth = AuthServices();

  UserModel? user;

  Future<void> getUser() async {
    user = await auth.getReleventAppUser(widget.passengerId);
    setState(() {}); // Update the UI when user is fetched
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    Uri telUri = Uri.parse(telScheme);

    if (await canLaunchUrl(telUri)) {
      await launch(telScheme);
    } else {
      throw 'Could not launch $telScheme';
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return SizedBox(
        height: 60,
        width: 400,
        child: Center(
            child:
                CircularProgressIndicator()), // Show a loading indicator while fetching the user
      );
    }
    return SizedBox(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user!.username}*${user!.emgRelationship} -"),
                    Text(user!.emgName!)
                  ],
                ),
                OutlinedButton(
                    onPressed: () async {
                      makePhoneCall(user!.emgContact!);
                    },
                    child: const Text("    Call    "))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
