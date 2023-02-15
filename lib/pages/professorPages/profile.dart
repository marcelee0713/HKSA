import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/professorWidgets/profile/change_signature.dart';
import 'package:hksa/widgets/universal/change_password.dart';

class ProfProfile extends StatefulWidget {
  const ProfProfile({super.key});

  @override
  State<ProfProfile> createState() => _ProfProfileState();
}

class _ProfProfileState extends State<ProfProfile> {
  final Storage storage = Storage();
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  String userProfileListener = "";

  @override
  void initState() {
    super.initState();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Professors/$userID');

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () {
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
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Professors/$userID/signaturecode");
    DatabaseReference dbReferenceForPassword = FirebaseDatabase.instance
        .ref()
        .child("Users/Professors/$userID/password");
    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorPalette.secondary,
      child: FutureBuilder(
        future: getProfessor(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
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
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning_rounded,
                    size: 200,
                    color: ColorPalette.errorColor,
                  ),
                  Text(
                    'Something went wrong!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: ColorPalette.accentBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Please try again later.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: ColorPalette.accentBlack,
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: 'assets/images/loading.gif',
                              image: snapshot.data!.first.profilePicture),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      snapshot.data!.first.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      snapshot.data!.first.phonenumber,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Professor ID:",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data!.first.professorId,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data!.first.email,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Department:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data!.first.department,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                color: ColorPalette.accentBlack,
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: InkWell(
                      onTap: (() {
                        DialogConfirm(
                            headertext: "Are you sure you want to log out?",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              // Might be more soon
                              // This includes the time in
                              Future.delayed(const Duration(), (() {
                                DialogLoading(subtext: "Logging out...")
                                    .buildLoadingScreen(context);
                              })).whenComplete(() {
                                Future.delayed(const Duration(seconds: 3), () {
                                  logInBox.put("isLoggedIn", false);
                                  logInBox.put("hasTimedIn", false);
                                  logInBox.put("userType", "");
                                  logInBox.put("userID", "");
                                  logInBox.put("userName", "");
                                  logInBox.put("getTimeInLS", "");
                                  logInBox.put("dateTimedIn", "");

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                      (Route<dynamic> route) => false);
                                });
                              });
                            }).buildConfirmScreen(context);
                      }),
                      child: const Text(
                        "Log out",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalette.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                        allowCompression: true,
                      );

                      if (results == null) {
                        return;
                      }
                      // ignore: use_build_context_synchronously
                      DialogLoading(subtext: "Changing...")
                          .buildLoadingScreen(context);

                      final path = results.files.single.path!;
                      final fileName = results.files.single.name;

                      debugPrint(path);
                      debugPrint(fileName);

                      await storage.changeProfPfp(path, fileName, userID,
                          snapshot.data!.first.profilePicture, () {
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            userProfileListener =
                                snapshot.data!.first.profilePicture;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          DialogSuccess(
                              headertext: "Profile Picture Changed!",
                              subtext:
                                  "Didn't showed? Restart or go to a different page and comeback!",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }).buildSuccessScreen(context);
                        });
                      });
                    },
                    child: const Text(
                      "Change Profile Picture",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeProfessorSignature(userID: userID),
                          ));

                      if (result == null) {
                        return;
                      }
                      await dbReference.set(result.toString());

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context, rootNavigator: true).pop();
                      }).whenComplete(() {
                        DialogSuccess(
                            headertext: "Successfully changed!",
                            subtext:
                                "You successfully changed your signature! Remember not to show this to anyone.",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            }).buildSuccessScreen(context);
                      });
                    },
                    child: const Text(
                      // TO-DO, Look at the figma, do the change signature code
                      "Change Signature Code",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(
                              userID: userID, userType: "Professors"),
                        ),
                      );
                      if (result == null) {
                        return;
                      }
                      await dbReferenceForPassword.set(result.toString());

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context, rootNavigator: true).pop();
                      }).whenComplete(() {
                        DialogSuccess(
                            headertext: "Successfully changed!",
                            subtext:
                                "You successfully changed your password! Remember not to show this to anyone.",
                            textButton: "Close",
                            callback: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            }).buildSuccessScreen(context);
                      });
                    },
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Professor>> getProfessor() async {
    List<Professor> myUser = [];
    final DatabaseReference _userReference =
        FirebaseDatabase.instance.ref().child('Users/Professors/$userID');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Professor myProfessor = Professor.fromJson(myObj);
        userProfileListener = myProfessor.profilePicture;
        myUser.add(myProfessor);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
