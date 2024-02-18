import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Pages/Commiunity.dart';
import 'package:yamudacarpooling/Pages/Profile/ProfileView.dart';
import 'package:yamudacarpooling/Pages/Rides.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    Commiunity(),
    Rides(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: height * 0.1,
            decoration: const BoxDecoration(
              color: Secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: ClipPath(
        clipper: MyCustomClipper(),
        child: Container(
          height: height * 0.08,
          decoration: BoxDecoration(
            color: Secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border.all(
              color: Primary,
              width: 2.0,
            ),
          ),
          child: CustomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Icons.chat),
                title: const Text('Community'),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.directions_car),
                title: const Text('Ride'),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Icons.manage_accounts),
                title: const Text('Account'),
              ),
            ],
            selectedColor: Primary,
            unSelectedColor: third,
            strokeColor: const Color.fromARGB(0, 22, 0, 0),
            iconSize: 30.0,
            elevation: 0,
            borderRadius: const Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
