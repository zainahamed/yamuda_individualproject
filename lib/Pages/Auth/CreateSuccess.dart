import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Wrapper.dart';

class LoginSuccess extends StatefulWidget {
  const LoginSuccess({super.key});

  @override
  State<LoginSuccess> createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
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
              Text("Account Creation \nSuccessful!",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 25,
              ),
              Text("Your Account has been successfully  \n Created!",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Primary,
                    fontSize: 14,
                  )),
            ],
          ),
          //seconde
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Wrapper()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: const Center(
                      child: Text(
                        "Go to Home",
                        style: TextStyle(
                          color: Secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),const SizedBox(
            height: 25,
          ),
            ],
          ),
          
        ],
      ),
    );
  }
}
