import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';

final _inputControllerProfessorID = TextEditingController();
final _inputControllerName = TextEditingController();
final _inputControllerEmail = TextEditingController();
final _inputControllerPhoneNumber = TextEditingController();
final _inputControllerPassword = TextEditingController();
final _inputControllerCfrmPassword = TextEditingController();
final _inputControllerSignatureCode = TextEditingController();

final _formKey = GlobalKey<FormState>();

class EditProfessor extends StatefulWidget {
  final String userID;
  const EditProfessor({super.key, required this.userID});

  @override
  State<EditProfessor> createState() => _EditProfessorState();
}

class _EditProfessorState extends State<EditProfessor> {
  final DatabaseReference _dbReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");
  String? departmentValue;

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;

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
                        const SizedBox(height: 20),
                        Column(
                          children: [
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
                                          .map(buildMenuItemDepartments)
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
                            Container(height: 1, color: ColorPalette.primary),
                            const SizedBox(height: 18),
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
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
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _inputControllerSignatureCode
                                                      .text =
                                                  snapshot.data!.first
                                                      .signaturecode;
                                            });
                                          },
                                          icon: const Icon(Icons.paste_rounded),
                                        ),
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
                                    SelectableText(
                                      "Signature Code was ${snapshot.data!.first.signaturecode}",
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (() {
                                  setState(() {
                                    if (!_formKey.currentState!.validate() ||
                                        departmentValue == null) {
                                      return;
                                    }

                                    DialogConfirm(
                                        headertext: "Update this professor?",
                                        callback: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogLoading(subtext: "Changing")
                                              .buildLoadingScreen(context);

                                          String professorID =
                                              _inputControllerProfessorID.text
                                                  .trim();
                                          String fullName =
                                              _inputControllerName.text.trim();
                                          String? department = departmentValue;
                                          String email =
                                              _inputControllerEmail.text.trim();
                                          String phoneNumber =
                                              _inputControllerPhoneNumber.text
                                                  .trim();
                                          String password =
                                              _inputControllerCfrmPassword.text
                                                  .trim();
                                          String signature =
                                              _inputControllerSignatureCode.text
                                                  .trim();

                                          Future.delayed(
                                              const Duration(seconds: 2),
                                              () async {
                                            Professor scholarObj = Professor(
                                                department:
                                                    department.toString(),
                                                email: email,
                                                name: fullName,
                                                password: password,
                                                phonenumber: phoneNumber,
                                                professorId: professorID,
                                                signaturecode: signature,
                                                profilePicture: snapshot
                                                    .data!.first.profilePicture,
                                                day: '',
                                                room: '',
                                                section: '',
                                                subject: '',
                                                time: '');

                                            await _dbReference
                                                .child(professorID)
                                                .set(scholarObj.toJson());

                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();

                                            // ignore: use_build_context_synchronously
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
                                                            builder: (context) =>
                                                                const AdminContacts()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              },
                                            ).buildSuccessScreen(context);
                                          });
                                        }).buildConfirmScreen(context);
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
        _inputControllerProfessorID.text = myProf.professorId;
        myUser.add(myProf);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }

  DropdownMenuItem<String> buildMenuItemDepartments(String item) =>
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
