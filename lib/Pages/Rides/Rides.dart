import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Pages/Driver/StartNewRide.dart';
import 'package:yamudacarpooling/Pages/Passenger/RequetRide.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';

class Rides extends StatefulWidget {
  const Rides({super.key});

  @override
  State<Rides> createState() => _HomePageState();
}

class _HomePageState extends State<Rides> {
  String imageUrl = '';
  AuthServices auth = AuthServices();

  UserModel user = UserModel(
      '....',
      'contact',
      0,
      0,
      '',
      'username',
      'company',
      'occupation',
      'imageUrl',
      'linkedin',
      '055555',
      'emgEmail',
      'emgName',
      'emgRelationship');

  void initializeUser() async {
    user = await auth.getAppUser(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      imageUrl = user.imageUrl!;
    });
  }

//initialize
  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //first
          Column(
            children: [
              SizedBox(
                height: height * 0.08,
              ),
              SvgPicture.asset(
                "assets/LogoBlack.svg",
                width: 0.2 * width,
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(5),
            width: 0.9 * width,
            //height: 0.25 * height,
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
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("MY STATUS",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(user.totalRides.toString(),
                      style: const TextStyle(
                          color: Primary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const Text("Rides Completed",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(user.totalPassengers.toString(),
                      style: const TextStyle(
                          color: Primary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const Text("Passengers travelled with \nyou",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // You can customize the shadow color
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: const Offset(0, 13),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 0.15 * width,
                      height: 0.15 * width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: imageUrl == ''
                            ? Image.network(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              )
                            : Image.network(
                                imageUrl!,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),

          const Text("Become a Rider\n or Passenger",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Primary, fontSize: 24, fontWeight: FontWeight.bold)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StartNewRide()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
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
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/Driver.png",
                        width: 0.38 * width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "As Driver",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RequestRide()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
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
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/passenger.png",
                        width: 0.38 * width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "As Passenger",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: height * 0.05,
          )
        ],
      ),
    );
  }
}
