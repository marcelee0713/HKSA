import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/prof_schedule_match.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';

class EditScholar extends StatefulWidget {
  final String userID;
  const EditScholar({super.key, required this.userID});

  @override
  State<EditScholar> createState() => _EditScholarState();
}

class _EditScholarState extends State<EditScholar> {
  final _inputControllerStudentNumberID = TextEditingController();
  final _inputControllerName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();
  final _inputControllerHours = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference _dbReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");

  String? coursesValue;
  String? hkTypeValue;
  String? statusValue;
  String? townValue;
  String? scholarTypeValue;

  String? onSiteDay1Value;
  String? onSiteDay2Value;
  String? wholeDayValue;
  String? vacantTimeDay1Value;
  String? vacantTimeDay2Value;

  String? assignedProfDay1;
  String? assignedProfDay2;
  String? assignedProfWholeDay;
  // TODO: Error in the wholeDayVacantTime

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;
  bool gotValue = false;

  Map<String, String> professorNameForDay1 = {};
  Map<String, String> professorNameForDay2 = {};
  Map<String, String> professorNameForWholeDay = {};

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
                future: getScholar(),
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
                  if (gotValue) {}
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
                              "You are now editing:",
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
                              snapshot.data!.first.studentNumber,
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
                              controller: _inputControllerStudentNumberID,
                              maxLength: 20,
                              validator: (value) {
                                final bool studentIdValid =
                                    RegExp(r"^[0-9-]+$").hasMatch(value!);
                                if (studentIdValid && value.length >= 10) {
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
                                hintText: "Student Number (XX-XNXX-XXXXX)",
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
                                        icon: const Icon(Icons.undo),
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
                                        "Courses",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: coursesValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.courses
                                          .map(buildMenuItemCourses)
                                          .toList(),
                                      onChanged: ((coursesValue) =>
                                          setState(() {
                                            this.coursesValue =
                                                coursesValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Course was ${snapshot.data!.first.course}",
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        "Status",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: statusValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.statuses
                                          .map(buildMenuItemStatuses)
                                          .toList(),
                                      onChanged: ((statusValue) => setState(() {
                                            this.statusValue =
                                                statusValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Status was ${snapshot.data!.first.status}",
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
                                      icon: const Icon(Icons.undo),
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
                                      icon: const Icon(Icons.undo),
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
                                        "Town",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: townValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.towns
                                          .map(buildMenuItemTown)
                                          .toList(),
                                      onChanged: ((townValue) => setState(() {
                                            this.townValue = townValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Town was ${snapshot.data!.first.town}",
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
                            Container(height: 1, color: ColorPalette.primary),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Dependent Information:",
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
                                "Please be careful modifying these informations! Since they rely on other information also.",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
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
                                        "HK Type",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: hkTypeValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.hkTypes
                                          .map(buildMenuItemHKTypes)
                                          .toList(),
                                      onChanged: ((hkTypeValue) => setState(() {
                                            this.hkTypeValue =
                                                hkTypeValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "HK Type was ${snapshot.data!.first.hkType}",
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
                                        "Scholar Type",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      value: scholarTypeValue,
                                      isExpanded: true,
                                      iconSize: 32,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: ColorPalette.primary,
                                      ),
                                      items: HKSAStrings.facitype
                                          .map(buildMenuItemTown)
                                          .toList(),
                                      onChanged: ((scholarTypeValue) =>
                                          setState(() {
                                            this.scholarTypeValue =
                                                scholarTypeValue ?? "";
                                          })),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Scholar Type was ${snapshot.data!.first.scholarType}",
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _inputControllerHours,
                                  maxLength: 3,
                                  validator: (value) {
                                    final bool hoursValid =
                                        RegExp(r"^[0-9]+$").hasMatch(value!);
                                    if (hoursValid && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Enter an input.";
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _inputControllerHours.text =
                                              snapshot.data!.first.hours;
                                        });
                                      },
                                      icon: const Icon(Icons.undo),
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
                                    hintText: "Hours",
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
                                  "Total Hours was ${snapshot.data!.first.hours}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            scholarTypeValue == "Faci"
                                ? Column(
                                    children: [
                                      const SizedBox(height: 18),
                                      Container(
                                          height: 1,
                                          color: ColorPalette.primary),
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
                                          "You can only see and change the information if the scholar is Faci.",
                                          style: TextStyle(
                                            color: ColorPalette.primary,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  ColorPalette.accentDarkWhite,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: const Text(
                                                  "On Site Day 1",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                value: onSiteDay1Value,
                                                isExpanded: true,
                                                iconSize: 32,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: ColorPalette.primary,
                                                ),
                                                items: HKSAStrings.onsite
                                                    .map(
                                                        buildMenuItemOnSiteDay1)
                                                    .toList(),
                                                onChanged: ((onSiteDay1Value) =>
                                                    setState(() {
                                                      this.onSiteDay1Value =
                                                          onSiteDay1Value ?? "";
                                                      assignedProfDay1 = null;
                                                    })),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "On Site Day 1 was ${snapshot.data!.first.onSiteDay1}",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  ColorPalette.accentDarkWhite,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: const Text(
                                                  "On Site Day 2",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                value: onSiteDay2Value,
                                                isExpanded: true,
                                                iconSize: 32,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: ColorPalette.primary,
                                                ),
                                                items: HKSAStrings.onsite
                                                    .map(
                                                        buildMenuItemOnSiteDay2)
                                                    .toList(),
                                                onChanged: ((onSiteDay2Value) =>
                                                    setState(() {
                                                      this.onSiteDay2Value =
                                                          onSiteDay2Value ?? "";
                                                      assignedProfDay2 = null;
                                                    })),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "On Site Day 2 was ${snapshot.data!.first.onSiteDay2}",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  ColorPalette.accentDarkWhite,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: const Text(
                                                  "Whole Day On Site",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                value: wholeDayValue,
                                                isExpanded: true,
                                                iconSize: 32,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: ColorPalette.primary,
                                                ),
                                                items: HKSAStrings.onsite
                                                    .map(
                                                        buildMenuItemOnSiteWholeDay)
                                                    .toList(),
                                                onChanged: ((wholeDayValue) =>
                                                    setState(() {
                                                      this.wholeDayValue =
                                                          wholeDayValue ?? "";
                                                      assignedProfWholeDay =
                                                          null;
                                                    })),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Whole day On Site was ${snapshot.data!.first.wholeDayVacantTime}",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  ColorPalette.accentDarkWhite,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: const Text(
                                                  "Vacant Time Day 1",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                value: vacantTimeDay1Value,
                                                isExpanded: true,
                                                iconSize: 32,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: ColorPalette.primary,
                                                ),
                                                items: HKSAStrings.vacanttime
                                                    .map(
                                                        buildMenuItemVacantTimeDay1)
                                                    .toList(),
                                                onChanged:
                                                    ((vacantTimeDay1Value) =>
                                                        setState(() {
                                                          this.vacantTimeDay1Value =
                                                              vacantTimeDay1Value ??
                                                                  "";
                                                          assignedProfDay1 =
                                                              null;
                                                        })),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Vacant Time Day 1 was ${snapshot.data!.first.vacantTimeDay1}",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  ColorPalette.accentDarkWhite,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                hint: const Text(
                                                  "Vacant Time Day 2",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                value: vacantTimeDay2Value,
                                                isExpanded: true,
                                                iconSize: 32,
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: ColorPalette.primary,
                                                ),
                                                items: HKSAStrings.vacanttime
                                                    .map(
                                                        buildMenuItemVacantTimeDay2)
                                                    .toList(),
                                                onChanged:
                                                    ((vacantTimeDay2Value) =>
                                                        setState(() {
                                                          this.vacantTimeDay2Value =
                                                              vacantTimeDay2Value ??
                                                                  "";
                                                          assignedProfDay2 =
                                                              null;
                                                        })),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Vacant Time Day 2 was ${snapshot.data!.first.vacantTimeDay2}",
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
                                      Container(
                                          height: 1,
                                          color: ColorPalette.primary),
                                      const SizedBox(height: 15),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Assigned Professors:",
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
                                          "This depends on the Faci's Schedule Infromation.",
                                          style: TextStyle(
                                            color: ColorPalette.primary,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FutureBuilder(
                                        future: getProfessors(
                                            scholarOnSiteDay1:
                                                onSiteDay1Value.toString(),
                                            scholarOnSiteDay2:
                                                onSiteDay2Value.toString(),
                                            scholarOnSiteWholeDay:
                                                wholeDayValue.toString(),
                                            scholarVacantTimeDay1:
                                                vacantTimeDay1Value.toString(),
                                            scholarVacantTimeDay2:
                                                vacantTimeDay2Value.toString()),
                                        builder: (context, prof1Snapshot) {
                                          professorNameForDay1.clear();
                                          List<String> professorsValueForDay1 =
                                              [];
                                          if (prof1Snapshot.data?['profDay1'] !=
                                              null) {
                                            List<ProfScheduleMatch> profDay1 =
                                                prof1Snapshot.data?['profDay1'];
                                            for (var i = 0;
                                                i < profDay1.length;
                                                i++) {
                                              professorNameForDay1[profDay1[i]
                                                  .id] = profDay1[i].name;

                                              professorsValueForDay1
                                                  .add(profDay1[i].id);
                                            }
                                          }
                                          if (!prof1Snapshot.hasData) {
                                            return Column(
                                              children: const [
                                                SpinKitThreeBounce(
                                                  color: ColorPalette.secondary,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Matching Day 1...',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: ColorPalette
                                                          .secondary),
                                                ),
                                              ],
                                            );
                                          }
                                          if (prof1Snapshot.hasError) {
                                            return Column(
                                              children: const [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  size: 20,
                                                  color:
                                                      ColorPalette.errorColor,
                                                ),
                                                Text(
                                                  "Error, try again later!",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    color:
                                                        ColorPalette.errorColor,
                                                  ),
                                                )
                                              ],
                                            );
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorPalette
                                                      .accentDarkWhite,
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    hint: Text(
                                                      professorsValueForDay1
                                                              .isEmpty
                                                          ? "No Available Professors"
                                                          : "Select Professors",
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    value: assignedProfDay1,
                                                    isExpanded: true,
                                                    iconSize: 32,
                                                    icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          ColorPalette.primary,
                                                    ),
                                                    items: professorsValueForDay1
                                                        .map(
                                                            buildMenuItemOnSiteProfDay1)
                                                        .toList(),
                                                    onChanged:
                                                        ((assignedProfDay1) =>
                                                            setState(() {
                                                              this.assignedProfDay1 =
                                                                  assignedProfDay1 ??
                                                                      "";
                                                            })),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Assgined Prof on Day 1 was ${snapshot.data!.first.assignedProfD1}",
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      FutureBuilder(
                                        future: getProfessors(
                                            scholarOnSiteDay1:
                                                onSiteDay1Value.toString(),
                                            scholarOnSiteDay2:
                                                onSiteDay2Value.toString(),
                                            scholarOnSiteWholeDay:
                                                wholeDayValue.toString(),
                                            scholarVacantTimeDay1:
                                                vacantTimeDay1Value.toString(),
                                            scholarVacantTimeDay2:
                                                vacantTimeDay2Value.toString()),
                                        builder: (context, prof2Snapshot) {
                                          professorNameForDay2.clear();
                                          List<String> professorsValueForDay2 =
                                              [];
                                          if (prof2Snapshot.data?['profDay2'] !=
                                              null) {
                                            List<ProfScheduleMatch> profDay2 =
                                                prof2Snapshot.data?['profDay2'];
                                            for (var i = 0;
                                                i < profDay2.length;
                                                i++) {
                                              professorNameForDay2[profDay2[i]
                                                  .id] = profDay2[i].name;

                                              professorsValueForDay2
                                                  .add(profDay2[i].id);
                                            }
                                          }

                                          if (!prof2Snapshot.hasData) {
                                            return Column(
                                              children: const [
                                                SpinKitThreeBounce(
                                                  color: ColorPalette.secondary,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Matching Day 2...',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: ColorPalette
                                                          .secondary),
                                                ),
                                              ],
                                            );
                                          }
                                          if (prof2Snapshot.hasError) {
                                            return Column(
                                              children: const [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  size: 20,
                                                  color:
                                                      ColorPalette.errorColor,
                                                ),
                                                Text(
                                                  "Error, try again later!",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    color:
                                                        ColorPalette.errorColor,
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorPalette
                                                      .accentDarkWhite,
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    hint: Text(
                                                      professorsValueForDay2
                                                              .isEmpty
                                                          ? "No Available Professors"
                                                          : "Select Professors",
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    value: assignedProfDay2,
                                                    isExpanded: true,
                                                    iconSize: 32,
                                                    icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          ColorPalette.primary,
                                                    ),
                                                    items: professorsValueForDay2
                                                        .map(
                                                            buildMenuItemOnSiteProfDay2)
                                                        .toList(),
                                                    onChanged:
                                                        ((assignedProfDay2) =>
                                                            setState(() {
                                                              this.assignedProfDay2 =
                                                                  assignedProfDay2 ??
                                                                      "";
                                                            })),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Assgined Prof on Day 2 was ${snapshot.data!.first.assignedProfD2}",
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      FutureBuilder(
                                        future: getProfessors(
                                            scholarOnSiteDay1:
                                                onSiteDay1Value.toString(),
                                            scholarOnSiteDay2:
                                                onSiteDay2Value.toString(),
                                            scholarOnSiteWholeDay:
                                                wholeDayValue.toString(),
                                            scholarVacantTimeDay1:
                                                vacantTimeDay1Value.toString(),
                                            scholarVacantTimeDay2:
                                                vacantTimeDay2Value.toString()),
                                        builder: (context, profWdSnapshot) {
                                          professorNameForWholeDay.clear();
                                          List<String>
                                              professorsValueForWholeDay = [];
                                          if (profWdSnapshot
                                                  .data?['profWholeDay'] !=
                                              null) {
                                            List<ProfScheduleMatch>
                                                profWholeDay = profWdSnapshot
                                                    .data?['profWholeDay'];
                                            for (var i = 0;
                                                i < profWholeDay.length;
                                                i++) {
                                              professorNameForWholeDay[
                                                      profWholeDay[i].id] =
                                                  profWholeDay[i].name;

                                              professorsValueForWholeDay
                                                  .add(profWholeDay[i].id);
                                            }
                                          }
                                          if (!profWdSnapshot.hasData) {
                                            return Column(
                                              children: const [
                                                SpinKitThreeBounce(
                                                  color: ColorPalette.secondary,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Matching Whole Day...',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: ColorPalette
                                                          .secondary),
                                                ),
                                              ],
                                            );
                                          }
                                          if (profWdSnapshot.hasError) {
                                            return Column(
                                              children: const [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  size: 20,
                                                  color:
                                                      ColorPalette.errorColor,
                                                ),
                                                Text(
                                                  "Error, try again later!",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    color:
                                                        ColorPalette.errorColor,
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorPalette
                                                      .accentDarkWhite,
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    hint: Text(
                                                      professorsValueForWholeDay
                                                              .isEmpty
                                                          ? "No Available Professors"
                                                          : "Select Professors",
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    value: assignedProfWholeDay,
                                                    isExpanded: true,
                                                    iconSize: 32,
                                                    icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          ColorPalette.primary,
                                                    ),
                                                    items: professorsValueForWholeDay
                                                        .map(
                                                            buildMenuItemOnSiteProfWholeDay)
                                                        .toList(),
                                                    onChanged:
                                                        ((assignedProfWholeDay) =>
                                                            setState(() {
                                                              this.assignedProfWholeDay =
                                                                  assignedProfWholeDay ??
                                                                      "";
                                                            })),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Assgined Prof on Whole Day was ${snapshot.data!.first.assignedProfWd}",
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  )
                                : const SizedBox(height: 18),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (() {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  DialogConfirm(
                                      headertext: "Update this scholar?",
                                      callback: () {
                                        if (scholarTypeValue == "Non-Faci") {
                                          assignedProfDay1 = "";
                                          assignedProfDay2 = "";
                                          assignedProfWholeDay = "";
                                          onSiteDay1Value = "NONE";
                                          onSiteDay2Value = "NONE";
                                          wholeDayValue = "NONE";
                                          vacantTimeDay1Value = "NONE";
                                          vacantTimeDay2Value = "NONE";
                                        } else {
                                          assignedProfDay1 ??= "";
                                          assignedProfDay2 ??= "";
                                          assignedProfWholeDay ??= "";
                                        }
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();

                                        DialogLoading(subtext: "Changing")
                                            .buildLoadingScreen(context);

                                        String studentNumber =
                                            _inputControllerStudentNumberID.text
                                                .trim();
                                        String fullName =
                                            _inputControllerName.text.trim();
                                        String? course = coursesValue;
                                        String? hkType = hkTypeValue;
                                        String email =
                                            _inputControllerEmail.text.trim();
                                        String phoneNumber =
                                            _inputControllerPhoneNumber.text
                                                .trim();
                                        String password =
                                            _inputControllerCfrmPassword.text
                                                .trim();
                                        String hours =
                                            _inputControllerHours.text.trim();
                                        String? status = statusValue;
                                        String totalHoursInDuration =
                                            getUpdatedDuration(
                                                hours,
                                                snapshot.data!.first
                                                    .totalHoursInDuration);
                                        String totalHoursInDisplay =
                                            totalHoursInDuration
                                                .substring(0, 8)
                                                .replaceAll('.', '');
                                        String totalHoursRequired = "";

                                        Future.delayed(
                                            const Duration(seconds: 2),
                                            () async {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          if (hkType == "HK25") {
                                            totalHoursRequired = "60";
                                          } else if (hkType == "HK50" ||
                                              hkType == "HK75") {
                                            totalHoursRequired = "90";
                                          }
                                          String isFinished =
                                              snapshot.data!.first.isFinished;

                                          Scholar scholarObj = Scholar(
                                              studentNumber: studentNumber,
                                              name: fullName,
                                              course: course.toString(),
                                              email: email,
                                              phonenumber: phoneNumber,
                                              password: password,
                                              hkType: hkType.toString(),
                                              hours: hours,
                                              status: status.toString(),
                                              totalHoursInDisplay:
                                                  totalHoursInDisplay,
                                              totalHoursInDuration:
                                                  totalHoursInDuration,
                                              totalHoursRequired:
                                                  totalHoursRequired,
                                              isFinished: isFinished,
                                              profilePicture: snapshot
                                                  .data!.first.profilePicture,
                                              onSiteDay1:
                                                  onSiteDay1Value.toString(),
                                              onSiteDay2:
                                                  onSiteDay2Value.toString(),
                                              vacantTimeDay1:
                                                  vacantTimeDay1Value
                                                      .toString(),
                                              vacantTimeDay2:
                                                  vacantTimeDay2Value
                                                      .toString(),
                                              wholeDayVacantTime:
                                                  wholeDayValue.toString(),
                                              scholarType:
                                                  scholarTypeValue.toString(),
                                              town: townValue.toString(),
                                              assignedProfD1:
                                                  assignedProfDay1.toString(),
                                              assignedProfD2:
                                                  assignedProfDay2.toString(),
                                              assignedProfWd:
                                                  assignedProfWholeDay
                                                      .toString(),
                                              listeningTo: snapshot
                                                  .data!.first.listeningTo);

                                          await _dbReference
                                              .child(studentNumber)
                                              .set(scholarObj.toJson());

                                          // ignore: use_build_context_synchronously
                                          DialogSuccess(
                                            headertext:
                                                "Successfully Modified!",
                                            subtext:
                                                "Would you like to view the contacts? It's recommended so you can see the changes.",
                                            textButton: "Contacts",
                                            callback: () {
                                              //TODO: Maybe try setting the values of the error here?
                                              setState(() {
                                                onSiteDay1Value = null;
                                                onSiteDay2Value = null;
                                                wholeDayValue = null;
                                                vacantTimeDay1Value = null;
                                                vacantTimeDay2Value = null;
                                                assignedProfDay1 = null;
                                                assignedProfDay2 = null;
                                                assignedProfWholeDay = null;

                                                selectedIndex = 1;
                                              });
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AdminContacts()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            },
                                          ).buildSuccessScreen(context);
                                        });
                                      }).buildConfirmScreen(context);
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

  String getUpdatedDuration(String hourInput, String duration) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = duration.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(
            hours: int.parse(hourInput), minutes: minutes, microseconds: micros)
        .toString();
  }

  Future<Map<String, dynamic>> getProfessors(
      {required String scholarOnSiteDay1,
      required String scholarOnSiteDay2,
      required String scholarOnSiteWholeDay,
      required String scholarVacantTimeDay1,
      required String scholarVacantTimeDay2}) async {
    List<ProfScheduleMatch> day1Professors = [];
    List<ProfScheduleMatch> day2Professors = [];
    List<ProfScheduleMatch> wholeDayProfessors = [];
    Map<String, dynamic> matchedProfesssors = {};
    final DatabaseReference _userReference =
        FirebaseDatabase.instance.ref().child('Users/Professors/');
    try {
      await _userReference.get().then((snapshot) {
        int loop = 0;
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        myObj.forEach(
          (key, value) {
            String day = myObj[key]['day'];
            String department = myObj[key]['department'];
            String email = myObj[key]['email'];
            String name = myObj[key]['name'];
            String password = myObj[key]['password'];
            String phonenumber = myObj[key]['phonenumber'];
            String professorID = myObj[key]['professorID'];
            String profilePicture = myObj[key]['profilePicture'];
            String room = myObj[key]['room'];
            String section = myObj[key]['section'];
            String signaturecode = myObj[key]['signaturecode'];
            String subject = myObj[key]['subject'];
            String time = myObj[key]['time'];
            String listeningTo = myObj[key]['listeningTo'];

            Professor myProf = Professor(
                department: department,
                email: email,
                name: name,
                password: password,
                phonenumber: phonenumber,
                professorId: professorID,
                signaturecode: signaturecode,
                profilePicture: profilePicture,
                section: section,
                subject: subject,
                day: day,
                time: time,
                room: room,
                listeningTo: listeningTo);

            if (myProf.day == scholarOnSiteDay1 &&
                myProf.time == scholarVacantTimeDay1) {
              String name = myProf.name;
              String id = myProf.professorId;
              String day = myProf.day;
              String time = myProf.time;

              ProfScheduleMatch matchProf =
                  ProfScheduleMatch(name: name, id: id, day: day, time: time);
              day1Professors.add(matchProf);
            } else if (myProf.day == scholarOnSiteDay2 &&
                myProf.time == scholarVacantTimeDay2) {
              String name = myProf.name;
              String id = myProf.professorId;
              String day = myProf.day;
              String time = myProf.time;

              ProfScheduleMatch matchProf =
                  ProfScheduleMatch(name: name, id: id, day: day, time: time);
              day2Professors.add(matchProf);
            } else if (myProf.day == scholarOnSiteWholeDay) {
              String name = myProf.name;
              String id = myProf.professorId;
              String day = myProf.day;
              String time = myProf.time;

              ProfScheduleMatch matchProf =
                  ProfScheduleMatch(name: name, id: id, day: day, time: time);
              wholeDayProfessors.add(matchProf);
            }

            loop++;
          },
        );
        matchedProfesssors = {
          "profDay1": day1Professors,
          "profDay2": day2Professors,
          "profWholeDay": wholeDayProfessors,
        };
      });
    } catch (error) {
      rethrow;
    }

    debugPrint(matchedProfesssors.toString());
    return matchedProfesssors;
  }

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/Scholars/${widget.userID}');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Scholar myScholar = Scholar.fromJson(myObj);

        // This prevents going back to the initalValue whenever a suffix icon
        // or a user pressed into any dropdown.
        if (!gotValue) {
          _inputControllerStudentNumberID.text = myScholar.studentNumber;
          _inputControllerName.text = myScholar.name;
          _inputControllerEmail.text = myScholar.email;
          _inputControllerPhoneNumber.text = myScholar.phonenumber;
          _inputControllerPassword.text = myScholar.password;
          _inputControllerCfrmPassword.text = myScholar.password;
          _inputControllerHours.text = myScholar.hours;
          hkTypeValue = myScholar.hkType;
          statusValue = myScholar.status;
          coursesValue = myScholar.course;
          townValue = myScholar.town;
          scholarTypeValue = myScholar.scholarType;

          onSiteDay1Value =
              myScholar.onSiteDay1 == "" ? null : myScholar.onSiteDay1;
          onSiteDay2Value =
              myScholar.onSiteDay2 == "" ? null : myScholar.onSiteDay2;
          wholeDayValue = myScholar.wholeDayVacantTime == ""
              ? null
              : myScholar.wholeDayVacantTime;
          vacantTimeDay1Value =
              myScholar.vacantTimeDay1 == "" ? null : myScholar.vacantTimeDay1;
          vacantTimeDay2Value =
              myScholar.vacantTimeDay2 == "" ? null : myScholar.vacantTimeDay2;

          assignedProfDay1 =
              myScholar.assignedProfD1 == "" ? null : myScholar.assignedProfD1;
          assignedProfDay2 =
              myScholar.assignedProfD2 == "" ? null : myScholar.assignedProfD2;
          assignedProfWholeDay =
              myScholar.assignedProfWd == "" ? null : myScholar.assignedProfWd;
        }

        myUser.add(myScholar);
      });
      gotValue = true;
      return myUser;
    } catch (error) {
      rethrow;
    }
  }

  DropdownMenuItem<String> buildMenuItemCourses(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemHKTypes(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemStatuses(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemTown(String item) => DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemScholarType(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemOnSiteDay1(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemOnSiteDay2(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemOnSiteWholeDay(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemVacantTimeDay1(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemVacantTimeDay2(String item) =>
      DropdownMenuItem(
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

  DropdownMenuItem<String> buildMenuItemOnSiteProfDay1(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          '$item, ${professorNameForDay1[item]}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItemOnSiteProfDay2(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          '$item, ${professorNameForDay2[item]}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItemOnSiteProfWholeDay(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          '$item, ${professorNameForWholeDay[item]}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  @override
  void dispose() {
    _inputControllerName.dispose();
    _inputControllerCfrmPassword.dispose();
    _inputControllerEmail.dispose();
    _inputControllerHours.dispose();
    _inputControllerPassword.dispose();
    _inputControllerPhoneNumber.dispose();
    _inputControllerStudentNumberID.dispose();
    super.dispose();
  }
}
