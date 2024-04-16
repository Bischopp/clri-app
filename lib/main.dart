import 'package:flutter/material.dart';
import 'package:project/homepage.dart'; // Import homepage.dart

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: Home(),
  ));
}
