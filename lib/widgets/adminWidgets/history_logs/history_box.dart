import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class HistoryBox extends StatelessWidget {
  final String desc;
  final String date;
  const HistoryBox({super.key, required this.desc, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: ColorPalette.accentWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorPalette.primary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SelectableText(
            desc,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: ColorPalette.primary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: ColorPalette.primary,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
