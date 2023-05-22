import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:hksa/constant/string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class DialogSign extends StatefulWidget {
  final String timeIn;
  final String timeOut;

  const DialogSign({super.key, required this.timeIn, required this.timeOut});

  @override
  State<DialogSign> createState() => _DialogSignState();
}

class _DialogSignState extends State<DialogSign> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");

  final _inputControllerSignature = TextEditingController();
  String? multiplierValue;
  bool _signatureVisible = false;
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
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () async {
            _firebaseMessaging.unsubscribeFromTopic('user_all');
            _firebaseMessaging.unsubscribeFromTopic('scholars');
            _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
            _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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
            await _firebaseMessaging.unsubscribeFromTopic('user_all');
            await _firebaseMessaging.unsubscribeFromTopic('scholars');
            await _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
            await _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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
            () async {
              logInBox.put("isLoggedIn", false);
              logInBox.put("hasTimedIn", false);
              logInBox.put("userType", "");
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
              logInBox.put("userID", "");
              await createHistory(
                desc: "User logged out due to its status being inactive",
                timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
                userType: "scholar",
                id: userID,
              );
              await firebaseAuth.signOut();
              await _firebaseMessaging.unsubscribeFromTopic('user_all');
              await _firebaseMessaging.unsubscribeFromTopic('scholars');
              await _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
              await _firebaseMessaging
                  .unsubscribeFromTopic('scholars_non_faci');
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String result = "";
    DatabaseReference _testReference =
        FirebaseDatabase.instance.ref().child("Users/Professors/");
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: ColorPalette.primary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Authorize the scholar to time out?",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    "Professors should only be in this page, because this is where the scholar can time out.",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _inputControllerSignature,
                          obscureText: !_signatureVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: 0),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: ColorPalette.errorColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: ColorPalette.errorColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            filled: true,
                            fillColor: ColorPalette.accentDarkWhite,
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _signatureVisible = !_signatureVisible;
                                });
                              },
                              icon: Icon(
                                _signatureVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "Signature",
                          ),
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorPalette.accentDarkWhite,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text(
                                "*",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              value: multiplierValue,
                              isExpanded: true,
                              iconSize: 16,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorPalette.primary,
                              ),
                              items: HKSAStrings.multipliers
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: ((multiplierValue) => setState(() {
                                    this.multiplierValue =
                                        multiplierValue ?? "";
                                  })),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "CHECK BEFORE PRESSING CONFIRM",
                    style: TextStyle(
                      color: ColorPalette.secondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        "User Timed in: ",
                        style: TextStyle(
                          color: ColorPalette.secondary,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.timeIn,
                          style: const TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        "Timing out in: ",
                        style: TextStyle(
                          color: ColorPalette.secondary,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.timeOut,
                          style: const TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        "Hours will be: ",
                        style: TextStyle(
                          color: ColorPalette.secondary,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          totalHoursThisDay(
                            widget.timeIn,
                            widget.timeOut,
                            int.parse(multiplierValue == null
                                ? "1"
                                : multiplierValue!),
                          ).substring(0, 8).replaceAll('.', ''),
                          style: const TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (() => setState(
                          () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (multiplierValue == null) {
                              Flushbar(
                                backgroundColor: ColorPalette.secondary,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                messageText: const Text(
                                  "Enter a multiplier please.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: ColorPalette.primary,
                                  ),
                                ),
                                duration: const Duration(seconds: 3),
                              ).show(context);
                              return;
                            }

                            String signatureInput =
                                _inputControllerSignature.text.trim();
                            bool userExist = false;
                            bool doneCheckingUsers = false;

                            String professorID = "";
                            String professorName = "";

                            DialogLoading(subtext: "Checking...")
                                .buildLoadingScreen(context);

                            Future.delayed(const Duration(seconds: 2),
                                () async {
                              await _testReference.get().then((snapshot) {
                                for (final test in snapshot.children) {
                                  Map<String, dynamic> myObj =
                                      jsonDecode(jsonEncode(test.value));

                                  Professor myProfessorObj =
                                      Professor.fromJson(myObj);

                                  if (myProfessorObj.signaturecode ==
                                      signatureInput) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    userExist = true;
                                    doneCheckingUsers = false;
                                    result =
                                        multiplierValue! + myProfessorObj.name;
                                    professorID = myProfessorObj.professorId;
                                    professorName = myProfessorObj.name;
                                    Navigator.pop(context, result);
                                    break;
                                  } else {
                                    userExist = false;
                                    continue;
                                  }
                                }
                                doneCheckingUsers = true;
                              });
                            }).whenComplete(() => {
                                  Future.delayed(
                                      const Duration(milliseconds: 2500),
                                      () async {
                                    if (!userExist && doneCheckingUsers) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      DialogUnsuccessful(
                                          headertext: "Unavailable Signature",
                                          subtext:
                                              "We currently don't have the signature you input",
                                          textButton: "Close",
                                          callback: () => {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop()
                                              }).buildUnsuccessfulScreen(
                                        context,
                                      );
                                    } else {
                                      await createHistory(
                                        desc:
                                            "Timed out by $professorName and the ID is $professorID.",
                                        timeStamp: DateTime.now()
                                            .microsecondsSinceEpoch
                                            .toString(),
                                        userType: "scholar",
                                        id: userID,
                                      );
                                    }
                                  }),
                                  _inputControllerSignature.text = "",
                                });
                          },
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      disabledBackgroundColor:
                          const Color.fromARGB(137, 114, 177, 139),
                    ),
                    child: const Text(
                      "CONFIRM",
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      HKSAStrings.signatureInfo,
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  @override
  void dispose() {
    _inputControllerSignature.dispose();
    super.dispose();
  }

  Future createHistory(
      {required String desc,
      required String timeStamp,
      required String userType,
      required String id}) async {
    try {
      DatabaseReference dbReference =
          FirebaseDatabase.instance.ref().child('historylogs/$id');
      String? key = dbReference.push().key;

      final json = {
        'desc': desc,
        'timeStamp': timeStamp,
        'userType': userType,
        'id': id,
      };

      await dbReference.child(key!).set(json);
    } catch (error) {
      rethrow;
    }
  }

  String totalHoursThisDay(timeIn, timeOut, multiplier) {
    multiplier ??= 1;
    DateTime parsedDateIn =
        DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").parse(timeIn);
    DateTime parsedDateOut =
        DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").parse(timeOut);

    Duration workingHours = parsedDateOut.difference(parsedDateIn);

    return (workingHours * multiplier).toString();
  }
}
