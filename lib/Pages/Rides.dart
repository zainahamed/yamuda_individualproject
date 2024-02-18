import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/RequetRide.dart';
import 'package:yamudacarpooling/Pages/StartNewPage.dart';

class Rides extends StatefulWidget {
  const Rides({super.key});

  @override
  State<Rides> createState() => _HomePageState();
}

class _HomePageState extends State<Rides> {
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
                  const Text("243",
                      style: TextStyle(
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
                  const Text("718",
                      style: TextStyle(
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
                      color: Primary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // You can customize the shadow color
                          spreadRadius: 4,
                          blurRadius: 5,
                          offset: Offset(0, 13),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        "assets/1.png",
                        width: 0.15 * width,
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
                      builder: (context) => const StartNewPage()));
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
