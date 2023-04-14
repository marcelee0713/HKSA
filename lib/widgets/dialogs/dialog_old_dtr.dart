import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';

class DialogOldDTR {
  final String name;
  final VoidCallback callback;

  DialogOldDTR({required this.name, required this.callback});

  buildReminder(BuildContext context) {
    final logInBox = Hive.box("myLoginBox");
    bool? isChecked = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: ColorPalette.primary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: 300,
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.upload_file_rounded,
                        size: 150,
                        color: ColorPalette.accentWhite,
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Hello there!",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Flexible(
                        child: Text(
                          "If you haven't uploaded your OLD DTR, please go to your Profile and upload it ASAP!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          callback();
                          if (isChecked!) {
                            logInBox.put("showDTRDialog", false);
                          } else {
                            logInBox.put("showDTRDialog", true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBackgroundColor:
                              const Color.fromARGB(137, 114, 177, 139),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                                value: isChecked,
                                activeColor: ColorPalette.primary,
                                checkColor: ColorPalette.primary,
                                fillColor: MaterialStateProperty.all(
                                    ColorPalette.accentWhite),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked = newBool;
                                  });
                                }),
                          ),
                          const Text(
                            "Dont show this again",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
