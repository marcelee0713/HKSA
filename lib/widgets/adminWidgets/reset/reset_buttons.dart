import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';

class ResetButtons extends StatefulWidget {
  const ResetButtons({super.key});

  @override
  State<ResetButtons> createState() => _ResetButtonsState();
}

class _ResetButtonsState extends State<ResetButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorPalette.errorColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () {
                DialogConfirm(
                  headertext:
                      "This will reset every scholar's total hours and dtr logs.",
                  callback: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogLoading(subtext: "Resetting everything...")
                        .buildLoadingScreen(context);
                    resetDTRLogs()
                        .whenComplete(() => resetHours().whenComplete(() {
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogSuccess(
                                    headertext: "Success!",
                                    subtext:
                                        "You have resetted every scholar's DTR logs and total hours!",
                                    textButton: "Close",
                                    callback: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }).buildSuccessScreen(context);
                              });
                            }));
                  },
                ).buildConfirmScreen(context);
              },
              child: const Text(
                "RESET ALL",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorPalette.errorColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () {
                DialogConfirm(
                  headertext: "This will reset every scholar's DTR logs.",
                  callback: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogLoading(subtext: "Resetting DTR logs...")
                        .buildLoadingScreen(context);
                    resetDTRLogs().whenComplete(
                      () {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                              headertext: "Success!",
                              subtext:
                                  "You have resetted every scholar's DTR logs!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }).buildSuccessScreen(context);
                        });
                      },
                    );
                  },
                ).buildConfirmScreen(context);
              },
              child: const Text(
                "RESET LOGS",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorPalette.errorColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () {
                DialogConfirm(
                  headertext: "This will reset every scholar's total hours.",
                  callback: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogLoading(subtext: "Resetting total hours...")
                        .buildLoadingScreen(context);

                    resetHours().whenComplete(
                      () {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                              headertext: "Success!",
                              subtext:
                                  "You have resetted every scholar's total hours!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }).buildSuccessScreen(context);
                        });
                      },
                    );
                  },
                ).buildConfirmScreen(context);
              },
              child: const Text(
                "RESET HOURS",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
      ],
    );
  }

  Future<void> resetDTRLogs() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('dtrlogs/');

    await dbReference.get().then((snapshot) {
      for (final data in snapshot.children) {
        dbReference.child('${data.key}/').remove();
      }
      return;
    });
  }

  Future<void> resetHours() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('Users/Scholars/');

    await dbReference.get().then((snapshot) {
      for (final data in snapshot.children) {
        debugPrint("test");
        debugPrint(data.key);
        dbReference
            .child('${data.key}/totalHoursInDuration/')
            .set("0:00:00.000000");
        dbReference.child('${data.key}/totalHoursInDisplay/').set("0:00:00");
        dbReference.child('${data.key}/hours/').set("0");
      }
      return;
    });
  }
}
