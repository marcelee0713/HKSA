import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_sign.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';

DateTime thisTimeOfTheDay = DateTime.now();

class ScholarHomeInputs extends StatefulWidget {
  const ScholarHomeInputs({super.key});

  @override
  State<ScholarHomeInputs> createState() => _ScholarHomeInputsState();
}

class _ScholarHomeInputsState extends State<ScholarHomeInputs> {
  DatabaseReference dbReference = FirebaseDatabase.instance.ref();
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");

  @override
  Widget build(BuildContext context) {
    DateTime now;
    DateTime later;
    DateTime compare; // For comparing if they're the same day;
    late String timeIn = logInBox.get("getTimeInLS");
    late String timeOut = "";
    late bool hasTimedIn = logInBox.get("hasTimedIn");

    late bool hasTimedOut = !hasTimedIn ? true : false;

    String formattedTimeInDateForDB = "";
    String formattedTimeOutDateForDB = "";

    String dateTimedInLS = logInBox.get("dateTimedIn") ?? "";

    compare = DateTime.now();
    String compareTimeToday = DateFormat("yyyy-MM-dd").format(compare);

    // Also what this does is that, when he timed in
    // And he forgot to open the app and timed out at that day.
    // The dtr will reset.
    if (dateTimedInLS != compareTimeToday) {
      hasTimedIn = false;
      hasTimedOut = true;
      timeIn = "";
      timeOut = "";
      logInBox.put("hasTimedIn", false);
      logInBox.put("getTimeInLS", "");
    }

    // So basically what this functions does is.
    // That it won't make the user time in or out
    // IF they are not between 7:30 am to 8:00 pm
    // Who's still in school at 8:00pm anyways?

    final nowTOD = TimeOfDay.now();
    if (nowTOD.hour >= 20 ||
        (nowTOD.hour <= 7 && nowTOD.minute <= 29) ||
        nowTOD.hour == 0) {
      hasTimedIn = true;
      hasTimedOut = true;
      timeIn = "";
      timeOut = "";
      logInBox.put("hasTimedIn", false);
      logInBox.put("getTimeInLS", "");
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              "Time in:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.accentWhite),
            ),
            const SizedBox(height: 2),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorPalette.accentDarkWhite),
              child: Center(
                child: Text(
                  timeIn == "" ? "Haven't timed in yet?" : timeIn,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle:
                        timeIn == "" ? FontStyle.italic : FontStyle.normal,
                    color: timeIn == ""
                        ? const Color.fromARGB(255, 112, 112, 112)
                        : ColorPalette.accentBlack,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            const Text(
              "Time out:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.accentWhite),
            ),
            const SizedBox(height: 2),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorPalette.accentDarkWhite),
              child: Center(
                child: Text(
                  timeOut == "" ? "Haven't timed out yet?" : timeOut,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontStyle:
                        timeOut == "" ? FontStyle.italic : FontStyle.normal,
                    color: timeOut == ""
                        ? const Color.fromARGB(255, 112, 112, 112)
                        : ColorPalette.accentBlack,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 125,
              height: 60,
              child: ElevatedButton(
                onPressed: !hasTimedIn && hasTimedOut
                    ? (() => setState(() {
                          DialogConfirm(
                            headertext: "Are you sure you want to time in?",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              setState(() {
                                String dateOnly = "";
                                logInBox.put("hasTimedIn", true);
                                hasTimedIn = true;
                                hasTimedOut = false;

                                now = DateTime.now();
                                formattedTimeInDateForDB =
                                    DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd")
                                        .format(now);
                                dateOnly = DateFormat("yyyy-MM-dd").format(now);
                                logInBox.put(
                                    "getTimeInLS", formattedTimeInDateForDB);
                                logInBox.put("dateTimedIn", dateOnly);
                                timeIn = formattedTimeInDateForDB;
                              });
                            },
                          ).buildConfirmScreen(context);
                        }))
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.accentDarkWhite,
                  disabledBackgroundColor: ColorPalette.primary,
                ),
                child: Text(
                  "Time In",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: !hasTimedIn && hasTimedOut
                        ? ColorPalette.accentBlack
                        : ColorPalette.accentDarkWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 125,
              height: 60,
              child: ElevatedButton(
                onPressed: hasTimedIn && !hasTimedOut
                    ? () async {
                        // For time out
                        later = DateTime.now();
                        formattedTimeInDateForDB = timeIn;
                        formattedTimeOutDateForDB =
                            DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd")
                                .format(later);

                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DialogSign(),
                            ));

                        if (result == null) {
                          // ignore: use_build_context_synchronously
                          DialogUnsuccessful(
                              headertext: "Input required",
                              subtext: "Signature and Multiplier required!",
                              textButton: "Close",
                              callback: () => {
                                    Navigator.of(context, rootNavigator: false)
                                        .pop()
                                  }).buildUnsuccessfulScreen(context);
                          return;
                        }

                        setState(() {
                          int multiplier =
                              int.parse(result.toString().substring(0, 1));
                          String signature = result.toString().substring(1);

                          DialogLoading(subtext: "Loading...")
                              .buildLoadingScreen(context);

                          String totalHoursInDuration = totalHoursThisDay(
                                  formattedTimeInDateForDB,
                                  formattedTimeOutDateForDB,
                                  multiplier)
                              .toString();

                          // Putting it into our logs in our firestore
                          createLog(
                              timeIn: formattedTimeInDateForDB,
                              timeOut: formattedTimeOutDateForDB,
                              workingHoursTodayInDuration: totalHoursInDuration,
                              signature: signature,
                              date: compareTimeToday,
                              multiplier: multiplier.toString());

                          // Getting the totalHoursInDuration
                          Duration dbDuration;
                          Duration todayDuration;
                          Duration totalDuration;
                          dbReference
                              .child(
                                  'Users/Scholars/$userID/totalHoursInDuration')
                              .get()
                              .then((snapshot) async => {
                                    dbDuration = parseDuration(
                                        snapshot.value.toString()),
                                    debugPrint("Database Duration $dbDuration"),
                                    todayDuration =
                                        parseDuration(totalHoursInDuration),
                                    debugPrint("Today Duration $todayDuration"),
                                    totalDuration = dbDuration + todayDuration,
                                    debugPrint(totalDuration.toString()),
                                    await dbReference
                                        .child(
                                            'Users/Scholars/$userID/totalHoursInDuration')
                                        .set(totalDuration.toString()),
                                    await dbReference
                                        .child(
                                            'Users/Scholars/$userID/totalHoursInDisplay')
                                        .set(totalDuration
                                            .toString()
                                            .substring(0, 8)
                                            .replaceAll('.', '')),
                                    await dbReference
                                        .child('Users/Scholars/$userID/hours')
                                        .set(totalDuration.inHours.toString()),
                                  });
                          logInBox.put("hasTimedIn", false);
                          logInBox.put("getTimeInLS", "");
                          hasTimedIn = false;
                          hasTimedOut = true;
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogSuccess(
                                headertext: "Successfully timed out",
                                subtext:
                                    'You timed out on $formattedTimeOutDateForDB. and your total hours today is recorded!',
                                textButton: "Close",
                                callback: () => {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop()
                                    }).buildSuccessScreen(context);
                            timeIn = "";
                            timeOut = "";
                          });
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.accentDarkWhite,
                  disabledBackgroundColor: ColorPalette.primary,
                ),
                child: Text(
                  "Time out",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: hasTimedIn && !hasTimedOut
                        ? ColorPalette.accentBlack
                        : ColorPalette.accentDarkWhite,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Future createLog(
      {required String timeIn,
      required String timeOut,
      required String workingHoursTodayInDuration,
      required String signature,
      required String date,
      required String multiplier}) async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('dtrlogs/$userID');
    String? key = dbReference.push().key;

    final json = {
      'timein': timeIn,
      'timeout': timeOut,
      'hoursInDuration': workingHoursTodayInDuration,
      'signature': signature,
      'date': date,
      'multiplier': multiplier,
    };

    await dbReference.child(key!).set(json);
  }
}

String totalHoursThisDay(timeIn, timeOut, multiplier) {
  DateTime parsedDateIn =
      DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").parse(timeIn);
  DateTime parsedDateOut =
      DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").parse(timeOut);

  debugPrint("The Parsed In: " + parsedDateIn.toString());
  debugPrint("The Parsed Out: " + parsedDateOut.toString());

  Duration workingHours = parsedDateOut.difference(parsedDateIn);

  return (workingHours * multiplier).toString();
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}
