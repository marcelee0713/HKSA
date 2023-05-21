import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/verificationPages/verify_email.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_button_fork/timer_button_fork.dart';

class OTP extends StatefulWidget {
  final String verificationId;
  final int forceResendingToken;
  final String phoneNumber;
  final String userID;
  final String userType;
  final String email;
  final String password;
  const OTP(
      {super.key,
      required this.verificationId,
      required this.userID,
      required this.userType,
      required this.email,
      required this.password,
      required this.forceResendingToken,
      required this.phoneNumber});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String? _verificationCode;
  int? _resendToken;
  String? otp;

  @override
  void initState() {
    _verificationCode = widget.verificationId;
    _resendToken = widget.forceResendingToken;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/${widget.userType}/${widget.userID}/isPhoneVerified');
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
                    "Verification",
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
                      text: 'Enter the ',
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'OTP ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'that send to your phone number',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: ColorPalette.secondary),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorPalette.secondary),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: ColorPalette.accentWhite,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorPalette.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (otp?.length == 6) {
                        DialogLoading(subtext: "Verifying...")
                            .buildLoadingScreen(context);

                        await verifyOtp(
                          userOtp: otp.toString(),
                          verificationId: widget.verificationId,
                          onSuccess: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            await _userReference.set("true").then(
                              (value) {
                                // Now redirect to the email verification
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => VerifyEmail(
                                              email: widget.email,
                                              headerText:
                                                  'Well after verifying your phone, time to verify your email as well. Check your email right now.',
                                              userID: widget.userID,
                                              userType: widget.userType,
                                              password: widget.password,
                                            )),
                                    (Route<dynamic> route) => false);
                              },
                            );
                          },
                        );
                      } else {
                        DialogUnsuccessful(
                          headertext: "Missing inputs!",
                          subtext: "Enter 6-Digit code please...",
                          textButton: "Close",
                          callback: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                        ).buildUnsuccessfulScreen(context);
                      }
                    },
                    child: const Text(
                      "SUBMIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Didn't received any code?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPalette.accentWhite,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TimerButton(
                    label: "RE-SEND CODE",
                    timeOutInSeconds: 60,
                    onPressed: () async {
                      await reSendOTP(phone: widget.phoneNumber);
                    },
                    buttonType: ButtonType.ElevatedButton,
                    color: ColorPalette.secondary,
                    disabledColor: const Color.fromARGB(255, 0, 49, 33),
                    disabledTextStyle: const TextStyle(
                      color: ColorPalette.accentDarkWhite,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
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

  Future verifyOtp(
      {required String verificationId,
      required String userOtp,
      required Function onSuccess}) async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        String email = widget.email.trim();
        String password = widget.password.trim();
        await user.updateEmail(email);
        await user.updatePassword(password);
        await user.sendEmailVerification();
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      DialogUnsuccessful(
        headertext: "Error",
        subtext: "${e.message.toString()}.",
        textButton: "Close",
        callback: () => Navigator.of(context, rootNavigator: true).pop(),
      ).buildUnsuccessfulScreen(context);
    }
  }

  Future reSendOTP({required String phone}) async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          _verificationCode = verificationId;
          _resendToken = forceResendingToken;
        },
        timeout: const Duration(seconds: 55),
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (verificationId) {
          verificationId = _verificationCode!;
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUnsuccessful(
        headertext: "Error",
        subtext: e.message.toString(),
        textButton: "Close",
        callback: () => Navigator.of(context, rootNavigator: true).pop(),
      ).buildUnsuccessfulScreen(context);
    }
  }
}
