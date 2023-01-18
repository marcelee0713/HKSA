import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/registerWidgets/register_header.dart';
import 'package:hksa/constant/string.dart';

class RegisterInputs extends StatefulWidget {
  const RegisterInputs({super.key});

  @override
  State<RegisterInputs> createState() => _RegisterInputsState();
}

class _RegisterInputsState extends State<RegisterInputs> {
  // For DropDown Default Values
  String? coursesValue = "Bachelor of Science in Information Technology";
  String? hkTypeValue = "25%";

  bool _passwordVisible = false;
  bool _cfrmPasswordVisible = false;
  final _inputControllerStudentNumberID = TextEditingController();
  final _inputControllerFullName = TextEditingController();
  final _inputControllerEmail = TextEditingController();
  final _inputControllerPhoneNumber = TextEditingController();
  final _inputControllerPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _cfrmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _inputControllerStudentNumberID,
            maxLength: 12,
            validator: (value) {
              final bool studentIdValid = RegExp(r"^[0-9]+$").hasMatch(value!);
              if (studentIdValid && value.length >= 12) {
                return null;
              } else if (value.length <= 11 && value.isNotEmpty) {
                return "Input is too short.";
              } else if (value.isEmpty) {
                return "Enter Input.";
              } else {
                return "Invalid Input. Please only put numbers.";
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
              hintText: "Student Number",
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
            controller: _inputControllerFullName,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return "Enter your full name.";
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
              hintText: "Full Name",
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
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                value: coursesValue,
                items: HKSAStrings.courses.map(buildMenuItemCourses).toList(),
                onChanged: ((coursesValue) => setState(() {
                      this.coursesValue = coursesValue;
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
                isExpanded: true,
                iconSize: 32,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorPalette.primary,
                ),
                value: hkTypeValue,
                items: HKSAStrings.hkTypes.map(buildMenuItemHKTypes).toList(),
                onChanged: ((hkTypeValue) => setState(() {
                      this.hkTypeValue = hkTypeValue;
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
                return "Enter your password.";
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
                      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-_]).{8,}$")
                  .hasMatch(value!);
              if (passwordValid) {
                return null;
              } else {
                return "Must be at least 8 characters, least one uppercase, number, and special characters";
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
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  // This is where it finds the user in the firebase database
                  // And if it did find it will log in depends on the user type
                  // if not. It will pop up a modal that it will show
                  // NO USER FOUND
                  debugPrint(_inputControllerStudentNumberID.text);
                  debugPrint(_inputControllerFullName.text);
                  debugPrint(coursesValue);
                  debugPrint(hkTypeValue);
                  debugPrint(_inputControllerEmail.text);
                  debugPrint(_inputControllerPhoneNumber.text);
                  debugPrint(_inputControllerPassword.text);
                  debugPrint(_inputControllerCfrmPassword.text);
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
}
