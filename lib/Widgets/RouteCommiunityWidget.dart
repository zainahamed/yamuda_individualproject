import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/Commiuniy/ChatPage.dart';
import 'package:yamudacarpooling/Services/CommiunityRouteService.dart';

class RouteWidget extends StatefulWidget {
  final String image;
  final String routeName;
  final String date;
  final String userId;
  final routeID;
  final Future<void> Function() delete;
  const RouteWidget(
      {super.key,
      required this.image,
      required this.routeName,
      required this.delete,
      required this.userId,
      this.routeID,
      required this.date});

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  // instane of firebaase auth
  var _auth = FirebaseAuth.instance;

  //instance of Train service
  var trainService = TrainService();

  //Register member to chatlist
  Future<void> register() async {
    await trainService.addMembers(_auth.currentUser!.uid, widget.routeID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatPage(
                  routeName: widget.routeName,
                  members: 0,
                  routeImage: widget.image,
                  routeID: widget.routeID,
                  userId: widget.userId,
                )));
      },
      child: _routeWidget(context),
    );
  }

  Padding _routeWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        height: 230,
        decoration: BoxDecoration(
            color: Secondary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                  color: Primary,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: -1),
            ]),
        //Animation
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Delete

                  //Image
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    radius: MediaQuery.of(context).size.width / 12,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 50),

                  //Route name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.routeName,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(widget.date),
                ]),
          ],
        ),
      ),
    );
  }

  void _showDeleteRouteDialog(BuildContext context) {
    String routeName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Route'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                widget.delete();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
