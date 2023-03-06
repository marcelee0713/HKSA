import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogConfirm {
  final String headertext;
  final VoidCallback callback;

  DialogConfirm({required this.headertext, required this.callback});

  buildConfirmScreen(BuildContext context) {
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
                  height: 200,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        headertext,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
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
                          const Text(
                            "Please check to confirm",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: isChecked == true
                            ? (() => setState(
                                  () {
                                    callback();
                                  },
                                ))
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBackgroundColor:
                              const Color.fromARGB(137, 114, 177, 139),
                        ),
                        child: const Text(
                          "CONFIRM",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
