import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/Service/AuthService.dart';
import 'package:remote_assist/Service/UserService.dart';
import 'package:remote_assist/icons/util/ThemeNotifier.dart';
import 'package:remote_assist/pages/UserProfilePage.dart';
import 'package:remote_assist/pages/VideoCallScreen.dart';
import 'package:remote_assist/pages/chat_screen.dart';
import 'package:remote_assist/pages/home.dart';
import 'package:remote_assist/pages/home_content.dart';
import 'package:remote_assist/pages/session_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  UserRaDto? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userService = UserService();
    try {
      final user = await userService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("BL Remote Assist"),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentIndex == 0
          ? HomeContent(user: _user!)
          : _currentIndex == 1
          ? ChatScreen()
          : _currentIndex == 2
          ? SessionManagementScreen()
          : ProfileScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: "Video Call"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}



class DetailScreen extends StatelessWidget {
  final String label;

  DetailScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          "Information about $label",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}