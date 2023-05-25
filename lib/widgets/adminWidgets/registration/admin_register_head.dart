import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_register_confirm_head.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/registerWidgets/register_header.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class AdminRegisterHeadPage extends StatefulWidget {
  const AdminRegisterHeadPage({super.key});

  @override
  State<AdminRegisterHeadPage> createState() => _AdminRegisterHeadPageState();
}

class _AdminRegisterHeadPageState extends State<AdminRegisterHeadPage> {
  final DatabaseReference dbReference =
      FirebaseDatabase.instance.ref().child("Users/Head/");
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");
  final _inputControllerUserID = TextEditingController();
  final _inputControllerLastName = TextEditingController();
  final _inputControllerFirstName = TextEditingController();
  final _inputControllerMiddleName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerEmailDomain =
      TextEditingController(text: "@phinmaed.com");
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: ColorPalette.accentWhite,
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: RegisterHeader()),
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
                    controller: _inputControllerUserID,
                    maxLength: 20,
                    validator: (value) {
                      final bool profIdValid =
                          RegExp(r"^[0-9-]+$").hasMatch(value!);
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
                      hintText: "User ID (XX-XNXX-XXXXX)",
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                  Container(height: 1, color: ColorPalette.primary),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Credentials:",
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
                      "Please enter your credentials. Don't forget to double check because there is no going back.",
                      style: TextStyle(
                        color: ColorPalette.primary,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _inputControllerEmail,
                          maxLength: 40,
                          validator: (value) {
                            String myValue = value!;
                            bool valid = true;
                            for (final i in HKSAStrings.emailValidation) {
                              if (myValue.contains(i)) {
                                valid = false;
                                break;
                              }
                            }

                            if (valid && value.isNotEmpty) {
                              return null;
                            } else if (!valid && value.isNotEmpty) {
                              return "Please remove phinmaed.com";
                            } else {
                              return "Invalid Input";
                            }
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            errorStyle:
                                const TextStyle(color: ColorPalette.errorColor),
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
                            errorBorder: const UnderlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5)),
                              borderSide: BorderSide(
                                color: ColorPalette.errorColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5)),
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
                          enabled: false,
                          validator: (value) {
                            String myValue = _inputControllerEmail.text;
                            bool valid = true;
                            String validator = "";
                            for (final i in HKSAStrings.emailValidation) {
                              if (myValue.contains(i)) {
                                valid = false;
                                validator = i;
                                break;
                              }
                            }
                            if (valid && myValue.isNotEmpty) {
                              return null;
                            } else if (!valid && myValue.isNotEmpty) {
                              return validator;
                            } else {
                              return "";
                            }
                          },
                          controller: _inputControllerEmailDomain,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                              color: ColorPalette.errorColor,
                              fontFamily: 'Inter',
                            ),
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
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5)),
                              borderSide: BorderSide(
                                color: ColorPalette.errorColor,
                                width: 1,
                                style: BorderStyle.solid,
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
                  Container(
                    width: 125,
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorPalette.primary),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        String headID = _inputControllerUserID.text.trim();
                        String fullName =
                            "${_inputControllerLastName.text.trim()} ${_inputControllerFirstName.text.trim()} ${_inputControllerMiddleName.text.trim()}";
                        // String email = _inputControllerEmail.text.trim() +
                        //     _inputControllerEmailDomain.text;
                        String email = "magbualmarcel@gmail.com";
                        String phoneNumber =
                            _inputControllerPhoneNumber.text.trim();
                        String password =
                            _inputControllerCfrmPassword.text.trim();

                        bool userExist = false;
                        bool duplicateEmail = false;
                        bool duplicatePhoneNumber = false;

                        List<String> inputs = [
                          "Full Name: $fullName",
                          "UserID: $headID",
                          "Email: $email",
                          "Phone Number: $phoneNumber"
                        ];

                        DialogConfirmRegistration(
                            headertext: "We need your confirmation!",
                            subtext:
                                "Please double check if have any typos or missing inputs!",
                            inputs: inputs,
                            callback: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogLoading(subtext: "Creating...")
                                  .buildLoadingScreen(context);
                              await dbReference.get().then((snapshot) {
                                for (final data in snapshot.children) {
                                  Map<String, dynamic> myObj =
                                      jsonDecode(jsonEncode(data.value));
                                  Head myHead = Head.fromJson(myObj);
                                  if (data.key == headID) {
                                    userExist = true;
                                  }
                                  if (myHead.email == email) {
                                    duplicateEmail = true;
                                  }
                                  if (myHead.phonenumber == phoneNumber) {
                                    duplicatePhoneNumber = true;
                                  }
                                }
                              }).then(
                                (value) async {
                                  if (userExist) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Account already exist!",
                                      subtext:
                                          "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                                      textButton: "Close",
                                      callback: (() => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop()),
                                    ).buildUnsuccessfulScreen(context);
                                    return;
                                  }

                                  if (duplicateEmail) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Email already exist!",
                                      subtext:
                                          "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                                      textButton: "Close",
                                      callback: (() => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop()),
                                    ).buildUnsuccessfulScreen(context);
                                    return;
                                  }

                                  if (duplicatePhoneNumber) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    DialogUnsuccessful(
                                      headertext: "Phone number already exist!",
                                      subtext:
                                          "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                                      textButton: "Close",
                                      callback: (() => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop()),
                                    ).buildUnsuccessfulScreen(context);
                                    return;
                                  }

                                  if (!userExist &&
                                      !duplicateEmail &&
                                      !duplicatePhoneNumber) {
                                    await createUser(
                                            email: email, password: password)
                                        .then(
                                      (value) async {
                                        Head headObj = Head(
                                          status: 'active',
                                          email: email,
                                          name: fullName,
                                          phonenumber: phoneNumber,
                                          userId: headID,
                                          profilePicture:
                                              HKSAStrings.pfpPlaceholder,
                                          listeningTo: "",
                                          isEmailVerified: 'false',
                                          isPhoneVerified: 'false',
                                          isSuperAdmin: 'false',
                                        );

                                        await dbReference
                                            .child(headID)
                                            .set(headObj.toJson())
                                            .then(
                                          (value) async {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            DialogSuccess(
                                              headertext:
                                                  "Successfully Registered!",
                                              subtext:
                                                  "You have registered an Admin!",
                                              textButton: "Go back",
                                              callback: () async {
                                                setState(() {
                                                  selectedIndex = 3;
                                                });
                                                // Will replace literally every page, that includes dialogs and others.
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AdminRegistration()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              },
                                            ).buildSuccessScreen(context);
                                            await createHistory(
                                              desc:
                                                  "Create an Admin: $fullName($headID)",
                                              timeStamp: DateTime.now()
                                                  .microsecondsSinceEpoch
                                                  .toString(),
                                              userType: userType,
                                              id: userID,
                                            );
                                          },
                                        ).catchError(
                                          (err) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            DialogUnsuccessful(
                                              headertext: "Error",
                                              subtext:
                                                  "Please try again later!",
                                              textButton: "Close",
                                              callback: () => Navigator.of(
                                                      context,
                                                      rootNavigator: true)
                                                  .pop(),
                                            ).buildUnsuccessfulScreen(context);
                                          },
                                        );
                                      },
                                    ).catchError(
                                      (err) {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        DialogUnsuccessful(
                                          headertext: "Error",
                                          subtext: err.toString(),
                                          textButton: "Close",
                                          callback: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                        ).buildUnsuccessfulScreen(context);
                                      },
                                    );
                                  }
                                },
                              );
                            }).buildConfirmRegistration(context);
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
            ),
          ],
        ),
      ),
    );
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
}
