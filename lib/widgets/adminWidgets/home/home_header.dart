import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';

class AdminHomeHeader extends StatefulWidget {
  const AdminHomeHeader({super.key});

  @override
  State<AdminHomeHeader> createState() => _AdminHomeHeaderState();
}

class _AdminHomeHeaderState extends State<AdminHomeHeader> {
  final logInBox = Hive.box("myLoginBox");

  late var userName = logInBox.get("userName");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "Welcome",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.primary,
            fontFamily: 'Frank Ruhl Libre',
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          userName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ColorPalette.primary,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
