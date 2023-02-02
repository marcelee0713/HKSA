import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';

final _inputControllerOldSignature = TextEditingController();
final _inputControllerNewSignature = TextEditingController();
final _inputControllerCfrmSignature = TextEditingController();
final _formKey = GlobalKey<FormState>();

class ChangeProfessorSignature extends StatefulWidget {
  const ChangeProfessorSignature({super.key, required this.userID});
  final String userID;

  @override
  State<ChangeProfessorSignature> createState() =>
      _ChangeProfessorSignatureState();
}

class _ChangeProfessorSignatureState extends State<ChangeProfessorSignature> {
  String profSignature = "";
  bool isFetched = false;
  bool _oldSignatureVisible = false;
  bool _newSignatureVisible = false;
  bool _cfrmSignatureVisible = false;

  @override
  void initState() {
    super.initState();
    getSignature();
  }

  DatabaseReference dbReference = FirebaseDatabase.instance
      .ref()
      .child("Users/Professors/$userID/signaturecode");

  @override
  Widget build(BuildContext context) {
    String result = "";
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
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
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: ColorPalette.primary,
                              ),
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
                                  color: ColorPalette.accentWhite,
                                  fontFamily: 'Frank Ruhl Libre',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
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
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.5,
                                  color: ColorPalette.accentDarkWhite,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _inputControllerOldSignature.text = "";
                                  _inputControllerNewSignature.text = "";
                                  _inputControllerCfrmSignature.text = "";
                                  Navigator.pop(context, result);
                                  DialogLoading(subtext: "Checking")
                                      .buildLoadingScreen(context);
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
}
