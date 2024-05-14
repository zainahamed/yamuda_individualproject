import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  final void Function() toggle;
  const CreateUser({super.key, required this.toggle});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ElevatedButton(
        onPressed: widget.toggle, child: Text("press"),
      ),
    );
  }
}
