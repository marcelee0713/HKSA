import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'pages/login.dart';
import 'pages/scholarPages/home.dart';
import 'package:firebase_core/firebase_core.dart';

bool? userLoggedIn;
String? userType;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  var logInBox = await Hive.openBox("myLoginBox");

  userLoggedIn = await logInBox.get("isLoggedIn");
  userType = await logInBox.get("userType");

  userLoggedIn ??= false;

  runApp(
    MaterialApp(
      title: "HKSA",
      home: const MyApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: ColorPalette.primary, secondary: ColorPalette.secondary),
        scaffoldBackgroundColor: ColorPalette.secondary,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (userLoggedIn!) {
      if (userType == "scholar") {
        return const HomeScholar();
      }
    }
    return const Login();
  }
}
