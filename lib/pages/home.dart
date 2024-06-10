import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/SessionPage.dart';
import 'package:remote_assist/pages/VideoCallPage.dart';
import 'package:remote_assist/pages/WelcomePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    VideoCallPage(),
    CreateSessionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "BL Remote Assist",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[500],
        elevation: 5,
        centerTitle: true,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.red[500],
        buttonBackgroundColor: Colors.white,
        height: 60,
        items: [
          CurvedNavigationBarItem(icon: Icon(Icons.video_call, size: 30, color: Colors.red[500]), label: "New Meeting"),
          CurvedNavigationBarItem(icon: Icon(Icons.logout_rounded, size: 30, color: Colors.red[500]), label: "Logout"),
          CurvedNavigationBarItem(icon: Icon(Icons.settings, size: 30, color: Colors.red[500]), label: "Settings"),
          CurvedNavigationBarItem(icon: Icon(Icons.app_registration, size: 30, color: Colors.red[500]), label: "Registration"),
        ],
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
            } if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

            }
            else {
              _pageController.jumpToPage(index);
            }
          });
        },
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
            children: _pages,
          ),
        ],
      ),
    );
  }
}
