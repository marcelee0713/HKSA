import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class AdminRegisterProfessorInputs extends StatefulWidget {
  const AdminRegisterProfessorInputs({super.key});

  @override
  State<AdminRegisterProfessorInputs> createState() =>
      _AdminRegisterProfessorInputsState();
}

class _AdminRegisterProfessorInputsState
    extends State<AdminRegisterProfessorInputs> {
  final DatabaseReference choicesReference =
      FirebaseDatabase.instance.ref().child("scheduleChoices/");
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
  String? departmentValue;
  String? dayValue;
  String? timeValue;
  String? roomValue;
  String? sectionValue;
  String? subjectValue;

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;

  final _inputControllerProfessorID = TextEditingController();
  final _inputControllerLastName = TextEditingController();
  final _inputControllerFirstName = TextEditingController();
  final _inputControllerMiddleName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerEmailDomain =
      TextEditingController(text: "@phinmaed.com");
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();
  final _inputControllerSignatureCode = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _cfrmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _dbReference =
        FirebaseDatabase.instance.ref().child("Users/Professors/");
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Container(height: 1, color: ColorPalette.primary),
          const SizedBox(height: 15),
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
            controller: _inputControllerProfessorID,
            maxLength: 20,
            validator: (value) {
              final bool profIdValid = RegExp(r"^[0-9-]+$").hasMatch(value!);
              if (profIdValid && value.length >= 10) {
                return null;
              } else if (value.length <= 9 && value.isNotEmpty) {
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
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
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
          TextFormField(
            controller: _inputControllerLastName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your last name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: ColorPalette.accentDarkWhite,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
              hintText: "Last Name",
            ),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerFirstName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your first name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: ColorPalette.accentDarkWhite,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
                hintText: "First name"),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerMiddleName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your middle name.";
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: ColorPalette.accentDarkWhite,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
                hintText: "Middle name"),
            style: const TextStyle(
              color: ColorPalette.primary,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _inputControllerPhoneNumber,
            maxLength: 11,
            validator: (value) {
              final bool phoneValid =
                  RegExp(r"^(09|\+639)\d{9}$").hasMatch(value!);
              if (phoneValid) {
                return null;
              } else if (value.length <= 11 && !phoneValid) {
                return "Invalid input.";
              } else if (value.length <= 10 && value.isNotEmpty) {
                return "Input is too short.";
              } else {
                return "Enter an input.";
              }
            },
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
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
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                items: HKSAStrings.departments.map(buildMenuItem).toList(),
                onChanged: ((departmentValue) => setState(() {
                      this.departmentValue = departmentValue ?? "";
                    })),
              ),
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                items: HKSAStrings.vacantday.map(buildMenuItem).toList(),
                onChanged: ((dayValue) => setState(() {
                      this.dayValue = dayValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                items: HKSAStrings.vacanttime.map(buildMenuItem).toList(),
                onChanged: ((timeValue) => setState(() {
                      this.timeValue = timeValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FutureBuilder(
              future: getSubjectCodes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      items: snapshot.data!.map(buildMenuItem).toList(),
                      onChanged: ((subjectValue) => setState(() {
                            this.subjectValue = subjectValue ?? "";
                          })),
                    ),
                  ),
                );
              }),
          const SizedBox(height: 18),
          FutureBuilder(
              future: getSections(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      items: snapshot.data!.map(buildMenuItem).toList(),
                      onChanged: ((sectionValue) => setState(() {
                            this.sectionValue = sectionValue ?? "";
                          })),
                    ),
                  ),
                );
              }),
          const SizedBox(height: 18),
          FutureBuilder(
              future: getRooms(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      items: snapshot.data!.map(buildMenuItem).toList(),
                      onChanged: ((roomValue) => setState(() {
                            this.roomValue = roomValue ?? "";
                          })),
                    ),
                  ),
                );
              }),
          const SizedBox(height: 18),
          Container(height: 1, color: ColorPalette.primary),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _inputControllerEmail,
                  maxLength: 40,
                  validator: (value) {
                    const myString = "@phinmaed.com";
                    if (!value!.contains(myString) && value.isNotEmpty) {
                      return null;
                    } else if (value.contains(myString) && value.isNotEmpty) {
                      return "Please remove $myString on this input";
                    } else {
                      return "Invalid Input";
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    counterText: "",
                    errorStyle: TextStyle(color: ColorPalette.errorColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      borderSide: BorderSide(
                        color: ColorPalette.errorColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      borderSide: BorderSide(
                        color: ColorPalette.errorColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    filled: true,
                    fillColor: ColorPalette.accentDarkWhite,
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                    hintText: "Username",
                  ),
                  style: const TextStyle(
                    color: ColorPalette.primary,
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (_inputControllerEmail.text != "" &&
                        !_inputControllerEmail.text.contains("@phinmaed.com")) {
                      return null;
                    } else if (_inputControllerEmail.text
                        .contains("@phinmaed.com")) {
                      return "@phinmaed.com";
                    } else {
                      return "";
                    }
                  },
                  controller: _inputControllerEmailDomain,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
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
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
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
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
              final bool cfrmPasswordValid = _inputControllerPassword.text ==
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
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
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
                    _cfrmPasswordVisible = !_cfrmPasswordVisible;
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
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter an input.";
              }
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
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
          const SizedBox(height: 2),
          const Text(
            "Note: Don't share this to anybody, this will be the professor's signature code in order to time out a scholar",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 18),
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
              onPressed: () async {
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
                    subtext: "Please enter the missing dropdown inputs!",
                    textButton: "Close",
                    callback: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ).buildUnsuccessfulScreen(context);
                  return;
                }

                DialogLoading(subtext: "Creating...")
                    .buildLoadingScreen(context);

                String professorID = _inputControllerProfessorID.text.trim();
                String fullName =
                    "${_inputControllerLastName.text.trim()} ${_inputControllerFirstName.text.trim()} ${_inputControllerMiddleName.text.trim()}";
                String? department = departmentValue;
                String email = _inputControllerEmail.text.trim() +
                    _inputControllerEmailDomain.text;
                String phoneNumber = _inputControllerPhoneNumber.text.trim();
                String password = _inputControllerCfrmPassword.text.trim();
                String signature = _inputControllerSignatureCode.text.trim();
                bool userExist = false;
                bool duplicateEmail = false;
                bool duplicatePhoneNumber = false;

                String? subject = subjectValue;
                String? section = sectionValue;
                String? room = roomValue;
                String? day = dayValue;
                String? time = timeValue;

                await _dbReference.get().then((snapshot) {
                  for (final data in snapshot.children) {
                    Map<String, dynamic> myObj =
                        jsonDecode(jsonEncode(data.value));
                    Professor myProfObj = Professor.fromJson(myObj);
                    if (data.key == professorID) {
                      userExist = true;
                    }
                    if (myProfObj.email == email) {
                      duplicateEmail = true;
                    }
                    if (myProfObj.phonenumber == phoneNumber) {
                      duplicatePhoneNumber = true;
                    }
                  }
                }).then(
                  (value) async {
                    if (userExist) {
                      Navigator.of(context, rootNavigator: true).pop();
                      DialogUnsuccessful(
                        headertext: "Account already exist!",
                        subtext:
                            "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                        textButton: "Close",
                        callback: (() =>
                            Navigator.of(context, rootNavigator: true).pop()),
                      ).buildUnsuccessfulScreen(context);
                      return;
                    }

                    if (duplicateEmail) {
                      Navigator.of(context, rootNavigator: true).pop();
                      DialogUnsuccessful(
                        headertext: "Email already exist!",
                        subtext:
                            "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                        textButton: "Close",
                        callback: (() =>
                            Navigator.of(context, rootNavigator: true).pop()),
                      ).buildUnsuccessfulScreen(context);
                      return;
                    }

                    if (duplicatePhoneNumber) {
                      Navigator.of(context, rootNavigator: true).pop();
                      DialogUnsuccessful(
                        headertext: "Phone number already exist!",
                        subtext:
                            "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                        textButton: "Close",
                        callback: (() =>
                            Navigator.of(context, rootNavigator: true).pop()),
                      ).buildUnsuccessfulScreen(context);
                      return;
                    }

                    if (!userExist &&
                        !duplicateEmail &&
                        !duplicatePhoneNumber) {
                      await createUser(email: email, password: password).then(
                        (value) async {
                          Professor scholarObj = Professor(
                            department: department.toString(),
                            email: email,
                            name: fullName,
                            phonenumber: phoneNumber,
                            professorId: professorID,
                            signaturecode: signature,
                            profilePicture: HKSAStrings.pfpPlaceholder,
                            day: day.toString(),
                            room: room.toString(),
                            section: section.toString(),
                            subject: subject.toString(),
                            time: time.toString(),
                            listeningTo: "",
                            isEmailVerified: 'false',
                            isPhoneVerified: 'false',
                          );

                          await _dbReference
                              .child(professorID)
                              .set(scholarObj.toJson())
                              .then(
                            (value) async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogSuccess(
                                headertext: "Successfully Registered!",
                                subtext: "You have registered a professor!",
                                textButton: "Go back",
                                callback: () async {
                                  setState(() {
                                    selectedIndex = 3;
                                  });
                                  // Will replace literally every page, that includes dialogs and others.
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminRegistration()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ).buildSuccessScreen(context);
                              await createHistory(
                                desc:
                                    "Create a Professor: $fullName($professorID)",
                                timeStamp: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                userType: userType,
                                id: userID,
                              );
                            },
                          ).catchError(
                            (err) {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogUnsuccessful(
                                headertext: "Error",
                                subtext: "Please try again later!",
                                textButton: "Close",
                                callback: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                              ).buildUnsuccessfulScreen(context);
                            },
                          );
                        },
                      ).catchError(
                        (err) {
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogUnsuccessful(
                            headertext: "Error",
                            subtext: err.toString(),
                            textButton: "Close",
                            callback: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                          ).buildUnsuccessfulScreen(context);
                        },
                      );
                    }
                  },
                );
              },
              child: const Text(
                "Sign up",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Frank Ruhl Libre',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputControllerProfessorID.dispose();
    _inputControllerLastName.dispose();
    _inputControllerFirstName.dispose();
    _inputControllerMiddleName.dispose();
    _inputControllerEmail.dispose();
    _inputControllerPhoneNumber.dispose();
    _inputControllerPassword.dispose();
    _inputControllerCfrmPassword.dispose();
    _inputControllerSignatureCode.dispose();

    super.dispose();
  }

  Future createUser({required String email, required String password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

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
      }
    });

    subjectCodes.sort();
    return subjectCodes;
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
}
