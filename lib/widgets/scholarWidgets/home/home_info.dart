import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/pages/scholarPages/info.dart';

class ScholarDTRInformation extends StatelessWidget {
  const ScholarDTRInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final logInBox = Hive.box("myLoginBox");
    late var scholarType = logInBox.get("scholarType");
    return Column(
      children: [
        const Text(
          HKSAStrings.dtrInfo,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Also when you logged out, your time in will be cleared out.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.accentBlack,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
        scholarType == "Faci"
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Info(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: const Text(
                    "About us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
