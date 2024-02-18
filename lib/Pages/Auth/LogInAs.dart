import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class LoginAs extends StatefulWidget {
  const LoginAs({super.key});

  @override
  State<LoginAs> createState() => _LoginAsState();
}

class _LoginAsState extends State<LoginAs> {
  final _formKey = GlobalKey<FormState>();
  bool obcureText1 = true;
  bool obcureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              Text("Log In As",
                  style: TextStyle(
                      color: Primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),

            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

               GestureDetector(
                 child: Container(
                 
                  padding:const EdgeInsets.all(10),
                  margin:const EdgeInsets.all(5),
                 
                  decoration: BoxDecoration(
                    color: Secondary,
                    borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                            color: Primary,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: -1),
                      ]
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/Driver.png",
                        width: 0.38 * width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("As Driver")
                    ],
                  ),
                 
                               ),
               ),
              GestureDetector(
                child: Container(

                  padding:const EdgeInsets.all(10),
                  margin:const EdgeInsets.all(5),

                  decoration: BoxDecoration(
                      color: Secondary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                            color: Primary,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: -1),
                      ]
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/passenger.png",
                        width: 0.38 * width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("As Passenger")
                    ],
                  ),

                ),
              ),

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
                    
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text("Don't have an Account ?"),
              GestureDetector(
                onTap: null,
                child: Text("Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: height * 0.04,
              ),
            ],
          )
        ],
      ),
    );
  }
}
