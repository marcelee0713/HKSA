import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class ScholarDTRInformation extends StatelessWidget {
  const ScholarDTRInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      HKSAStrings.dtrInfo,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ColorPalette.primary,
        fontFamily: 'Inter',
        fontSize: 12,
      ),
    );
  }
}
