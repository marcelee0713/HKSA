import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/main.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/pages/professorPages/landing_page.dart';
import 'package:hksa/pages/professorPages/message.dart';
import 'package:hksa/pages/professorPages/profile.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class HomeProfessor extends StatefulWidget {
  const HomeProfessor({super.key});

  @override
  State<HomeProfessor> createState() => _HomeProfessorState();
}

bool professorHasListened = false;
StreamSubscription<DatabaseEvent>? professorSubscription;

class _HomeProfessorState extends State<HomeProfessor> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  int pageIndexProf = 1;
  final pages = const [
    Messages(),
    ProfLandingPage(),
    ProfProfile(),
  ];
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    firebaseMessaging.subscribeToTopic('user_all');
    firebaseMessaging.subscribeToTopic('professors');

    if (!professorHasListened) {
      DatabaseReference listenRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Professors/$userID/status");
      DatabaseReference chatRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Professors/$userID/listeningTo");
      professorSubscription = listenRef.onValue.listen((event) {
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
                professorSubscription!.cancel();
                professorHasListened = false;
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
                await firebaseAuth.signOut();
                await chatRef.set("");
                await firebaseMessaging.unsubscribeFromTopic('user_all');
                await firebaseMessaging.unsubscribeFromTopic('professors');
                await createHistory(
                  desc: "User logged out due to its status being inactive",
                  timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
                  userType: "Scholar",
                  id: userID,
                );
              },
            );
          });
        }
      });

      debugPrint("Alright imma listen to you manig.");

      professorHasListened = true;
    } else {
      debugPrint("I've already listened to that shit.");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: pages[pageIndexProf],
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
                  pageIndexProf = 0;
                });
              },
              icon: pageIndexProf == 0
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
                  pageIndexProf = 1;
                });
              },
              icon: pageIndexProf == 1
                  ? const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndexProf = 2;
                });
              },
              icon: pageIndexProf == 2
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
          ],
        ),
      ),
    );
  }
}
