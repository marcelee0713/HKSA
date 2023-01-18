import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 125,
          height: 125,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "REGISTRATION",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.accentWhite,
            fontFamily: 'Frank Ruhl Libre',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
