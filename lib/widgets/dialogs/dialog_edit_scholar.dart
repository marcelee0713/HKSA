import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';

final _inputControllerStudentNumberID = TextEditingController();
final _inputControllerName = TextEditingController();
final _inputControllerEmail = TextEditingController();
final _inputControllerPhoneNumber = TextEditingController();
final _inputControllerPassword = TextEditingController();
final _inputControllerCfrmPassword = TextEditingController();
final _inputControllerHours = TextEditingController();

final _formKey = GlobalKey<FormState>();

class EditScholar extends StatefulWidget {
  final String userID;
  const EditScholar({super.key, required this.userID});

  @override
  State<EditScholar> createState() => _EditScholarState();
}

class _EditScholarState extends State<EditScholar> {
  final DatabaseReference _dbReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  String? coursesValue;
  String? hkTypeValue;
  String? statusValue;

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: ColorPalette.secondary,
              child: FutureBuilder(
                future: getScholar(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: ColorPalette.primary,
                            ),
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
                                color: ColorPalette.accentWhite,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.name,
                              style: const TextStyle(
                                color: ColorPalette.accentWhite,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.studentNumber,
                              style: const TextStyle(
                                color: ColorPalette.accentWhite,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: ColorPalette.accentWhite),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
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
                                const SizedBox(height: 2),
                                SelectableText(
                                  "Student Number was ${snapshot.data!.first.studentNumber}",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                const SizedBox(height: 2),
                                SelectableText(
                                  "Password was ${snapshot.data!.first.password}",
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
                                height: 1, color: ColorPalette.accentWhite),
                            const SizedBox(height: 18),
                            Column(
                              children: [
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
                                          onChanged: ((statusValue) =>
                                              setState(() {
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _inputControllerHours,
                                      maxLength: 3,
                                      validator: (value) {
                                        final bool hoursValid =
                                            RegExp(r"^[0-9]+$")
                                                .hasMatch(value!);
                                        if (hoursValid && value.isNotEmpty) {
                                          return null;
                                        } else {
                                          return "Enter an input.";
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        counterText: "",
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
                                )
                              ],
                            ),
                            const SizedBox(height: 18),
                            InkWell(
                              onLongPress: (() {
                                setState(() {
                                  if (!_formKey.currentState!.validate() ||
                                      coursesValue == null ||
                                      hkTypeValue == null ||
                                      statusValue == null) {
                                    return;
                                  }

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
                                      _inputControllerPhoneNumber.text.trim();
                                  String password =
                                      _inputControllerCfrmPassword.text.trim();
                                  String hours =
                                      _inputControllerHours.text.trim();
                                  String? status = statusValue;
                                  String totalHoursInDuration = hours +
                                      snapshot.data!.first.totalHoursInDuration
                                          .substring(2);
                                  String totalHoursInDisplay =
                                      totalHoursInDuration
                                          .substring(0, 8)
                                          .replaceAll('.', '');
                                  String totalHoursRequired = "";

                                  Future.delayed(const Duration(seconds: 2),
                                      () async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    if (hkType == "25%") {
                                      totalHoursRequired = "60";
                                    } else if (hkType == "50%" ||
                                        hkType == "75%") {
                                      totalHoursRequired = "90";
                                    } else if (hkType == "100%") {
                                      totalHoursRequired = "90";
                                    } else if (hkType == "SA") {
                                      totalHoursRequired = "360";
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
                                        totalHoursRequired: totalHoursRequired,
                                        isFinished: isFinished,
                                        profilePicture: snapshot
                                            .data!.first.profilePicture);

                                    await _dbReference
                                        .child(studentNumber)
                                        .set(scholarObj.toJson());

                                    // ignore: use_build_context_synchronously
                                    DialogSuccess(
                                      headertext: "Successfully Modified!",
                                      subtext:
                                          "Would you like to view the contacts?",
                                      textButton: "Contacts",
                                      callback: () {
                                        setState(() {
                                          selectedIndex = 1;
                                        });
                                        Navigator.of(
                                                context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AdminContacts()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                    ).buildSuccessScreen(context);
                                  });
                                });
                              }),
                              child: Container(
                                width: 120,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                            const SizedBox(height: 2),
                            const Text(
                              "Long press to confirm.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
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

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/Scholars/${widget.userID}');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Scholar myScholar = Scholar.fromJson(myObj);
        myUser.add(myScholar);
      });
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
}
