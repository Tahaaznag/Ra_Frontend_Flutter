import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/pages/detail_screen.dart';

class HomeContent extends StatelessWidget {
  final UserRaDto user;

  HomeContent({required this.user});

  final List<Map<String, dynamic>> _gridItems = [
    {"icon": Icons.people, "label": "Visitors", "color": Color(0xFFB21A18)},
    {"icon": Icons.meeting_room, "label": "MOM", "color": Color(0xFFDB504A)},
    {"icon": Icons.help, "label": "Help Desk", "color": Color(0xFFDB504A)},
    {"icon": Icons.group, "label": "Resident Directory", "color": Color(0xFFFC766A)},
    {"icon": Icons.people_outline, "label": "Staff", "color": Color(0xFFDB504A)},
    {"icon": Icons.home, "label": "Amenities", "color": Color(0xFFFC766A)},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/icons/images/profile.png'), // Replace with your asset image path
                ),
                SizedBox(height: 10),
                Text(
                  "Hi ${user.nom}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _gridItems.length,
            itemBuilder: (context, index) {
              final item = _gridItems[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the appropriate screen or show relevant information
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(label: item["label"]),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: item["color"],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"], size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        item["label"],
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}