import 'package:flutter/material.dart';
import '/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
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
          HKSAStrings.appTitle,
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
