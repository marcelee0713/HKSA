import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';

class DialogLoading {
  final String subtext;
  DialogLoading({required this.subtext});

  buildLoadingScreen(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
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
                    const SpinKitCircle(
                      color: ColorPalette.secondary,
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtext,
                      textAlign: TextAlign.center,
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
            ),
          );
        });
  }
}
