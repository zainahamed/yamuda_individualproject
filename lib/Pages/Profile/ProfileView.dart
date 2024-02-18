import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/CreateVehicle.dart';
import 'package:yamudacarpooling/Pages/Help.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Wrapper.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final auth = Provider.of<AuthServices>(context, listen: false);

    void signOut() async {
      await auth.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Wrapper()));
    }

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
          Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(5),
              width: 0.9 * width,
              //height: 0.25 * height,
              decoration: BoxDecoration(
                  color: Primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    const BoxShadow(
                        color: Primary,
                        offset: Offset(0, 0),
                        blurRadius: 5,
                        spreadRadius: -1),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Primary,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                                0.5), // You can customize the shadow color
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 5),
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
                  const Text("Your Name",
                      style: TextStyle(
                          color: Secondary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const Text("MY STATUS",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text("UX Designer",
                      style: TextStyle(
                          color: Secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(
                width * 0.015,
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.015, vertical: height * 0.015),
              width: 0.9 * width,
              child: const Text("Edit Your Profile",
                  style: TextStyle(
                      color: Primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: third,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //imeplement later
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateVehicle()));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.015, vertical: height * 0.01),
              width: 0.9 * width,
              child: const Text("Vehicles",
                  style: TextStyle(
                      color: Primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: third,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Help()));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.015, vertical: height * 0.01),
              width: 0.9 * width,
              child: const Text("Help and Supprt",
                  style: TextStyle(
                      color: Primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: third,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: signOut,
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.015, vertical: height * 0.01),
              width: 0.9 * width,
              child: const Text("Log out",
                  style: TextStyle(
                      color: Primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: third,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: height * 0.15,
          )
        ],
      ),
    );
  }
}
