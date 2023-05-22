import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/pages/scholarPages/home.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class VerifyEmail extends StatefulWidget {
  final String headerText;
  final String email;
  final String password;
  final String userID;
  final String userType;
  const VerifyEmail(
      {super.key,
      required this.headerText,
      required this.email,
      required this.userID,
      required this.userType,
      required this.password});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> with WidgetsBindingObserver {
  DatabaseReference dbReference = FirebaseDatabase.instance.ref();
  final _myLoginBox = Hive.box('myLoginBox');
  bool loadFinish = false;
  User? user;
  late StreamSubscription<User?> authStateSubscription;

  @override
  void initState() {
    getCredentials().then((value) => listenToChanges());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.primary,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Email Verification",
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.headerText,
                      style: const TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: 'Click the link in order to ',
                        style: const TextStyle(
                          color: ColorPalette.accentWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'verify',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(
                            text: '. That will send to your email: ',
                          ),
                          TextSpan(
                            text: widget.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(height: 1, color: ColorPalette.secondary),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorPalette.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await user!.reload().then(
                          (value) async {
                            if (mounted) {
                              DialogLoading(subtext: "Checking...")
                                  .buildLoadingScreen(context);
                            }
                            if (user!.emailVerified && user != null) {
                              Navigator.of(context, rootNavigator: true).pop();
                            } else if (!user!.emailVerified) {
                              Navigator.of(context, rootNavigator: true).pop();
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                        );
                      },
                      child: const Text(
                        "CHECK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getCredentials() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      user = firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      DialogUnsuccessful(
        headertext: "Error",
        subtext: "${e.message.toString()}, Please try again later!",
        textButton: "Close",
        callback: () => Navigator.of(context, rootNavigator: true).pop(),
      ).buildUnsuccessfulScreen(context);
    }
  }

  Future listenToChanges() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    authStateSubscription = firebaseAuth.userChanges().listen(
      (user) async {
        if (user != null && user.emailVerified) {
          if (mounted) {
            await checkVerification();
          }
        } else if (user != null && !user.emailVerified) {
          if (mounted) {
            if (loadFinish) {
              DialogUnsuccessful(
                headertext: "Still not verified",
                subtext: "Resend another email verification link?",
                textButton: "Send",
                callback: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  DialogLoading(subtext: "Sending...")
                      .buildLoadingScreen(context);
                  try {
                    await user.sendEmailVerification().then(
                      (value) async {
                        Navigator.of(context, rootNavigator: true).pop();
                        DialogSuccess(
                          headertext: "Email Verification Sent!",
                          subtext:
                              "Check your inbox, if it's not there. Check your spam!",
                          textButton: "Close",
                          callback: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                        ).buildSuccessScreen(context);
                        await createHistory(
                          desc: "Requested for email verification link.",
                          timeStamp:
                              DateTime.now().microsecondsSinceEpoch.toString(),
                          userType: widget.userType,
                          id: widget.userID,
                        );
                      },
                    );
                  } on FirebaseAuthException catch (e) {
                    Navigator.of(context, rootNavigator: true).pop();
                    DialogUnsuccessful(
                      headertext: "Error",
                      subtext: "${e.message}, please try again later!",
                      textButton: "Close",
                      callback: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    ).buildUnsuccessfulScreen(context);
                  }
                },
              ).buildUnsuccessfulScreen(context);
            }
            loadFinish = true;
          }
        }
      },
    );
  }

  Future checkVerification() async {
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/${widget.userType}/${widget.userID}/isEmailVerified');
    DialogLoading(subtext: "Verified\nLogging you in...")
        .buildLoadingScreen(context);
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        if (widget.userType == "Scholars") {
          await dbReference.child('Users/Scholars/').get().then(
            (snapshot) {
              for (final test in snapshot.children) {
                if (test.key == widget.userID) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Map<String, dynamic> myObj =
                      jsonDecode(jsonEncode(test.value));

                  Scholar myScholarObj = Scholar.fromJson(myObj);
                  _myLoginBox.put("isLoggedIn", true);
                  _myLoginBox.put("hasTimedIn", false);
                  _myLoginBox.put("userType", "scholar");
                  _myLoginBox.put("userID", myScholarObj.studentNumber);
                  _myLoginBox.put("userName", myScholarObj.name);
                  _myLoginBox.put("getTimeInLS", "");
                  _myLoginBox.put("scholarType", myScholarObj.scholarType);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScholar()),
                      (Route<dynamic> route) => false);
                }
              }
            },
          );
          await createHistory(
            desc: "Verifies Email and logged in",
            timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
            userType: "Scholar",
            id: widget.userID,
          );
          await _userReference.set("true");
        } else if (widget.userType == "Professors") {
          await dbReference.child('Users/Professors/').get().then(
            (snapshot) {
              for (final test in snapshot.children) {
                if (test.key == widget.userID) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Map<String, dynamic> myObj =
                      jsonDecode(jsonEncode(test.value));

                  Professor myProfObj = Professor.fromJson(myObj);
                  _myLoginBox.put("isLoggedIn", true);
                  _myLoginBox.put("hasTimedIn", false);
                  _myLoginBox.put("userType", "professor");
                  _myLoginBox.put("userID", myProfObj.professorId);
                  _myLoginBox.put("userName", myProfObj.name);
                  _myLoginBox.put("getTimeInLS", "");

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeProfessor()),
                      (Route<dynamic> route) => false);
                }
              }
            },
          );
          await createHistory(
            desc: "Verifies Email and logged in",
            timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
            userType: "Professor",
            id: widget.userID,
          );
          await _userReference.set("true");
        } else if (widget.userType == "Head") {
          await dbReference.child('Users/Head/').get().then(
            (snapshot) {
              for (final test in snapshot.children) {
                if (test.key == widget.userID) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Map<String, dynamic> myObj =
                      jsonDecode(jsonEncode(test.value));

                  Head myHeadObj = Head.fromJson(myObj);
                  _myLoginBox.put("isLoggedIn", true);
                  _myLoginBox.put("hasTimedIn", false);
                  _myLoginBox.put("userType", "head");
                  _myLoginBox.put("userID", myHeadObj.userId);
                  _myLoginBox.put("userName", myHeadObj.name);
                  _myLoginBox.put("getTimeInLS", "");

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeAdmin()),
                      (Route<dynamic> route) => false);
                }
              }
            },
          );
          await createHistory(
            desc: "Verifies Email and logged in",
            timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
            userType: "Head",
            id: widget.userID,
          );
          await _userReference.set("true");
        }
      },
    );
  }

  @override
  void dispose() {
    authStateSubscription.cancel();
    super.dispose();
  }
}
