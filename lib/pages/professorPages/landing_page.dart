import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/pages/professorPages/info.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/professorWidgets/home/home_contents.dart';
import 'package:hksa/widgets/professorWidgets/home/home_header.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class ProfLandingPage extends StatefulWidget {
  const ProfLandingPage({super.key});

  @override
  State<ProfLandingPage> createState() => _ProfLandingPageState();
}

class _ProfLandingPageState extends State<ProfLandingPage> {
  @override
  void initState() {
    super.initState();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Professors/$userID');
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () async {
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
            await firebaseAuth.signOut();
            await firebaseMessaging.unsubscribeFromTopic('user_all');
            await firebaseMessaging.unsubscribeFromTopic('professors');
          });
        });
      }
    });
    userRef.child("status").get().then((user) {
      if (user.value.toString() == "inactive") {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () async {
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
            await firebaseAuth.signOut();
            await firebaseMessaging.unsubscribeFromTopic('user_all');
            await firebaseMessaging.unsubscribeFromTopic('professors');
            await createHistory(
              desc: "User logged out due to its status being inactive",
              timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
              userType: "professor",
              id: userID,
            );
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ProfessorHomeHeader(),
                const SizedBox(height: 20),
                const ProfessorHomeContent(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoProfessor()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.accentDarkWhite,
                  ),
                  child: const Text(
                    "About us",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
