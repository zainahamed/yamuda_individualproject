import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';

class PassengerView extends StatefulWidget {
  final String passengerName;
  final bool isPickup;
  final String passengerId;
  final String status;
  final String destination;
  const PassengerView(
      {super.key,
      required this.passengerName,
      required this.isPickup,
      required this.passengerId,
      required this.status,
      required this.destination});

  @override
  State<PassengerView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PassengerView> {
  final ConfirmRoute confirmRoute = ConfirmRoute();

  //setpassenger to drop
  void pickupPassneger() async {
    try {
      await confirmRoute.setPassengerPendingToPicpuped(widget.passengerId);
      // ignore: empty_catches
    } catch (e) {}
  }

  //drop passenger
  void dropPassenger() async {
    try {
      await confirmRoute.setPassengerPendingToDrop(widget.passengerId);

      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
                    onPressed: () {
                      if (widget.isPickup != true) {
                        pickupPassneger();
                      } else {
                        dropPassenger();
                      }
                    },
                    child: Text(widget.status))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                  "Destination :${widget.destination.length >= 43 ? widget.destination.substring(0, 40) + "...." : widget.destination}"),
            )
          ],
        ),
      ),
    );
  }
}
