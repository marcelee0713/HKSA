import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/registration.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class AdminRegisterProfessorInputs extends StatefulWidget {
  const AdminRegisterProfessorInputs({super.key});

  @override
  State<AdminRegisterProfessorInputs> createState() =>
      _AdminRegisterProfessorInputsState();
}

class _AdminRegisterProfessorInputsState
    extends State<AdminRegisterProfessorInputs> {
  String? departmentValue;

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;

  final _inputControllerProfessorID = TextEditingController();
  final _inputControllerLastName = TextEditingController();
  final _inputControllerFirstName = TextEditingController();
  final _inputControllerMiddleName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
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
                items: HKSAStrings.departments
                    .map(buildMenuItemDepartments)
                    .toList(),
                onChanged: ((departmentValue) => setState(() {
                      this.departmentValue = departmentValue ?? "";
                    })),
              ),
            ),
          ),
          const SizedBox(height: 18),
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
              hintText: "Email",
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
              onPressed: (() {
                setState(() {
                  if (!_formKey.currentState!.validate() ||
                      departmentValue == null) {
                    return;
                  }

                  DialogLoading(subtext: "Creating...")
                      .buildLoadingScreen(context);

                  String professorID = _inputControllerProfessorID.text.trim();
                  String fullName =
                      "${_inputControllerLastName.text.trim()} ${_inputControllerFirstName.text.trim()} ${_inputControllerMiddleName.text.trim()}";
                  String? department = departmentValue;
                  String email = _inputControllerEmail.text.trim();
                  String phoneNumber = _inputControllerPhoneNumber.text.trim();
                  String password = _inputControllerCfrmPassword.text.trim();
                  String signature = _inputControllerSignatureCode.text.trim();
                  bool userExist = false;

                  Future.delayed(const Duration(seconds: 2), () async {
                    await _dbReference.get().then((snapshot) {
                      for (final test in snapshot.children) {
                        if (test.key == professorID) {
                          userExist = true;
                          break;
                        }
                      }
                    }).whenComplete(() => {
                          Future.delayed(const Duration(milliseconds: 2500),
                              () async {
                            if (userExist) {
                              // Show a new a dialog that this user already exist
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogUnsuccessful(
                                headertext: "Account already exist!",
                                subtext:
                                    "If you think this is wrong. Please contact or go to the CSDL Department immediately!",
                                textButton: "Close",
                                callback: (() =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop()),
                              ).buildUnsuccessfulScreen(context);
                            } else {
                              Professor scholarObj = Professor(
                                  department: department.toString(),
                                  email: email,
                                  name: fullName,
                                  password: password,
                                  phonenumber: phoneNumber,
                                  professorId: professorID,
                                  signaturecode: signature,
                                  profilePicture: HKSAStrings.pfpPlaceholder);

                              await _dbReference
                                  .child(professorID)
                                  .set(scholarObj.toJson());

                              // ignore: use_build_context_synchronously
                              Navigator.of(context, rootNavigator: true).pop();

                              // ignore: use_build_context_synchronously
                              DialogSuccess(
                                headertext: "Successfully Registered!",
                                subtext: "You have registered a professor!",
                                textButton: "Go back",
                                callback: () {
                                  setState(() {
                                    selectedIndex = 3;
                                  });
                                  // Will replace literally every page, that includes dialogs and others.
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminRegistration()),
                                      (Route<dynamic> route) => false);
                                },
                              ).buildSuccessScreen(context);
                            }
                          })
                        });
                  });
                });
              }),
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
