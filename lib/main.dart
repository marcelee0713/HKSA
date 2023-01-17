import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/scholarPages/home.dart';

bool userLoggedIn = false;
String user = "scholar";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (userLoggedIn) {
      if (user == "scholar") {
        return const HomeScholar();
      }
    }
    return const Login();
  }
}
