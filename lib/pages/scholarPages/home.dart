import 'package:flutter/material.dart';
import '/constant/colors.dart';

class HomeScholar extends StatelessWidget {
  const HomeScholar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.royalGreen,
      ),
      home: const Scaffold(
        body: Center(child: Text("Hello I am in the student now!")),
      ),
    );
  }
}
