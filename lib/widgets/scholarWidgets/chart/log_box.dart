import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class LogBox extends StatelessWidget {
  final String timeIn;
  final String timeOut;
  final int index;
  const LogBox(
      {super.key,
      required this.timeIn,
      required this.timeOut,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Positioned(
              top: 6,
              child: Text(
                textAlign: TextAlign.center,
                timeIn,
              ),
            ),
            Container(height: 1, color: ColorPalette.accentBlack),
            Positioned(
              bottom: 6,
              child: Text(
                textAlign: TextAlign.center,
                timeOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
