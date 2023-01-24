import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:hksa/constant/string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

final _inputControllerSignature = TextEditingController();
final _formKey = GlobalKey<FormState>();

class DialogSign extends StatefulWidget {
  const DialogSign({super.key});

  @override
  State<DialogSign> createState() => _DialogSignState();
}

class _DialogSignState extends State<DialogSign> {
  String? multiplierValue;
  bool _signatureVisible = false;
  @override
  Widget build(BuildContext context) {
    int result = 0;
    DatabaseReference _testReference =
        FirebaseDatabase.instance.ref().child("Users/Professors/");
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
      body: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: ColorPalette.secondary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Authorize the scholar to time out?",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _inputControllerSignature,
                          obscureText: !_signatureVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.visiblePassword,
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
                                  _signatureVisible = !_signatureVisible;
                                });
                              },
                              icon: Icon(
                                _signatureVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "Signature",
                          ),
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorPalette.accentDarkWhite,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text(
                                "*",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              value: multiplierValue,
                              isExpanded: true,
                              iconSize: 16,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorPalette.primary,
                              ),
                              items: HKSAStrings.multipliers
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: ((multiplierValue) => setState(() {
                                    this.multiplierValue =
                                        multiplierValue ?? "";
                                  })),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: (() => setState(
                            () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              if (multiplierValue == null) {
                                Flushbar(
                                  backgroundColor: ColorPalette.primary,
                                  messageText: const Text(
                                    "Enter a multiplier please.",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: ColorPalette.accentWhite,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                                return;
                              }

                              String signatureInput =
                                  _inputControllerSignature.text.trim();
                              bool userExist = false;
                              bool doneCheckingUsers = false;

                              DialogLoading(subtext: "Checking")
                                  .buildLoadingScreen(context);

                              Future.delayed(const Duration(seconds: 2), () {
                                _testReference.get().then((snapshot) {
                                  for (final test in snapshot.children) {
                                    Map<String, dynamic> myObj =
                                        jsonDecode(jsonEncode(test.value));

                                    Professor myProfessorObj =
                                        Professor.fromJson(myObj);

                                    if (myProfessorObj.signaturecode ==
                                        signatureInput) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      userExist = true;
                                      doneCheckingUsers = false;
                                      result = int.parse(multiplierValue!);
                                      Navigator.pop(context, result);
                                      break;
                                    } else {
                                      userExist = false;
                                      continue;
                                    }
                                  }
                                  doneCheckingUsers = true;
                                });
                              });

                              Future.delayed(const Duration(milliseconds: 2500),
                                  () {
                                if (!userExist && doneCheckingUsers) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  debugPrint(signatureInput);
                                  DialogUnsuccessful(
                                      headertext: "Unavailable Signature",
                                      subtext:
                                          "We currently don't have the signature you input",
                                      textButton: "Close",
                                      callback: () => {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop()
                                          }).buildUnsuccessfulScreen(context);
                                }
                              });

                              _inputControllerSignature.text = "";

                              // Find if any professors have this kind of signature.
                              /*
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                      */
                            },
                          )),
                      child: const Text(
                        "CONFIRM",
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );
}
