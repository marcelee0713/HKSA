import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class GreetingsHeader extends StatelessWidget {
  const GreetingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Welcome to Settings",
            style: TextStyle(
              color: ColorPalette.primary,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Where you can universally add, modify, and delete data around the app. Please, choose wisely.",
            style: TextStyle(
              color: ColorPalette.primary,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(color: ColorPalette.primary, height: 1),
        const SizedBox(height: 10),
      ],
    );
  }
}
