import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/adminWidgets/reset/reset_schedule_header.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class ResetButtons extends StatefulWidget {
  const ResetButtons({super.key});

  @override
  State<ResetButtons> createState() => _ResetButtonsState();
}

class _ResetButtonsState extends State<ResetButtons> {
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
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
                    "This will reset every scholar's total hours, dtr logs, and history logs.",
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();

                  DialogLoading(subtext: "Resetting everything...")
                      .buildLoadingScreen(context);

                  await resetDTRLogs().catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
                  await resetHours().catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
                  await resetHistoryLogs().then((value) async {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogSuccess(
                      headertext: "Success!",
                      subtext:
                          "You have resetted every scholar's total hours, dtr logs, and all users history logs!",
                      textButton: "Close",
                      callback: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ).buildSuccessScreen(context);
                    await createHistory(
                      desc:
                          "Resetted every scholar's total hours, dtr logs, and all users history logs.",
                      timeStamp:
                          DateTime.now().microsecondsSinceEpoch.toString(),
                      userType: userType,
                      id: userID,
                    );
                  }).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
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
            ),
          ),
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
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Resetting DTR logs...")
                      .buildLoadingScreen(context);
                  await resetDTRLogs().then(
                    (value) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                            headertext: "Success!",
                            subtext:
                                "You have resetted every scholar's DTR logs!",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ).buildSuccessScreen(context);
                          await createHistory(
                            desc: "Resetted every scholar's DTR logs.",
                            timeStamp: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            userType: userType,
                            id: userID,
                          );
                        },
                      );
                    },
                  ).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
                },
              ).buildConfirmScreen(context);
            },
            child: const Text(
              "RESET DTR LOGS",
              style: TextStyle(
                color: ColorPalette.accentWhite,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
                headertext: "This will reset every users's History logs.",
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Resetting DTR logs...")
                      .buildLoadingScreen(context);
                  await resetHistoryLogs().then(
                    (value) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                            headertext: "Success!",
                            subtext:
                                "You have resetted every users's History logs!",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ).buildSuccessScreen(context);
                          await createHistory(
                            desc: "Resetted every users's History logs.",
                            timeStamp: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            userType: userType,
                            id: userID,
                          );
                        },
                      );
                    },
                  ).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
                },
              ).buildConfirmScreen(context);
            },
            child: const Text(
              "RESET HISTORY LOGS",
              style: TextStyle(
                color: ColorPalette.accentWhite,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Resetting total hours...")
                      .buildLoadingScreen(context);

                  await resetHours().then(
                    (value) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                            headertext: "Success!",
                            subtext:
                                "You have resetted every scholar's total hours!",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ).buildSuccessScreen(context);
                          await createHistory(
                            desc:
                                "Resetted every scholar's schedule total hours!",
                            timeStamp: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            userType: userType,
                            id: userID,
                          );
                        },
                      );
                    },
                  ).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
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
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: ColorPalette.errorColor),
        const SizedBox(height: 8),
        const ResetScheduleHeader(),
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
                headertext:
                    "This will reset every scholar's schedule information",
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Resetting total hours...")
                      .buildLoadingScreen(context);

                  await resetScholarsSchedules().then(
                    (value) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                            headertext: "Success!",
                            subtext:
                                "You have resetted every scholar's schedule information!",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ).buildSuccessScreen(context);
                          await createHistory(
                            desc:
                                "Resetted every scholar's schedule information.",
                            timeStamp: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            userType: userType,
                            id: userID,
                          );
                        },
                      );
                    },
                  ).catchError((e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: e.toString(),
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  });
                },
              ).buildConfirmScreen(context);
            },
            child: const Text(
              "RESET SCHOLAR SCHEDULES",
              style: TextStyle(
                color: ColorPalette.accentWhite,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> resetDTRLogs() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('dtrlogs/');

    await dbReference.get().then((snapshot) async {
      for (final data in snapshot.children) {
        await dbReference.child('${data.key}/').remove();
      }
      return;
    });
  }

  Future<void> resetHistoryLogs() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('historylogs/');

    await dbReference.get().then((snapshot) async {
      for (final data in snapshot.children) {
        await dbReference.child('${data.key}/').remove();
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

  Future<void> resetScholarsSchedules() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('Users/Scholars/');

    await dbReference.get().then((snapshot) async {
      for (final data in snapshot.children) {
        await dbReference.child('${data.key}/assignedProfD1/').set("");
        await dbReference.child('${data.key}/assignedProfD2/').set("");
        await dbReference.child('${data.key}/assignedProfWD/').set("");

        await dbReference.child('${data.key}/onSiteDay1/').set("NONE");
        await dbReference.child('${data.key}/onSiteDay2/').set("NONE");
        await dbReference.child('${data.key}/vacantTimeDay1/').set("NONE");
        await dbReference.child('${data.key}/vacantTimeDay2/').set("NONE");
        await dbReference.child('${data.key}/wholeDayVacantTime/').set("NONE");
      }
      return;
    });
  }
}
