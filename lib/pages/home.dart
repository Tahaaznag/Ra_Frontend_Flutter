import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/SessionPage.dart';
import 'package:remote_assist/pages/VideoCallPage.dart';

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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("BL Remote Assist")),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.red,
        items: [
          CurvedNavigationBarItem(icon: Icon(Icons.add, size: 30), label: "New Meeting"),
          CurvedNavigationBarItem(icon: Icon(Icons.logout_rounded, size: 30), label: "Logout"),
          CurvedNavigationBarItem(icon: Icon(Icons.settings, size: 30), label: "Settings"),
          CurvedNavigationBarItem(icon: Icon(Icons.app_registration, size: 30), label: "Registration"),
        ],
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }
}
