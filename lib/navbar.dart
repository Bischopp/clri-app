import 'package:flutter/material.dart';
import 'homepage.dart';
import 'test_page.dart';
import 'admin/dashboard.dart'; // Import UserTablePage
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import 'amplifyconfiguration.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('user'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserTablePage(), // Navigate to UserTablePage
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Sampling Mode'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(), // Navigate to homepage.dart
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Testing Mode'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Test(), // Navigate to testpage.dart
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () => Amplify.Auth.signOut(),
          ),
        ],
      ),
    );
  }
}
