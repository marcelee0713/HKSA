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
  final _inputControllerOldPassword = TextEditingController();
  final _inputControllerNewPassword = TextEditingController();
  final _inputControllerCfrmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userPassword = "";
  bool isFetched = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _cfrmPasswordVisible = false;

  @override
  void initState() {
    getPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/${widget.userType}/${widget.userID}/password");
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
                              size: 100,
                              color: ColorPalette.secondary,
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
                                "Change your password",
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
                                controller: _inputControllerOldPassword,
                                obscureText: !_oldPasswordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == userPassword &&
                                      value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Old password does not match.";
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
                                        _oldPasswordVisible =
                                            !_oldPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _oldPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  hintText: "Old password...",
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
                                        _newPasswordVisible =
                                            !_newPasswordVisible;
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
                                        _cfrmPasswordVisible =
                                            !_cfrmPasswordVisible;
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

                                  await createHistory(
                                          desc:
                                              "User changed password from ${_inputControllerOldPassword.text} to ${_inputControllerCfrmPassword.text}",
                                          timeStamp: DateTime.now()
                                              .microsecondsSinceEpoch
                                              .toString(),
                                          userType: widget.userType,
                                          id: widget.userID)
                                      .then((value) {
                                    _inputControllerOldPassword.text = "";
                                    _inputControllerNewPassword.text = "";
                                    _inputControllerCfrmPassword.text = "";
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
                                      ),
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

  Future getPassword() async {
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/${widget.userType}/${widget.userID}/password");
    final snapshot = await dbReference.get();
    if (snapshot.exists) {
      setState(() {
        userPassword = snapshot.value.toString();
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
    _inputControllerOldPassword.dispose();
    _inputControllerNewPassword.dispose();
    _inputControllerCfrmPassword.dispose();
    super.dispose();
  }
}
