import 'package:flutter/material.dart';
import 'package:robolearn/features/auth/screens/login_screen.dart';
import 'package:robolearn/features/auth/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}