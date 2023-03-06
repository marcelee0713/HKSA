import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/chart/chart_v00.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  void initState() {
    super.initState();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    DatabaseReference userRefStatus =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID/status');

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () {
            logInBox.put("isLoggedIn", false);
            logInBox.put("hasTimedIn", false);
            logInBox.put("userType", "");
            logInBox.put("userID", "");
            logInBox.put("userName", "");
            logInBox.put("getTimeInLS", "");
            logInBox.put("dateTimedIn", "");

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false);

            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: ColorPalette.accentDarkWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: ColorPalette.accentDarkWhite,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 375,
                        width: 275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: ColorPalette.errorColor,
                              size: 200,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Account removed",
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "If you think this is wrong, proceed to CSDL!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: (() {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: ColorPalette.primary,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color: ColorPalette.accentWhite,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          });
        });
      }
    });

    userRefStatus.get().then((snapshot) {
      if (snapshot.value.toString() == "inactive") {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              logInBox.put("isLoggedIn", false);
              logInBox.put("hasTimedIn", false);
              logInBox.put("userType", "");
              logInBox.put("userID", "");
              logInBox.put("userName", "");
              logInBox.put("getTimeInLS", "");
              logInBox.put("dateTimedIn", "");

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (Route<dynamic> route) => false);

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: ColorPalette.accentDarkWhite,
                    actions: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: ColorPalette.accentDarkWhite,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 375,
                          width: 275,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning_rounded,
                                color: ColorPalette.errorColor,
                                size: 200,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Account Inactive",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "If you think this is wrong, proceed to CSDL!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: (() {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }),
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: ColorPalette.primary,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                        color: ColorPalette.accentWhite,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: ColorPalette.accentWhite,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ScholarHoursRadialChart(),
              const SizedBox(height: 5),
              const LogsListView(),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        "This is where your DTR logs are recorded that can be also printed and your total hours.",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          color: ColorPalette.primary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
