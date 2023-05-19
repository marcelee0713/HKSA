import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogConfirmEdit {
  final String headertext;
  final String subtext;
  final List<String> changes;
  final VoidCallback callback;

  DialogConfirmEdit({
    required this.headertext,
    required this.subtext,
    required this.changes,
    required this.callback,
  });

  buildConfirmEditScreen(BuildContext context) {
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
                  height: 500,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.edit_document,
                        color: ColorPalette.accentWhite,
                        size: 150,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        headertext,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        subtext,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 75,
                        child: changes.isNotEmpty
                            ? ListView.builder(
                                itemCount: changes.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: ColorPalette.accentWhite,
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      changes[index],
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
                              )
                            : const Center(
                                child: Text(
                                  "You don't have any changes.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorPalette.accentWhite,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
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
