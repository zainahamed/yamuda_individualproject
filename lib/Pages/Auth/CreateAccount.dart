import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/Auth/CreateSuccess.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Widgets/Alert.dart';

class CreateAccount extends StatefulWidget {
  final void Function() toggle;

  const CreateAccount({super.key, required this.toggle});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  bool obcureText1 = true;
  bool obcureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  String message = "";

  //instance
  final auth = AuthServices();
  void register() async {
    if (passwordController.text == confrimPasswordController.text) {
      dynamic result = await auth.registerWithEmail(emailController.text,
          passwordController.text, nameController.text, contactController.text);

      if (result.runtimeType != String) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginSuccess()));
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                Alert(Title: "Try Again", Message: result.toString()));
      }
    } else {
      setState(() {
        message = " Confirm Password is Not Match";
      });
      showDialog(
          context: context,
          builder: (context) => Alert(Title: "Try Again", Message: message));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServices>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),
                    SvgPicture.asset(
                      "assets/LogoBlack.svg",
                      width: 0.2 * width,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text("Create Account",
                        style: TextStyle(
                            color: Primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Name";
                          } else if (value.length > 15) {
                            return 'Name should not be greater than 15 characters';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Enter Name',
                          hintText: 'e.g., john',
                          prefixIcon:
                              Icon(Icons.verified_user), // Add a hint text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Email";
                          } else {
                            // Basic email format validation using a regular expression
                            String emailRegex =
                                r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                            RegExp regex = RegExp(emailRegex);

                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }

                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Enter Email',
                          hintText: 'e.g., john_doe@gmail.com',
                          prefixIcon: Icon(Icons.email), // Add a hint text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: contactController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Contact Number";
                          } else {
                            // Remove any non-digit characters from the input
                            String cleanedValue =
                                value.replaceAll(RegExp(r'\D'), '');

                            // Validate the cleaned value
                            if (cleanedValue.length != 10 ||
                                !cleanedValue.startsWith('0')) {
                              return 'Enter a valid Contact Number';
                            }

                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Enter Contact',
                          hintText: '07xxxxxxxx',
                          prefixIcon: Icon(Icons.person), // Add a hint text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: obcureText2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters long";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Enter Password',
                          hintText: 'Abc@123',
                          prefixIcon: IconButton(
                            icon: showIcon
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obcureText2 = !obcureText2;
                                showIcon = !showIcon;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        controller: confrimPasswordController,
                        obscureText: obcureText2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Confirm Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters long";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Enter Confrim Password',
                          hintText: 'Abc@123',
                          prefixIcon: IconButton(
                            icon: showIcon
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obcureText2 = !obcureText2;
                                showIcon = !showIcon;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //second
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.01),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: const Center(
                        child: Text(
                          "CreateAccount",
                          style: TextStyle(
                            color: Secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Already have an Account ?",
                    style: TextStyle(color: Primary)),
                GestureDetector(
                  onTap: widget.toggle,
                  child: Text("Sign In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Primary)),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
