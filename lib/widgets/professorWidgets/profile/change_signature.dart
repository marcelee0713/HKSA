import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

class ChangeProfessorSignature extends StatefulWidget {
  const ChangeProfessorSignature({super.key, required this.userID});
  final String userID;

  @override
  State<ChangeProfessorSignature> createState() =>
      _ChangeProfessorSignatureState();
}

class _ChangeProfessorSignatureState extends State<ChangeProfessorSignature> {
  final _inputControllerOldSignature = TextEditingController();
  final _inputControllerNewSignature = TextEditingController();
  final _inputControllerCfrmSignature = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String profSignature = "";
  bool isFetched = false;
  bool _oldSignatureVisible = false;
  bool _newSignatureVisible = false;
  bool _cfrmSignatureVisible = false;

  @override
  void initState() {
    super.initState();
    getSignature();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Professors/$userID');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () async {
            logInBox.put("isLoggedIn", false);
            logInBox.put("hasTimedIn", false);
            logInBox.put("userType", "");
            logInBox.put("userID", "");
            logInBox.put("userName", "");
            logInBox.put("getTimeInLS", "");
            logInBox.put("dateTimedIn", "");

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false);

            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: ColorPalette.accentDarkWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: ColorPalette.accentDarkWhite,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 375,
                        width: 275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: ColorPalette.errorColor,
                              size: 200,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Account removed",
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "If you think this is wrong, proceed to CSDL!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: (() {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: ColorPalette.primary,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color: ColorPalette.accentWhite,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            await firebaseAuth.signOut();
            await _firebaseMessaging.unsubscribeFromTopic('user_all');
            await _firebaseMessaging.unsubscribeFromTopic('professors');
          });
        });
      }
    });
  }

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
                child: !isFetched
                    ? Center(
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
                      )
                    : Column(
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
                                "Change your signature",
                                style: TextStyle(
                                  color: ColorPalette.primary,
                                  fontFamily: 'Frank Ruhl Libre',
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
                                controller: _inputControllerOldSignature,
                                obscureText: !_oldSignatureVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == profSignature &&
                                      value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Old signature does not match.";
                                  }
                                },
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(height: 0),
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
                                        _oldSignatureVisible =
                                            !_oldSignatureVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _oldSignatureVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  hintText: "Old signature...",
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
                                controller: _inputControllerNewSignature,
                                obscureText: !_newSignatureVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    result = value;
                                    return null;
                                  } else {
                                    return "Please enter an input.";
                                  }
                                },
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(height: 0),
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
                                        _newSignatureVisible =
                                            !_newSignatureVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _newSignatureVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  hintText: "New signature...",
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
                                controller: _inputControllerCfrmSignature,
                                obscureText: !_cfrmSignatureVisible,
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
                                        _cfrmSignatureVisible =
                                            !_cfrmSignatureVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _cfrmSignatureVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  hintText: "Confirm new signature...",
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
                                "Do not share your signature.",
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
                                  await createHistory(
                                          desc:
                                              "User changed password from ${_inputControllerOldSignature.text} to ${_inputControllerCfrmSignature.text}",
                                          timeStamp: DateTime.now()
                                              .microsecondsSinceEpoch
                                              .toString(),
                                          userType: "professor",
                                          id: widget.userID)
                                      .then((value) {
                                    _inputControllerOldSignature.text = "";
                                    _inputControllerNewSignature.text = "";
                                    _inputControllerCfrmSignature.text = "";
                                    Navigator.pop(context, result);
                                    DialogLoading(subtext: "Changing...")
                                        .buildLoadingScreen(context);
                                  }).catchError(
                                    // ignore: invalid_return_type_for_catch_error
                                    (error) => {
                                      DialogUnsuccessful(
                                        headertext: "Error",
                                        subtext:
                                            "Whoops seems like there's an error. Please try again!",
                                        textButton: "Close",
                                        callback: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                      ).buildUnsuccessfulScreen(context),
                                    },
                                  );
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

  Future getSignature() async {
    final logInBox = Hive.box("myLoginBox");
    var userID = logInBox.get("userID");
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Professors/$userID/signaturecode");
    final snapshot = await dbReference.get();
    if (snapshot.exists) {
      setState(() {
        profSignature = snapshot.value.toString();
        isFetched = true;
      });
    } else {
      setState(() {
        isFetched = false;
      });
    }
  }

  Future createHistory(
      {required String desc,
      required String timeStamp,
      required String userType,
      required String id}) async {
    try {
      DatabaseReference dbReference =
          FirebaseDatabase.instance.ref().child('historylogs/$id');
      String? key = dbReference.push().key;

      final json = {
        'desc': desc,
        'timeStamp': timeStamp,
        'userType': userType,
        'id': id,
      };

      await dbReference.child(key!).set(json);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _inputControllerOldSignature.dispose();
    _inputControllerNewSignature.dispose();
    _inputControllerCfrmSignature.dispose();
    super.dispose();
  }
}
