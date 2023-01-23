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
                    color: ColorPalette.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 200,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        headertext,
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
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ))
                              : null,
                          child: const Text(
                            "CONFIRM",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
/*
          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: ColorPalette.secondary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: 200,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    headertext,
                    style: const TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isChecked,
                          activeColor: ColorPalette.accentBlack,
                          onChanged: (newBool) {
                            isChecked = newBool;
                          })
                    ],
                  )
                ],
              ),
            ),
          );
          */