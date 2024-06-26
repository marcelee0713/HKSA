import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class ResetHeader extends StatelessWidget {
  const ResetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Danger Zone",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "You are responsible for your own actions.",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "Please choose wisely.",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
