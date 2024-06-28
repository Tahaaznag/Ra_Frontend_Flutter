import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/pages/Login.dart';
import 'package:remote_assist/pages/Registration.dart';
import 'package:remote_assist/pages/UserProfilePage.dart';
import 'package:remote_assist/pages/VideoCallScreen.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:remote_assist/pages/chat_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    LoginPage(),
    WelcomePage(),
    ProfileScreen()
  ];
  void _logout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }


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
          CurvedNavigationBarItem(icon: Icon(Icons.person, size: 30, color: Colors.red[500]), label: "profil"),
          CurvedNavigationBarItem(icon: Icon(Icons.video_call, size: 30, color: Colors.red[500]), label: "VideoCall"),
          CurvedNavigationBarItem(icon: Icon(Icons.chat, size: 30, color: Colors.red[500]), label: "Chat"),
          CurvedNavigationBarItem(icon: Icon(Icons.logout, size: 30, color: Colors.red[500]), label: "Logout"),
        ],
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            } else if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoConferenceScreen()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
            } else if (index == 3) {
              _logout(context);
            } else {
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
