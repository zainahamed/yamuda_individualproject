import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:yamudacarpooling/Colors/Colors.dart";
import "package:yamudacarpooling/Pages/Auth/Authenticate.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Primary,
      body: Stack(
        children: [
          Container(
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromARGB(255, 3, 3, 3),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Car.png",
                height: height * 0.44,
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.075),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        "assets/LogoBlack.svg",
                        width: 0.2 * width,
                        color: Secondary,
                      ),
                    ),
                    SizedBox(
                      height: 0.2 * height * (height / width),
                    ),
                    const Text(
                      "Join Hands, \nFlexible Rides",
                      maxLines: 2,
                      style: TextStyle(
                        color: Secondary,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const Text(
                      "Join a friendly Community,while \nCommuting to work with a friendly chat",
                      maxLines: 2,
                      style: TextStyle(
                        color: Secondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Secondary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Authenticate(
                              state: true,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    width: width * 0.7,
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Secondary),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Authenticate(
                              state: false,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    width: width * 0.7,
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.002,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
