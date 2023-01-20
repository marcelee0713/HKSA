import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogLoading {
  final String subtext;
  DialogLoading({required this.subtext});

  buildLoadingScreen(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                color: ColorPalette.accentWhite,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtext,
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
