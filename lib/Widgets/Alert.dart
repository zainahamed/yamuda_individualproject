import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';

class Alert extends StatelessWidget {
  final String Message;
  final String Title;
  const Alert({super.key, required this.Message, required this.Title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Secondary,
      title: Text(
        Title,
        style: GoogleFonts.ibmPlexMono(
          color: Colors.red,
          fontSize: 20,
        ),
      ),
      actions: [],
      content: Text(
        Message.toString(),
        maxLines: 2,
        style: GoogleFonts.ibmPlexMono(
          color: Colors.red,
        ),
      ),
      elevation: 21,
    );
  }
}
