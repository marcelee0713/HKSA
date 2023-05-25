import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/main.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/pages/scholarPages/chart.dart';
import 'package:hksa/pages/scholarPages/schedule.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_old_dtr.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'messages.dart';
import 'dtr.dart';
import 'profile.dart';
import 'info.dart';

bool scholarHasListened = false;
StreamSubscription<DatabaseEvent>? scholarSubscription;

/*This class is the bottom navigation bar of the app
 * 1) Create a UI for navigation bar
 * 2) Instantiate an array that would hold pages' index
 * 3) Display appropriate buttons that can be interacted with
 * 4) Call pages on click to replace existing widget in this Scaffold()
 */
class HomeScholar extends StatefulWidget {
  const HomeScholar({super.key});

  @override
  State<HomeScholar> createState() => _HomeScholarState();
}

class _HomeScholarState extends State<HomeScholar> {
  // #2 is the page index of dtr.dart and is the first priority display
  int pageIndex = 2;
  final pages = [
    const Messages(),
    const Chart(),
    const DTR(),
    const Profile(),
    const Schedule(),
    const Info(),
  ];
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var scholarType = logInBox.get("scholarType");
  late var name = logInBox.get("userName");
  late var showOldDTR = logInBox.get("showDTRDialog");
  @override
  void initState() {
    firebaseMessaging.subscribeToTopic('user_all');
    firebaseMessaging.subscribeToTopic('scholars');
    if (scholarType == "Faci") {
      firebaseMessaging.subscribeToTopic('scholars_faci');
    } else {
      firebaseMessaging.subscribeToTopic('scholars_non_faci');
    }
    super.initState();
    showOldDTR ??= true;
    if (showOldDTR) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        DialogOldDTR(
                name: name,
                callback: () =>
                    Navigator.of(context, rootNavigator: true).pop())
            .buildReminder(context);
      });
    }

    if (firebaseAuth.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        DialogUnsuccessful(
          headertext: "Warning!",
          subtext:
              "Please re log in! It can create issues not to you but also others!",
          textButton: "Close",
          callback: () => Navigator.of(context, rootNavigator: true).pop(),
        ).buildUnsuccessfulScreen(context);
      });
    }

    if (!scholarHasListened) {
      DatabaseReference listenRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Scholars/$userID/status");
      DatabaseReference chatRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Scholars/$userID/listeningTo");
      scholarSubscription = listenRef.onValue.listen((event) {
        String status = event.snapshot.value.toString();
        debugPrint("Event: $status");
        if (status == "inactive") {
          Future.delayed(const Duration(), (() {
            DialogLoading(subtext: "Logging out...")
                .buildLoadingScreen(navigatorKey.currentContext!);
          })).whenComplete(() {
            Future.delayed(
              const Duration(seconds: 3),
              () async {
                scholarSubscription!.cancel();
                scholarHasListened = false;
                logInBox.put("isLoggedIn", false);
                logInBox.put("hasTimedIn", false);
                logInBox.put("userType", "");
                logInBox.put("userName", "");
                logInBox.put("getTimeInLS", "");
                logInBox.put("dateTimedIn", "");

                navigatorKey.currentState!.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false);

                showDialog(
                  context: navigatorKey.currentContext!,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
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
                logInBox.put("userID", "");
                await chatRef.set("");
                await firebaseMessaging.unsubscribeFromTopic('user_all');
                await firebaseMessaging.unsubscribeFromTopic('scholars');
                await firebaseMessaging.unsubscribeFromTopic('scholars_faci');
                await firebaseMessaging
                    .unsubscribeFromTopic('scholars_non_faci');
                await createHistory(
                  desc: "User logged out due to its status being inactive",
                  timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
                  userType: "Scholar",
                  id: userID,
                );
                await firebaseAuth.signOut();
              },
            );
          });
        }
      });

      debugPrint("Alright imma listen to you manig.");

      scholarHasListened = true;
    } else {
      debugPrint("I've already listened to that shit.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // responsible for calling respective pages
      body: pages[pageIndex],
      backgroundColor: ColorPalette.accentWhite,
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: ColorPalette.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.pie_chart,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.pie_chart_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.timer_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            scholarType == "Faci"
                ? IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 4;
                      });
                    },
                    icon: pageIndex == 4
                        ? const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 35,
                          )
                        : const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                  )
                : IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 5;
                      });
                    },
                    icon: pageIndex == 5
                        ? const Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 35,
                          )
                        : const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 35,
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
