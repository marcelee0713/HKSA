import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/pages/register_scholar.dart';
import 'package:hksa/pages/scholarPages/home.dart';
import 'package:hksa/pages/verificationPages/check_phone.dart';
import 'package:hksa/pages/verificationPages/forgot_password.dart';
import 'package:hksa/pages/verificationPages/verify_email.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import '/constant/colors.dart';
import 'package:hksa/constant/string.dart';

class LogInInputs extends StatefulWidget {
  const LogInInputs({super.key});

  @override
  State<LogInInputs> createState() => _LogInInputsState();
}

class _LogInInputsState extends State<LogInInputs> {
  // Firebase
  User? user;
  DatabaseReference dbReference = FirebaseDatabase.instance.ref();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _myLoginBox = Hive.box('myLoginBox');
  String realTimeValue = '0';
  String getOnceValue = '0';

  // For DropDown
  String? value = "Scholar";
  bool _passwordVisible = false;
  final _inputControllerUserID = TextEditingController();
  final _inputControllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Log in as:",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ColorPalette.accentWhite,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPalette.accentDarkWhite,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    iconSize: 32,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: ColorPalette.primary,
                    ),
                    value: value,
                    items: HKSAStrings.items.map(buildMenuItem).toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User ID:",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ColorPalette.accentWhite,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _inputControllerUserID,
                maxLength: 20,
                validator: (value) {
                  final bool studentIdValid =
                      RegExp(r"^[0-9-]+$").hasMatch(value!);
                  if (studentIdValid && value.length >= 10) {
                    return null;
                  } else if (value.length <= 9 && value.isNotEmpty) {
                    return "Input is too short.";
                  } else {
                    return "Enter your input.";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _inputControllerUserID.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  filled: true,
                  fillColor: ColorPalette.accentDarkWhite,
                ),
                style: const TextStyle(
                  color: ColorPalette.primary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Password:",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ColorPalette.accentWhite,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _inputControllerPassword,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "Enter your password.";
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  filled: true,
                  fillColor: ColorPalette.accentDarkWhite,
                ),
                style: const TextStyle(
                  color: ColorPalette.primary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 125,
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.accentDarkWhite),
                  ),
                  onPressed: (() {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const RegisterScholarPage()),
                        ),
                      );
                    });
                  }),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Frank Ruhl Libre',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 125,
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorPalette.accentDarkWhite),
                  ),
                  onPressed: (() async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    DialogLoading(subtext: "Logging in...")
                        .buildLoadingScreen(context);
                    // This is where it finds the user in the firebase database
                    // And if it did find it will log in depends on the user type
                    // if not. It will pop up a modal that it will show
                    // NO USER FOUND
                    await firebaseAuth.signOut();
                    String userType = value!.toLowerCase();
                    String userID = _inputControllerUserID.text.trim();
                    String userPassword = _inputControllerPassword.text;
                    bool userDoesNotExist = true;
                    bool haveToVerify = false;

                    if (userType == "scholar") {
                      await dbReference.child('Users/Scholars/').get().then(
                        (snapshot) async {
                          for (final test in snapshot.children) {
                            if (test.key == userID) {
                              userDoesNotExist = false;
                              Map<String, dynamic> myObj =
                                  jsonDecode(jsonEncode(test.value));

                              Scholar myScholarObj = Scholar.fromJson(myObj);

                              String email = myScholarObj.email;
                              String password =
                                  _inputControllerPassword.text.trim();

                              if (myScholarObj.status == "inactive") {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Your Status is Inactive! ",
                                  subtext:
                                      "Please proceed to CSDL for this concern",
                                  textButton: "Close",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ).buildUnsuccessfulScreen(context);
                                return;
                              }

                              await signIn(email: email, password: password)
                                  .then((value) async {
                                if (user?.phoneNumber == null && user != null) {
                                  haveToVerify = true;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckPhoneNumber(
                                        email: email,
                                        userID: userID,
                                        userType: "Scholars",
                                        password: password,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (!user!.emailVerified && user != null) {
                                  haveToVerify = true;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmail(
                                        email: email,
                                        userID: userID,
                                        userType: "Scholars",
                                        password: password,
                                        headerText:
                                            "We also need to verify your email check your inbox right now!",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Put it in our LocalStorage
                                // Para ma save yung login state niya.
                                // And also some other stuff that need
                                // to be stored.
                                _myLoginBox.put("isLoggedIn", true);
                                _myLoginBox.put("hasTimedIn", false);
                                _myLoginBox.put("userType", "scholar");
                                _myLoginBox.put("userID", userID);
                                _myLoginBox.put("userName", myScholarObj.name);
                                _myLoginBox.put("getTimeInLS", "");
                                _myLoginBox.put(
                                    "scholarType", myScholarObj.scholarType);

                                // Will now go to the ScholarPage
                                // And literally replace any pages.
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScholar()),
                                    (Route<dynamic> route) => false);

                                await createHistory(
                                  desc: "User logged in",
                                  timeStamp: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  userType: userType,
                                  id: userID,
                                );
                              }).catchError(
                                (err) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogUnsuccessful(
                                    headertext: "Error!",
                                    subtext: err,
                                    textButton: "Close",
                                    callback: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ).buildUnsuccessfulScreen(context);
                                },
                              );
                            }
                          }
                        },
                      ).whenComplete(() {
                        if (!haveToVerify) {
                          if (userDoesNotExist) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogUnsuccessful(
                              headertext: "Account doesn't exists!",
                              subtext:
                                  "If you think this is wrong please proceed to the CSDL Department!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ).buildUnsuccessfulScreen(context);
                            return;
                          }
                        }
                      });
                    }
                    if (userType == "professor") {
                      await dbReference.child('Users/Professors/').get().then(
                        (snapshot) async {
                          for (final test in snapshot.children) {
                            if (test.key == userID) {
                              userDoesNotExist = false;
                              Map<String, dynamic> myObj =
                                  jsonDecode(jsonEncode(test.value));

                              Professor myProfObj = Professor.fromJson(myObj);

                              String email = myProfObj.email;
                              String password =
                                  _inputControllerPassword.text.trim();

                              if (myProfObj.status == "inactive") {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Your Status is Inactive! ",
                                  subtext:
                                      "Please proceed to CSDL for this concern",
                                  textButton: "Close",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ).buildUnsuccessfulScreen(context);
                                return;
                              }

                              await signIn(email: email, password: password)
                                  .then((value) async {
                                if (user?.phoneNumber == null) {
                                  haveToVerify = true;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckPhoneNumber(
                                        email: email,
                                        userID: userID,
                                        userType: "Professors",
                                        password: password,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (!user!.emailVerified) {
                                  haveToVerify = true;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmail(
                                        email: email,
                                        userID: userID,
                                        userType: "Professors",
                                        password: password,
                                        headerText:
                                            "We also have to verify your email so you can log in.",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                // Put it in our LocalStorage
                                // Para ma save yung login state niya.
                                // And also some other stuff that need
                                // to be stored.
                                _myLoginBox.put("isLoggedIn", true);
                                _myLoginBox.put("hasTimedIn", false);
                                _myLoginBox.put("userType", "professor");
                                _myLoginBox.put("userID", userID);
                                _myLoginBox.put("userName", myProfObj.name);
                                _myLoginBox.put("getTimeInLS", "");

                                // Will now go to the ProfPage
                                // And literally replace any pages.
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeProfessor()),
                                    (Route<dynamic> route) => false);
                                await createHistory(
                                  desc: "User logged in",
                                  timeStamp: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  userType: "Professor",
                                  id: userID,
                                );
                              }).catchError((err) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Error!",
                                  subtext: err,
                                  textButton: "Close",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ).buildUnsuccessfulScreen(context);
                              });
                            }
                          }
                        },
                      ).whenComplete(() {
                        if (!haveToVerify) {
                          if (userDoesNotExist) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogUnsuccessful(
                              headertext: "Account doesn't exists!",
                              subtext:
                                  "If you think this is wrong please proceed to the CSDL Department!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ).buildUnsuccessfulScreen(context);
                            return;
                          }
                        }
                      });
                    }
                    if (userType == "head") {
                      await dbReference.child('Users/Head/').get().then(
                        (snapshot) async {
                          for (final test in snapshot.children) {
                            if (test.key == userID) {
                              userDoesNotExist = false;
                              Map<String, dynamic> myObj =
                                  jsonDecode(jsonEncode(test.value));

                              Head myHeadObj = Head.fromJson(myObj);

                              String email = myHeadObj.email;

                              if (myHeadObj.status == "inactive") {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Your Status is Inactive! ",
                                  subtext:
                                      "Please proceed to CSDL for this concern",
                                  textButton: "Close",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ).buildUnsuccessfulScreen(context);
                                return;
                              }

                              await signIn(email: email, password: userPassword)
                                  .then((value) {
                                if (user?.phoneNumber == null) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckPhoneNumber(
                                        email: email,
                                        userID: userID,
                                        userType: "Head",
                                        password: userPassword,
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                if (!user!.emailVerified) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmail(
                                        email: email,
                                        userID: userID,
                                        userType: "Head",
                                        password: userPassword,
                                        headerText:
                                            "We also have to verify your email so you can log in.",
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                // Put it in our LocalStorage
                                // Para ma save yung login state niya.
                                // And also some other stuff that need
                                // to be stored.
                                _myLoginBox.put("isLoggedIn", true);
                                _myLoginBox.put("hasTimedIn", false);
                                _myLoginBox.put("userType", "head");
                                _myLoginBox.put("userID", userID);
                                _myLoginBox.put("userName", myHeadObj.name);
                                _myLoginBox.put("getTimeInLS", "");

                                // Will now go to the Admin page
                                // And literally replace any pages.
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeAdmin()),
                                    (Route<dynamic> route) => false);
                                Future.delayed(const Duration(), () async {
                                  await createHistory(
                                    desc: "User logged in",
                                    timeStamp: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    userType: "Head",
                                    id: userID,
                                  );
                                });
                              }).catchError(
                                (err) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogUnsuccessful(
                                    headertext: "Error!",
                                    subtext: err,
                                    textButton: "Close",
                                    callback: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ).buildUnsuccessfulScreen(context);
                                },
                              );
                            }
                          }
                        },
                      ).whenComplete(() {
                        if (!haveToVerify) {
                          if (userDoesNotExist) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogUnsuccessful(
                              headertext: "Account doesn't exists!",
                              subtext:
                                  "If you think this is wrong please proceed to the CSDL Department!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ).buildUnsuccessfulScreen(context);
                            return;
                          }
                        }
                      });
                    }
                  }),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: ColorPalette.accentBlack,
                      fontFamily: 'Frank Ruhl Libre',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: ColorPalette.accentWhite,
                decoration: TextDecoration.underline,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future signIn({required String email, required String password}) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        user = firebaseAuth.currentUser;
      });
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future signOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
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

  @override
  void dispose() {
    _inputControllerPassword.dispose();
    _inputControllerUserID.dispose();
    super.dispose();
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: ColorPalette.primary,
          ),
        ),
      );
}
