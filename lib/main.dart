import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/scholarPages/home.dart';
import 'package:firebase_core/firebase_core.dart';

bool userLoggedIn = false;
String user = "scholar";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
