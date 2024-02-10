import 'package:flutter/material.dart';
import 'homepage.dart';
import 'test_page.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        ListTile(
          title: Text('user'),
          onTap: () => null,
        ),
        ListTile(
          title: Text('Sampling Mode'),
          onTap: () {
            Navigator.of(context).pop(); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()), // Navigate to homepage.dart
            );
          },
        ),
        ListTile(
          title: Text('Testing Mode'),
          onTap: () {
            Navigator.of(context).pop(); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Test()), // Navigate to testpage.dart
            );
          },
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () => null,
        ),
      ],
    ));
  }
}
