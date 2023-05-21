import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //
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
                    "Forgot your password?",
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
                      text: 'We have to know your ',
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'ID, user type, and email\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'Please enter the following inputs.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: ColorPalette.secondary),
                  const SizedBox(height: 10),
                  // TODO: Duplicates: Phone number and Email
                  // Prevent them creating an account.

                  // TODO: Same log in process but have to log in with
                  // Email and password, whenever the user successfully logs in.
                  // We have to always put the credentials, especially the password
                  // to the database

                  // TODO: Password reset
                  // Now we can't somehow know if the user changed its password.
                  // But we can always know, if he logs in successfully with it.
                  // We just need to like save in the history logs.

                  // TODO: HISTORY LOGS:
                  // Now we have to record every request.
                  // If he pressed CHANGE NUMBER in (check_phone), VERIFY in (check_phone),
                  // RESEND OTP in (verify_phone), SUBMIT in (verifyPhone),
                  // CHECK in (verify_email), and CHECK(VERIFY SUCCESS);

                  // TODO: Inactive and Doesn't exist in the DB
                  // Make sure to sign them out by using the
                  // await FirebaseAuth.instance.signOut()
                  // Remember the initState where you logged them out?
                  // DO IT there.. But only record the history log when
                  // the user only logs out by being inactive.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
