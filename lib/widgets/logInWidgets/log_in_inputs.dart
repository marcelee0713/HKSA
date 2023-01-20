import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/pages/register_scholar.dart';
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
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
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
    DatabaseReference _testReference = FirebaseDatabase.instance.ref();

    // This is a "real time" getting the data example;
    _testReference.onValue.listen(
      (event) {
        setState(() {
          realTimeValue = event.snapshot.value.toString();
        });
      },
    );
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
                      fontSize: 24,
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
                      // This is where it finds the user in the firebase database
                      // And if it did find it will log in depends on the user type
                      // if not. It will pop up a modal that it will show
                      // NO USER FOUND
                      debugPrint(value!.toLowerCase());
                      debugPrint(_inputControllerUserID.text);
                      debugPrint(_inputControllerPassword.text);
                      debugPrint(realTimeValue);
                      debugPrint(getOnceValue);
                      _testReference
                          .child("ID")
                          .set(_inputControllerUserID.text);
                    });
                  }),
                  child: const Text(
                    "Log in",
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
