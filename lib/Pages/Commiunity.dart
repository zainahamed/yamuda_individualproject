import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class Commiunity extends StatefulWidget {
  const Commiunity({super.key});

  @override
  State<Commiunity> createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<Commiunity> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //first
            Column(
              children: [
                SizedBox(
                  height: height * 0.03,
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

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("This is Commiunity",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: height * 0.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
