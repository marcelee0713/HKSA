import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/verificationPages/verify_phone.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class CheckPhoneNumber extends StatefulWidget {
  final String userID;
  final String userType;
  final String email;
  final String password;
  const CheckPhoneNumber(
      {super.key,
      required this.userID,
      required this.userType,
      required this.email,
      required this.password});

  @override
  State<CheckPhoneNumber> createState() => _CheckPhoneNumberState();
}

class _CheckPhoneNumberState extends State<CheckPhoneNumber> {
  final _inputControllerPhoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const SizedBox(height: 10),
                  const Text(
                    "First time logging in?",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: const TextSpan(
                      text: 'Well we have to ',
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'verify ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'your ',
                        ),
                        TextSpan(
                          text: 'phone number ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'and ',
                        ),
                        TextSpan(
                          text: 'email ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'before we log you in. ',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "You can also change your phone number.",
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: ColorPalette.secondary),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Please wait while we get your data...',
                              style: TextStyle(
                                color: ColorPalette.accentWhite,
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.warning_rounded,
                              color: ColorPalette.errorColor,
                              size: 150,
                            ),
                            Text(
                              'Error please try again later!',
                              style: TextStyle(
                                color: ColorPalette.accentWhite,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        );
                      }

                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Current Phone Number: ${snapshot.data}',
                              style: const TextStyle(
                                color: ColorPalette.accentWhite,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _inputControllerPhoneNumber,
                              maxLength: 11,
                              validator: (value) {
                                final bool phoneValid =
                                    RegExp(r"^(09|\+639)\d{9}$")
                                        .hasMatch(value!);
                                if (phoneValid) {
                                  return null;
                                } else if (value.length <= 11 && !phoneValid) {
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
                                errorStyle: const TextStyle(
                                    color: ColorPalette.errorColor),
                                hintText: "09...",
                              ),
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ColorPalette.errorColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      String phoneNumber =
                                          _inputControllerPhoneNumber.text
                                              .trim();

                                      DialogConfirm(
                                        headertext:
                                            "Are you sure you want to change your phone number to $phoneNumber?",
                                        callback: () async {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogLoading(subtext: "Changing...")
                                              .buildLoadingScreen(context);
                                          await changePhoneNumber(
                                                  phoneNumber: phoneNumber)
                                              .then((value) {
                                            setState(() {
                                              _inputControllerPhoneNumber.text =
                                                  "";
                                            });
                                          });
                                        },
                                      ).buildConfirmScreen(context);
                                    },
                                    child: const Text(
                                      "CHANGE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorPalette.accentWhite,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ColorPalette.secondary),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      String phoneNum = snapshot.data!;
                                      int phoneNumLength = phoneNum.length;
                                      String formatPhone =
                                          phoneNum.substring(1, phoneNumLength);
                                      String phoneNumber = "+63$formatPhone";

                                      DialogConfirm(
                                        headertext: "Verify $phoneNumber?",
                                        callback: () async {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          DialogLoading(
                                                  subtext: "Please wait...")
                                              .buildLoadingScreen(context);

                                          await verifyPhone(
                                            phoneNumber: phoneNumber,
                                          );
                                        },
                                      ).buildConfirmScreen(context);
                                    },
                                    child: const Text(
                                      "VERIFY",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorPalette.accentWhite,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getUser() async {
    String? myUserPhoneNumber = "";
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/${widget.userType}/${widget.userID}/phonenumber');
    try {
      await _userReference.get().then((snapshot) {
        myUserPhoneNumber = snapshot.value.toString();
      });
      return myUserPhoneNumber;
    } catch (error) {
      rethrow;
    }
  }

  Future verifyPhone({required String phoneNumber}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTP(
                  verificationId: verificationId,
                  forceResendingToken: forceResendingToken!,
                  phoneNumber: phoneNumber,
                  userID: widget.userID,
                  userType: widget.userType,
                  email: widget.email,
                  password: widget.password,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      DialogUnsuccessful(
        headertext: "Error",
        subtext: "Here is the error message ${e.message.toString()}",
        textButton: "Close",
        callback: () => Navigator.of(context, rootNavigator: true).pop(),
      );
    }
  }

  Future changePhoneNumber({required String phoneNumber}) async {
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/${widget.userType}/${widget.userID}/phonenumber');
    await _userReference.set(phoneNumber).then(
      (value) {
        Navigator.of(context, rootNavigator: true).pop();
        DialogSuccess(
          headertext: "Success",
          subtext: "Successfully changed your phone number to $phoneNumber",
          textButton: "Close",
          callback: () => Navigator.of(context, rootNavigator: true).pop(),
        ).buildSuccessScreen(context);
      },
    ).catchError(
      (err) {
        Navigator.of(context, rootNavigator: true).pop();
        DialogUnsuccessful(
          headertext: "Error",
          subtext: "Please try again later!",
          textButton: "Close",
          callback: () => Navigator.of(context, rootNavigator: true).pop(),
        );
        return err;
      },
    );
  }
}
