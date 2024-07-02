import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  ProfileItem({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap ?? () {},
    );
  }
}
