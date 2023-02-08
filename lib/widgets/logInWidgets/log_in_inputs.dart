import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/pages/register_scholar.dart';
import 'package:hksa/pages/scholarPages/home.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import '/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:firebase_core/firebase_core.dart';

class LogInInputs extends StatefulWidget {
  const LogInInputs({super.key});

  @override
  State<LogInInputs> createState() => _LogInInputsState();
}

class _LogInInputsState extends State<LogInInputs> {
  // Firebase
  DatabaseReference dbReference = FirebaseDatabase.instance.ref();
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(ColorPalette.primary),
                  ),
                  onPressed: (() async {
                    setState(() {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      DialogLoading(subtext: "Logging in...")
                          .buildLoadingScreen(context);
                      // This is where it finds the user in the firebase database
                      // And if it did find it will log in depends on the user type
                      // if not. It will pop up a modal that it will show
                      // NO USER FOUND
                      String userType = value!.toLowerCase();
                      String userID = _inputControllerUserID.text.trim();
                      String userPassword = _inputControllerPassword.text;
                      bool userExist = false;
                      bool doneCheckingUsers = false;
                      bool userActive = true;

                      Future.delayed(
                        const Duration(seconds: 2),
                        (() => {
                              if (userType == "scholar")
                                {
                                  dbReference
                                      .child('Users/Scholars/')
                                      .get()
                                      .then((snapshot) {
                                    for (final test in snapshot.children) {
                                      if (test.key == userID) {
                                        Map<String, dynamic> myObj =
                                            jsonDecode(jsonEncode(test.value));

                                        Scholar myScholarObj =
                                            Scholar.fromJson(myObj);

                                        if (myScholarObj.status == "inactive") {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          userActive = false;
                                          DialogUnsuccessful(
                                            headertext:
                                                "Your Status is Inactive! ",
                                            subtext:
                                                "Please proceed to CSDL for this concern",
                                            textButton: "Close",
                                            callback: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ).buildUnsuccessfulScreen(context);
                                          userExist = false;
                                          break;
                                        }
                                        // Dito ka gumawa Monce

                                        if (myScholarObj.password ==
                                            userPassword) {
                                          debugPrint("IT MATCHES");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();

                                          // Put it in our LocalStorage
                                          // Para ma save yung login state niya.
                                          // And also some other stuff that need
                                          // to be stored.
                                          _myLoginBox.put("isLoggedIn", true);
                                          _myLoginBox.put("hasTimedIn", false);
                                          _myLoginBox.put(
                                              "userType", "scholar");
                                          _myLoginBox.put("userID", userID);
                                          _myLoginBox.put(
                                              "userName", myScholarObj.name);
                                          _myLoginBox.put("getTimeInLS", "");

                                          // Will now go to the ScholarPage
                                          // And literally replace any pages.
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScholar()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                          userExist = true;
                                          doneCheckingUsers = false;
                                          break;
                                        } else {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogUnsuccessful(
                                            headertext: "Wrong Password.",
                                            subtext:
                                                "Seems like you entered the wrong password.",
                                            textButton: "Close",
                                            callback: (() => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop()),
                                          ).buildUnsuccessfulScreen(context);
                                          userExist = true;
                                          break;
                                        }
                                      }
                                    }
                                  })
                                },
                              if (userType == "professor")
                                {
                                  dbReference
                                      .child('Users/Professors/')
                                      .get()
                                      .then((snapshot) {
                                    for (final test in snapshot.children) {
                                      if (test.key == userID) {
                                        Map<String, dynamic> myObj =
                                            jsonDecode(jsonEncode(test.value));

                                        Professor myProfObj =
                                            Professor.fromJson(myObj);
                                        // Dito ka gumawa Monce

                                        if (myProfObj.password ==
                                            userPassword) {
                                          debugPrint("IT MATCHES");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();

                                          // Put it in our LocalStorage
                                          // Para ma save yung login state niya.
                                          // And also some other stuff that need
                                          // to be stored.
                                          _myLoginBox.put("isLoggedIn", true);
                                          _myLoginBox.put("hasTimedIn", false);
                                          _myLoginBox.put(
                                              "userType", "professor");
                                          _myLoginBox.put("userID", userID);
                                          _myLoginBox.put(
                                              "userName", myProfObj.name);
                                          _myLoginBox.put("getTimeInLS", "");

                                          // Will now go to the ProfPage
                                          // And literally replace any pages.
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeProfessor()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                          userExist = true;
                                          doneCheckingUsers = false;
                                          break;
                                        } else {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogUnsuccessful(
                                            headertext: "Wrong Password.",
                                            subtext:
                                                "Seems like you entered the wrong password.",
                                            textButton: "Close",
                                            callback: (() => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop()),
                                          ).buildUnsuccessfulScreen(context);
                                          userExist = true;
                                          break;
                                        }
                                      }
                                    }
                                    doneCheckingUsers = true;
                                  })
                                },
                              if (userType == "head")
                                {
                                  dbReference
                                      .child('Users/Head/')
                                      .get()
                                      .then((snapshot) {
                                    for (final test in snapshot.children) {
                                      if (test.key == userID) {
                                        Map<String, dynamic> myObj =
                                            jsonDecode(jsonEncode(test.value));

                                        Head myHeadObj = Head.fromJson(myObj);
                                        // Dito ka gumawa Monce

                                        if (myHeadObj.password ==
                                            userPassword) {
                                          debugPrint("IT MATCHES");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();

                                          // Put it in our LocalStorage
                                          // Para ma save yung login state niya.
                                          // And also some other stuff that need
                                          // to be stored.
                                          _myLoginBox.put("isLoggedIn", true);
                                          _myLoginBox.put("hasTimedIn", false);
                                          _myLoginBox.put("userType", "head");
                                          _myLoginBox.put("userID", userID);
                                          _myLoginBox.put(
                                              "userName", myHeadObj.name);
                                          _myLoginBox.put("getTimeInLS", "");

                                          // Will now go to the Admin page
                                          // And literally replace any pages.
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeAdmin()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                          userExist = true;
                                          doneCheckingUsers = false;
                                          break;
                                        } else {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogUnsuccessful(
                                            headertext: "Wrong Password.",
                                            subtext:
                                                "Seems like you entered the wrong password.",
                                            textButton: "Close",
                                            callback: (() => Navigator.of(
                                                    context,
                                                    rootNavigator: true)
                                                .pop()),
                                          ).buildUnsuccessfulScreen(context);
                                          userExist = true;
                                          break;
                                        }
                                      }
                                    }
                                    doneCheckingUsers = true;
                                  })
                                }
                            }),
                      ).whenComplete(() => {
                            doneCheckingUsers = true,
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
                              if (userType == "scholar") {
                                if (!userExist &&
                                    doneCheckingUsers &&
                                    userActive) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogUnsuccessful(
                                    headertext: "USER NOT FOUND",
                                    subtext:
                                        "Sorry, we can't find that user in our database or maybe you're not connected to the internet.",
                                    textButton: "Close",
                                    callback: (() => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop()),
                                  ).buildUnsuccessfulScreen(context);
                                }
                              } else if (userType == "professor" ||
                                  userType == "head") {
                                if (!userExist && doneCheckingUsers) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogUnsuccessful(
                                    headertext: "USER NOT FOUND",
                                    subtext:
                                        "Sorry, we can't find that user in our database or maybe you're not connected to the internet.",
                                    textButton: "Close",
                                    callback: (() => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop()),
                                  ).buildUnsuccessfulScreen(context);
                                }
                              }
                            })
                          });
                    });
                  }),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Frank Ruhl Libre',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
