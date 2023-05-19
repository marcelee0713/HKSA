import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class ResetScheduleHeader extends StatelessWidget {
  const ResetScheduleHeader({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> scholarScheduling = [
      "(Scholars) Assigned Professors Day 1 - 2 and Whole Day",
      "(Scholars) On Site Day 1 - 2",
      "(Scholars) Vacant Time Day 1 - 2 and Whole Day."
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Resetting Schedules",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "This is where you reset the scheduling information.",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          "These are the list that will reset.",
          style: TextStyle(
            color: ColorPalette.errorColor,
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 75,
          child: ListView.builder(
            itemCount: scholarScheduling.length,
            itemBuilder: (context, index) {
              return Text(
                "${index + 1}. ${scholarScheduling[index]}",
                style: const TextStyle(
                  color: ColorPalette.errorColor,
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
