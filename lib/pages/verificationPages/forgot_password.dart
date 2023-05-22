import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _inputControllerUserID = TextEditingController();
  final _inputControllerEmail = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String userTypeValue = "Scholar";

  @override
  void dispose() {
    _inputControllerEmail.dispose();
    _inputControllerUserID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: userTypeValue,
                          items: HKSAStrings.items.map(buildMenuItem).toList(),
                          onChanged: ((value) => setState(() {
                                userTypeValue = value!;
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                        hintText: "User ID",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        hintText: "Email",
                      ),
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorPalette.secondary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          String email = _inputControllerEmail.text.trim();
                          String userID = _inputControllerUserID.text.trim();
                          String userType = userTypeValue.toString();

                          DialogConfirm(
                            headertext:
                                "In order to reset your password, we will send a link to your email.",
                            callback: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogLoading(subtext: "Loading...")
                                  .buildLoadingScreen(context);

                              await checkIfExist(id: userID, userType: userType)
                                  .then((value) async {
                                try {
                                  await firebaseAuth
                                      .sendPasswordResetEmail(
                                    email: email,
                                  )
                                      .then(
                                    (value) async {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      DialogSuccess(
                                        headertext: "Success",
                                        subtext:
                                            "We have sent you a link through your email!",
                                        textButton: "Close",
                                        callback: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                      ).buildSuccessScreen(context);
                                      await createHistory(
                                        desc:
                                            "Requested a Forgot Password Link.",
                                        timeStamp: DateTime.now()
                                            .microsecondsSinceEpoch
                                            .toString(),
                                        userType: userType,
                                        id: userID,
                                      );
                                      _inputControllerEmail.text = "";
                                      _inputControllerUserID.text = "";
                                    },
                                  );
                                } on FirebaseAuthException catch (e) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  DialogUnsuccessful(
                                    headertext: "Error",
                                    subtext: e.message.toString(),
                                    textButton: "Close",
                                    callback: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop(),
                                  ).buildUnsuccessfulScreen(context);
                                }
                              }).catchError((e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Error",
                                  subtext: e,
                                  textButton: "Close",
                                  callback: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                ).buildUnsuccessfulScreen(context);
                              });
                            },
                          ).buildConfirmScreen(context);
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Future checkIfExist({required String id, required String userType}) async {
    final newUserType = userType == "Head" ? "Head" : "${userType}s";
    DatabaseReference existence =
        FirebaseDatabase.instance.ref().child("Users/$newUserType/$id");

    try {
      await existence.get().then((value) {
        if (!value.exists) {
          throw "Doesn't exist";
        }
      });
    } catch (e) {
      throw e.toString();
    }
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
