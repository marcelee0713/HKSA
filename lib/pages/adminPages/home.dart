import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/main.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/adminWidgets/home/home_content.dart';
import 'package:hksa/widgets/adminWidgets/home/home_header.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

bool headHasListened = false;
bool isSuperAdmin = false;
bool sawItAlready = true;
StreamSubscription<DatabaseEvent>? headSubscription;
StreamSubscription<DatabaseEvent>? isSuperAdminSubscription;

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final logInBox = Hive.box("myLoginBox");
  late var userName = logInBox.get("userName");
  late var userID = logInBox.get("userID");

  @override
  void initState() {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (!headHasListened) {
      DatabaseReference listenRef =
          FirebaseDatabase.instance.ref().child("Users/Head/$userID/status");
      DatabaseReference superAdminRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Head/$userID/isSuperAdmin");
      DatabaseReference chatRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Head/$userID/listeningTo");
      headSubscription = listenRef.onValue.listen((event) {
        String status = event.snapshot.value.toString();

        if (status == "inactive") {
          Future.delayed(const Duration(), (() {
            DialogLoading(subtext: "Logging out...")
                .buildLoadingScreen(navigatorKey.currentContext!);
          })).whenComplete(() {
            Future.delayed(
              const Duration(seconds: 3),
              () async {
                headSubscription!.cancel();
                isSuperAdminSubscription!.cancel();
                headHasListened = false;
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
                await firebaseMessaging.unsubscribeFromTopic('admin');
                await createHistory(
                  desc: "User logged out due to its status being inactive",
                  timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
                  userType: "Head",
                  id: userID,
                );
              },
            );
          });
        }
      });
      isSuperAdminSubscription = superAdminRef.onValue.listen((event) {
        String isStrSuperAdmin = event.snapshot.value.toString();
        if (isStrSuperAdmin == "true") {
          navigatorKey.currentState?.setState(() {
            isSuperAdmin = true;
            selectedIndex = 0;
          });

          if (!sawItAlready) {
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: true,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async {
                    navigatorKey.currentState!.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeAdmin()));
                    return true;
                  },
                  child: AlertDialog(
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
                                "Role Changed!",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "You are now a super admin. You have now full control of everybody, this also include the admins.",
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
                                  navigatorKey.currentState!.pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeAdmin()));
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
                  ),
                );
              },
            );
          }
          sawItAlready = false;
        } else {
          navigatorKey.currentState?.setState(() {
            isSuperAdmin = false;
            selectedIndex = 0;
          });

          if (!sawItAlready) {
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: true,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async {
                    navigatorKey.currentState!.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeAdmin()));
                    return true;
                  },
                  child: AlertDialog(
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
                                "Role Changed!",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "You are now an admin.",
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
                                  navigatorKey.currentState!.pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeAdmin()));
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
                  ),
                );
              },
            );
          }
          sawItAlready = false;
        }
      });
      headHasListened = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      drawer: const NavDraw(),
      body: Stack(
        children: [
          Builder(builder: (context) {
            return SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 40,
                    color: ColorPalette.primary,
                  ),
                ),
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                AdminHomeHeader(),
                SizedBox(height: 20),
                AdminHomeContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
