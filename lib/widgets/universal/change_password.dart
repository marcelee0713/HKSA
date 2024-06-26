import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(
      {super.key, required this.userID, required this.userType});
  final String userID;
  final String userType;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _inputControllerNewPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userPassword = "";
  bool _newPasswordVisible = false;
  bool _cfrmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    String result = "";
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Change your password",
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _inputControllerNewPassword,
                          obscureText: !_newPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            final bool passwordValid = RegExp(
                                    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-.+=_]).{8,}$")
                                .hasMatch(value!);
                            if (passwordValid) {
                              result = value;
                              return null;
                            } else {
                              return "Input invalid.";
                            }
                          },
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: 0),
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
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _newPasswordVisible = !_newPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "New password...",
                          ),
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _inputControllerCfrmPassword,
                          obscureText: !_cfrmPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == result) {
                              return null;
                            } else {
                              return "Does not match!";
                            }
                          },
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: 0),
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
                            hintText: "Confirm new password...",
                          ),
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Do not share your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            color: ColorPalette.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            Navigator.pop(context, result);
                          },
                          child: const Text(
                            "CONFIRM",
                            style: TextStyle(
                              color: ColorPalette.accentWhite,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputControllerNewPassword.dispose();
    _inputControllerCfrmPassword.dispose();
    super.dispose();
  }
}
