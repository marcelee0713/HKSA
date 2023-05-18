import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogConflict {
  final String headertext;
  final String subtext;
  final String textButton;
  final VoidCallback callback;
  final List<String> conflicts;
  const DialogConflict(
      this.headertext, this.subtext, this.textButton, this.callback,
      {required this.conflicts});

  build(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorPalette.accentDarkWhite,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 500,
                width: 275,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: ColorPalette.errorColor,
                      size: 200,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      headertext,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: ColorPalette.primary,
                      padding: const EdgeInsets.all(5),
                      height: 75,
                      child: ListView.builder(
                        itemCount: conflicts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: ColorPalette.accentWhite,
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              conflicts[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtext,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: (() {
                        callback();
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        disabledBackgroundColor:
                            const Color.fromARGB(137, 114, 177, 139),
                      ),
                      child: Text(
                        textButton,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
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
