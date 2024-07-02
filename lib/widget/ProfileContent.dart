import 'package:flutter/material.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/widget/ProfileItem.dart';

class ProfileContent extends StatelessWidget {
  final UserRaDto user;
  final VoidCallback onEdit;

  ProfileContent({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${user.prenom} ${user.nom}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white70),
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ProfileItem(icon: Icons.favorite, title: 'Favorites'),
          ProfileItem(icon: Icons.location_on, title: 'Location'),
          ProfileItem(icon: Icons.settings, title: 'Settings'),
          ProfileItem(icon: Icons.help, title: 'Help & Support'),
          ProfileItem(icon: Icons.logout, title: 'Logout', onTap: () => Navigator.pushNamed(context, '/login')),
        ],
      ),
    );
  }
}
