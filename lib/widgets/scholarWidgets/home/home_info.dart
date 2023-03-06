import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class ScholarDTRInformation extends StatelessWidget {
  const ScholarDTRInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          HKSAStrings.dtrInfo,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Also when you logged out, your time in will be cleared out.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
