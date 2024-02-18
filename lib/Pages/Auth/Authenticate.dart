import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Pages/Auth/CreateAccount.dart';
import 'package:yamudacarpooling/Pages/Auth/LogIn.dart';

class Authenticate extends StatefulWidget {
  final bool state;
  const Authenticate({super.key, required this.state});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool singinPage = true;
  //toggle pages
  void switchPages() {
    setState(() {
      singinPage = !singinPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == true) {
      if (singinPage == true) {
        return LogIn(toggle: switchPages);
      } else {
        return CreateAccount(toggle: switchPages);
      }
    } else {
      if (singinPage == false) {
        return LogIn(toggle: switchPages);
      } else {
        return CreateAccount(toggle: switchPages);
      }
    }
  }
}
