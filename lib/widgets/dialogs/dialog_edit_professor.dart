import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm_edit.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_show_conflict.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class EditProfessor extends StatefulWidget {
  final String userID;
  final String currentRoom;
  final String currentSection;
  final String currentSubject;
  const EditProfessor(
      {super.key,
      required this.userID,
      required this.currentRoom,
      required this.currentSection,
      required this.currentSubject});

  @override
  State<EditProfessor> createState() => _EditProfessorState();
}

class _EditProfessorState extends State<EditProfessor> {
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
  final DatabaseReference choicesReference =
      FirebaseDatabase.instance.ref().child("scheduleChoices/");
  final _inputControllerProfessorID = TextEditingController();
  final _inputControllerName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();
  final _inputControllerSignatureCode = TextEditingController();
  final _inputControllerSubject = TextEditingController();
  final _inputControllerSection = TextEditingController();
  final _inputControllerRoom = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _dbReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");

  String? departmentValue;
  String? dayValue;
  String? timeValue;
  String? roomValue;
  String? sectionValue;
  String? subjectValue;

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;
  bool _signatureCodeVisible = false;
  bool gotValue = false;
  bool gotValueSubject = false;

  @override
  void initState() {
    checkSchedules();
    super.initState();
  }

  Future<void> checkSchedules() async {
    List<String> conflicts = [];
    await choicesReference.child("room").get().then((snapshot) {
      bool doesNotExist = true;
      for (final data in snapshot.children) {
        if (widget.currentRoom == data.value) {
          roomValue = data.value.toString();
          doesNotExist = false;
        }
      }

      if (doesNotExist) {
        conflicts.add("Room doesn't exist!");
        roomValue = null;
      }
    });

    await choicesReference.child("section").get().then((snapshot) {
      bool doesNotExist = true;
      for (final data in snapshot.children) {
        if (widget.currentSection == data.value) {
          sectionValue = data.value.toString();
          doesNotExist = false;
        }
      }

      if (doesNotExist) {
        conflicts.add("Section doesn't exist!");
        sectionValue = null;
      }
    });

    await choicesReference.child("subjectCode").get().then((snapshot) {
      bool doesNotExist = true;
      for (final data in snapshot.children) {
        if (widget.currentSubject == data.value) {
          subjectValue = data.value.toString();
          doesNotExist = false;
        }
      }

      if (doesNotExist) {
        conflicts.add("Subject code doesn't exist!");
        subjectValue = null;
      }
    }).whenComplete(() {
      if (conflicts.isNotEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          DialogConflict(
            "Found Conflicts on this Professor!",
            "Resolve it now because this will create issues to the professor and scholars!",
            "Close",
            () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            conflicts: conflicts,
          ).build(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: ColorPalette.accentWhite,
              child: FutureBuilder(
                future: getProfessor(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SpinKitCircle(
                            color: ColorPalette.secondary,
                            size: 100,
                          ),
                          SizedBox(height: 20),
                          Text("Loading..."),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.warning_rounded,
                            size: 200,
                            color: ColorPalette.errorColor,
                          ),
                          Text(
                            'Something went wrong!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: ColorPalette.accentBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Please try again later.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: ColorPalette.accentBlack,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "You are currently editing:",
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.name,
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.professorId,
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: ColorPalette.primary),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Basic Information:",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              enabled: false,
                              controller: _inputControllerProfessorID,
                              maxLength: 20,
                              validator: (value) {
                                final bool profIdValid =
                                    RegExp(r"^[0-9-]+$").hasMatch(value!);
                                if (profIdValid && value.length >= 10) {
                                  return null;
                                } else if (value.length <= 9 &&
                                    value.isNotEmpty) {
                                  return "Input is too short.";
                                } else if (value.isEmpty) {
                                  return "Enter Input.";
                                } else {
                                  return "Enter valid school ID.";
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: "",
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: ColorPalette.accentDarkWhite,
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                hintText: "Professor Number (XX-XNXX-XXXXX)",
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _inputControllerName,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Enter your name.";
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _inputControllerName.text =
                                                snapshot.data!.first.name;
                                          });
                                        },
                                        icon: const Icon(Icons.paste_rounded),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: ColorPalette.accentDarkWhite,
                                      hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      hintText: "Name"),
                                  style: const TextStyle(
                                    color: ColorPalette.primary,
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                SelectableText(
                                  "Name was ${snapshot.data!.first.name}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorPalette.accentDarkWhite,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text(
                                        "Enter Department",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: departmentValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.departments
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: ((departmentValue) =>
                                          setState(() {
                                            this.departmentValue =
                                                departmentValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Department was ${snapshot.data!.first.department}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _inputControllerEmail,
                                  validator: (value) {
                                    // Email RegEx Validation
                                    final bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!);
                                    if (value.isNotEmpty && emailValid) {
                                      return null;
                                    } else {
                                      return "Invalid input.";
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _inputControllerEmail.text =
                                              snapshot.data!.first.email;
                                        });
                                      },
                                      icon: const Icon(Icons.paste_rounded),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: ColorPalette.accentDarkWhite,
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintText: "Email",
                                  ),
                                  style: const TextStyle(
                                    color: ColorPalette.primary,
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                SelectableText(
                                  "Email was ${snapshot.data!.first.email}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _inputControllerPhoneNumber,
                                  maxLength: 11,
                                  validator: (value) {
                                    final bool phoneValid =
                                        RegExp(r"^(09|\+639)\d{9}$")
                                            .hasMatch(value!);
                                    if (phoneValid) {
                                      return null;
                                    } else if (value.length <= 11 &&
                                        !phoneValid) {
                                      return "Invalid input.";
                                    } else if (value.length <= 10 &&
                                        value.isNotEmpty) {
                                      return "Input is too short.";
                                    } else {
                                      return "Enter an input.";
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _inputControllerPhoneNumber.text =
                                              snapshot.data!.first.phonenumber;
                                        });
                                      },
                                      icon: const Icon(Icons.paste_rounded),
                                    ),
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: ColorPalette.accentDarkWhite,
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintText: "Phone Number",
                                  ),
                                  style: const TextStyle(
                                    color: ColorPalette.primary,
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                SelectableText(
                                  "Phone Number was ${snapshot.data!.first.phonenumber}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _inputControllerPassword,
                              obscureText: !_passwordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                final bool passwordValid = RegExp(
                                        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-.+=_]).{8,}$")
                                    .hasMatch(value!);
                                if (passwordValid) {
                                  return null;
                                } else {
                                  return "Invalid Input.";
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
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
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                hintText: "Password",
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Note: Password must be at least 8 characters, at least one uppercase, number, and special characters.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _inputControllerCfrmPassword,
                              obscureText: !_cfrmPasswordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                final bool cfrmPasswordValid =
                                    _inputControllerPassword.text ==
                                        _inputControllerCfrmPassword.text;
                                if (cfrmPasswordValid) {
                                  return null;
                                } else if (value!.isEmpty) {
                                  return 'Enter input.';
                                } else {
                                  return "Password not match";
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
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
                                      _cfrmPasswordVisible =
                                          !_cfrmPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _cfrmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                hintText: "Confirm Password",
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(height: 1, color: ColorPalette.primary),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Signature Code:",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "This is the key to time out the assigned Faci to you. Do not let anyone know about the Professor's Signature Code",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _inputControllerSignatureCode,
                              maxLength: 20,
                              obscureText: !_signatureCodeVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Enter an input.";
                                }
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _signatureCodeVisible =
                                          !_signatureCodeVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _signatureCodeVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: ColorPalette.accentDarkWhite,
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                hintText: "Signature Code",
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(height: 1, color: ColorPalette.primary),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Schedule Information:",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "This is where if the Faci and Professor's day and time matches and allowed to be assigned. ",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Important note:",
                                style: TextStyle(
                                  color: ColorPalette.errorColor,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Please be careful modifying ',
                                  style: TextStyle(
                                    color: ColorPalette.errorColor,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'DAY and TIME. ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'This can create conflicts to one or more scholars if this professor is assigned to somebody else.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorPalette.accentDarkWhite,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text(
                                        "Enter Day",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: dayValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.vacantday
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: ((dayValue) => setState(() {
                                            this.dayValue = dayValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Day was ${snapshot.data!.first.day}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorPalette.accentDarkWhite,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text(
                                        "Enter Time",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: timeValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.vacanttime
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: ((timeValue) => setState(() {
                                            this.timeValue = timeValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Vacant Time was ${snapshot.data!.first.time}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                    future: getSubjectCodes(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Fetching subject codes...',
                                              style: TextStyle(
                                                color: ColorPalette.primary,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SpinKitThreeBounce(
                                              color: ColorPalette.secondary,
                                              size: 15,
                                            ),
                                          ],
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.warning_rounded,
                                              color: ColorPalette.errorColor,
                                              size: 15,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              'Error fetching subject codes.',
                                              style: TextStyle(
                                                color: ColorPalette.errorColor,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: const BoxDecoration(
                                          color: ColorPalette.accentDarkWhite,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            hint: Text(
                                              snapshot.data!.isNotEmpty
                                                  ? "Enter Subject codes"
                                                  : "No Subject codes Currently",
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            isExpanded: true,
                                            iconSize: 32,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: ColorPalette.primary,
                                            ),
                                            value: subjectValue,
                                            items: snapshot.data!
                                                .map(buildMenuItem)
                                                .toList(),
                                            onChanged: ((subjectValue) =>
                                                setState(() {
                                                  this.subjectValue =
                                                      subjectValue ?? "";
                                                })),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 2),
                                Text(
                                  "Subject was ${snapshot.data!.first.subject}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                    future: getSections(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Fetching sections...',
                                              style: TextStyle(
                                                color: ColorPalette.primary,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SpinKitThreeBounce(
                                              color: ColorPalette.secondary,
                                              size: 15,
                                            ),
                                          ],
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.warning_rounded,
                                              color: ColorPalette.errorColor,
                                              size: 15,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              'Error fetching sections.',
                                              style: TextStyle(
                                                color: ColorPalette.errorColor,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: const BoxDecoration(
                                          color: ColorPalette.accentDarkWhite,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            hint: Text(
                                              snapshot.data!.isNotEmpty
                                                  ? "Enter Sections"
                                                  : "No Sections Currently",
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            isExpanded: true,
                                            iconSize: 32,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: ColorPalette.primary,
                                            ),
                                            value: sectionValue,
                                            items: snapshot.data!
                                                .map(buildMenuItem)
                                                .toList(),
                                            onChanged: ((sectionValue) =>
                                                setState(() {
                                                  this.sectionValue =
                                                      sectionValue ?? "";
                                                })),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 2),
                                Text(
                                  "Section was ${snapshot.data!.first.section}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                    future: getRooms(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Fetching rooms...',
                                              style: TextStyle(
                                                color: ColorPalette.primary,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SpinKitThreeBounce(
                                              color: ColorPalette.secondary,
                                              size: 15,
                                            ),
                                          ],
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.warning_rounded,
                                              color: ColorPalette.errorColor,
                                              size: 15,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              'Error fetching rooms.',
                                              style: TextStyle(
                                                color: ColorPalette.errorColor,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: const BoxDecoration(
                                          color: ColorPalette.accentDarkWhite,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            hint: Text(
                                              snapshot.data!.isNotEmpty
                                                  ? "Enter Rooms"
                                                  : "No Rooms Currently",
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            isExpanded: true,
                                            iconSize: 32,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: ColorPalette.primary,
                                            ),
                                            value: roomValue,
                                            items: snapshot.data!
                                                .map(buildMenuItem)
                                                .toList(),
                                            onChanged: ((roomValue) =>
                                                setState(() {
                                                  this.roomValue =
                                                      roomValue ?? "";
                                                })),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 2),
                                Text(
                                  "Room was ${snapshot.data!.first.room}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (() {
                                  setState(() {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (departmentValue == null ||
                                        dayValue == null ||
                                        timeValue == null ||
                                        sectionValue == null ||
                                        subjectValue == null ||
                                        roomValue == null) {
                                      DialogUnsuccessful(
                                        headertext: "Missing inputs!",
                                        subtext:
                                            "Please enter the missing dropdown inputs!",
                                        textButton: "Close",
                                        callback: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                      ).buildUnsuccessfulScreen(context);
                                      return;
                                    }

                                    List<String> changes = [];

                                    String professorID =
                                        _inputControllerProfessorID.text.trim();
                                    String fullName =
                                        _inputControllerName.text.trim();
                                    String? department = departmentValue;
                                    String email =
                                        _inputControllerEmail.text.trim();
                                    String phoneNumber =
                                        _inputControllerPhoneNumber.text.trim();
                                    String password =
                                        _inputControllerCfrmPassword.text
                                            .trim();
                                    String signature =
                                        _inputControllerSignatureCode.text
                                            .trim();

                                    String? subject = subjectValue.toString();
                                    String? section = sectionValue.toString();
                                    String? room = roomValue.toString();
                                    String? day = dayValue.toString();
                                    String? time = timeValue.toString();

                                    String currentName =
                                        snapshot.data!.first.name;
                                    String currentEmail =
                                        snapshot.data!.first.email;
                                    String currentDepartment =
                                        snapshot.data!.first.department;
                                    String currentPhoneNumber =
                                        snapshot.data!.first.phonenumber;
                                    String currentPassword =
                                        snapshot.data!.first.password;
                                    String currentSignature =
                                        snapshot.data!.first.signaturecode;
                                    String currentDay =
                                        snapshot.data!.first.day;
                                    String currentTime =
                                        snapshot.data!.first.time;
                                    String currentSubject =
                                        snapshot.data!.first.subject;
                                    String currentSection =
                                        snapshot.data!.first.section;
                                    String currentRoom =
                                        snapshot.data!.first.room;

                                    String currentEmailVer =
                                        snapshot.data!.first.isEmailVerified;

                                    String currentPhoneVer =
                                        snapshot.data!.first.isPhoneVerified;

                                    if (currentName != fullName) {
                                      changes.add(
                                          "Changed name from $currentName to $fullName");
                                    }

                                    if (currentEmail != email) {
                                      changes.add(
                                          "Changed email from $currentEmail to $email");
                                    }

                                    if (currentDepartment != department) {
                                      changes.add(
                                          "Changed department from $currentDepartment to $department");
                                    }

                                    if (currentPhoneNumber != phoneNumber) {
                                      changes.add(
                                          "Changed phone number from $currentPhoneNumber to $phoneNumber");
                                    }

                                    if (currentPassword != password) {
                                      changes.add(
                                          "Changed password from $currentPassword to $password");
                                    }

                                    if (currentSignature != signature) {
                                      changes.add(
                                          "Changed signature code from $currentSignature to $signature");
                                    }

                                    if (currentDay != day) {
                                      changes.add(
                                          "Changed Day from $currentDay to $day");
                                    }

                                    if (currentTime != time) {
                                      changes.add(
                                          "Changed Vacant Time from $currentTime to $time");
                                    }

                                    if (currentSubject != subject) {
                                      changes.add(
                                          "Changed Subject from $currentSubject to $subject");
                                    }

                                    if (currentSection != section) {
                                      changes.add(
                                          "Changed Section from $currentSection to $section");
                                    }

                                    if (currentRoom != room) {
                                      changes.add(
                                          "Changed Room from $currentRoom to $room");
                                    }

                                    DialogConfirmEdit(
                                        headertext: "Update this professor?",
                                        changes: changes,
                                        subtext:
                                            "Please take a look first before you press confirm!",
                                        callback: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();

                                          DialogLoading(subtext: "Changing")
                                              .buildLoadingScreen(context);

                                          Future.delayed(
                                              const Duration(seconds: 2),
                                              () async {
                                            Professor scholarObj = Professor(
                                              department: department.toString(),
                                              email: email,
                                              name: fullName,
                                              password: password,
                                              phonenumber: phoneNumber,
                                              professorId: professorID,
                                              signaturecode: signature,
                                              profilePicture: snapshot
                                                  .data!.first.profilePicture,
                                              day: day,
                                              room: room,
                                              section: section,
                                              subject: subject,
                                              time: time,
                                              listeningTo: snapshot
                                                  .data!.first.listeningTo,
                                              isEmailVerified: currentEmailVer,
                                              isPhoneVerified: currentPhoneVer,
                                            );

                                            await _dbReference
                                                .child(professorID)
                                                .set(scholarObj.toJson())
                                                .then(
                                              (value) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                String allChanges =
                                                    changes.join(", ");
                                                createHistory(
                                                  desc: changes.isNotEmpty
                                                      ? "Updated the Professor $fullName($professorID), here are the following changes: $allChanges"
                                                      : "Just pressed the update without changing anything on the Prof. $fullName($professorID).",
                                                  timeStamp: DateTime.now()
                                                      .microsecondsSinceEpoch
                                                      .toString(),
                                                  userType: userType,
                                                  id: userID,
                                                );
                                                DialogSuccess(
                                                  headertext:
                                                      "Successfully Modified!",
                                                  subtext:
                                                      "Would you like to view the contacts?",
                                                  textButton: "Contacts",
                                                  callback: () {
                                                    setState(() {
                                                      selectedIndex = 1;
                                                    });
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const AdminContacts()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  },
                                                ).buildSuccessScreen(context);
                                              },
                                            ).catchError(
                                              (err) {
                                                DialogUnsuccessful(
                                                  headertext: "Unsuccessful",
                                                  subtext:
                                                      "Please try again later!",
                                                  textButton: "Close",
                                                  callback: () => Navigator.of(
                                                          context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                ).buildUnsuccessfulScreen(
                                                    context);
                                              },
                                            );
                                          });
                                        }).buildConfirmEditScreen(context);
                                  });
                                }),
                                child: const Center(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: ColorPalette.accentWhite,
                                      fontFamily: 'Frank Ruhl Libre',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Professor>> getProfessor() async {
    List<Professor> myUser = [];
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/Professors/${widget.userID}');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Professor myProf = Professor.fromJson(myObj);
        if (!gotValue) {
          _inputControllerProfessorID.text = myProf.professorId;
          _inputControllerEmail.text = myProf.email;
          _inputControllerName.text = myProf.name;
          _inputControllerPhoneNumber.text = myProf.phonenumber;
          _inputControllerPassword.text = myProf.password;
          _inputControllerCfrmPassword.text = myProf.password;
          _inputControllerSignatureCode.text = myProf.signaturecode;
          _inputControllerRoom.text = myProf.room;
          _inputControllerSection.text = myProf.section;
          _inputControllerSubject.text = myProf.subject;

          departmentValue = myProf.department;
          dayValue = myProf.day;
          timeValue = myProf.time;
        }
        myUser.add(myProf);
      });
      gotValue = true;
      return myUser;
    } catch (error) {
      rethrow;
    }
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  Future<List<String>> getRooms() async {
    List<String> rooms = [];
    await choicesReference.child("room").get().then((snapshot) {
      for (final data in snapshot.children) {
        rooms.add(data.value.toString());
      }
    });

    rooms.sort();
    return rooms;
  }

  Future<List<String>> getSections() async {
    List<String> sections = [];
    await choicesReference.child("section").get().then((snapshot) {
      for (final data in snapshot.children) {
        sections.add(data.value.toString());
      }
    });

    sections.sort();
    return sections;
  }

  Future<List<String>> getSubjectCodes() async {
    List<String> subjectCodes = [];
    await choicesReference.child("subjectCode").get().then((snapshot) {
      for (final data in snapshot.children) {
        subjectCodes.add(data.value.toString());
        if (widget.currentSubject == data.value) {
          if (!gotValueSubject) subjectValue = data.value.toString();
        }
      }
    });

    subjectCodes.sort();
    gotValueSubject = true;
    return subjectCodes;
  }

  @override
  void dispose() {
    _inputControllerCfrmPassword.dispose();
    _inputControllerEmail.dispose();
    _inputControllerName.dispose();
    _inputControllerPassword.dispose();
    _inputControllerPhoneNumber.dispose();
    _inputControllerProfessorID.dispose();
    _inputControllerRoom.dispose();
    _inputControllerSection.dispose();
    _inputControllerSignatureCode.dispose();
    _inputControllerSubject.dispose();
    super.dispose();
  }
}
