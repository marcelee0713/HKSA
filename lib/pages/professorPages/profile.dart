import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/professorWidgets/profile/change_signature.dart';
import 'package:hksa/widgets/universal/change_password.dart';
import 'package:image_picker/image_picker.dart';

class ProfProfile extends StatefulWidget {
  const ProfProfile({super.key});

  @override
  State<ProfProfile> createState() => _ProfProfileState();
}

class _ProfProfileState extends State<ProfProfile> {
  final Storage storage = Storage();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  String userProfileListener = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Professors/$userID/signaturecode");
    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorPalette.accentWhite,
      child: FutureBuilder(
        future: getProfessor(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
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
          String emailVerified = snapshot.data!.first.isEmailVerified == "true"
              ? "Email is verified"
              : "Email is not verified";
          String phoneVerified = snapshot.data!.first.isPhoneVerified == "true"
              ? "Phone number is verified"
              : "Phone number is not verified";
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: "Professor",
                                  preferBelow: false,
                                  waitDuration:
                                      const Duration(milliseconds: 500),
                                  height: 20,
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    color: ColorPalette.accentWhite,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorPalette.primary.withOpacity(0.85),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: const Icon(
                                      Icons.supervisor_account_outlined),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    snapshot.data!.first.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: phoneVerified,
                                  preferBelow: false,
                                  waitDuration:
                                      const Duration(milliseconds: 500),
                                  height: 20,
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    color: ColorPalette.accentWhite,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorPalette.primary.withOpacity(0.85),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: const Icon(Icons.phone),
                                ),
                                const SizedBox(width: 5),
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
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: emailVerified,
                                  preferBelow: false,
                                  waitDuration:
                                      const Duration(milliseconds: 500),
                                  height: 20,
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    color: ColorPalette.accentWhite,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorPalette.primary.withOpacity(0.85),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: const Icon(Icons.email_rounded),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    snapshot.data!.first.email,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
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
                  const SizedBox(height: 20),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Day:',
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
                            snapshot.data!.first.day,
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
                            'Time:',
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
                            snapshot.data!.first.time,
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
                            'Room:',
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
                            snapshot.data!.first.room,
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
                            'Section:',
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
                            snapshot.data!.first.section,
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
                            'Subject:',
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
                            snapshot.data!.first.subject,
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  // Might be more soon
                                  // This includes the time in
                                  Future.delayed(const Duration(), (() {
                                    DialogLoading(subtext: "Logging out...")
                                        .buildLoadingScreen(context);
                                  })).whenComplete(() {
                                    Future.delayed(const Duration(seconds: 3),
                                        () async {
                                      professorSubscription!.cancel();
                                      logInBox.put("isLoggedIn", false);
                                      logInBox.put("hasTimedIn", false);
                                      logInBox.put("userName", "");
                                      logInBox.put("getTimeInLS", "");
                                      logInBox.put("dateTimedIn", "");
                                      await _firebaseMessaging
                                          .unsubscribeFromTopic('user_all');
                                      await _firebaseMessaging
                                          .unsubscribeFromTopic('professors');
                                      await createHistory(
                                        desc: "User logged out",
                                        timeStamp: DateTime.now()
                                            .microsecondsSinceEpoch
                                            .toString(),
                                        userType: userType,
                                        id: userID,
                                      );
                                      await FirebaseAuth.instance.signOut();
                                      logInBox.put("userType", "");
                                      logInBox.put("userID", "");
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
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
                          PickedFile? results =
                              await ImagePicker.platform.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                            maxHeight: 800,
                            maxWidth: 800,
                          );

                          if (results == null) {
                            return;
                          }

                          // ignore: use_build_context_synchronously
                          DialogLoading(subtext: "Changing...")
                              .buildLoadingScreen(context);
                          final path = results.path;
                          final fileName = results.path.split('/').last;

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
                          }).then((value) async {
                            await createHistory(
                              desc: "User changed profile picture",
                              timeStamp: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              userType: userType,
                              id: userID,
                            );
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
                          // ignore: use_build_context_synchronously
                          DialogLoading(subtext: "Changing...")
                              .buildLoadingScreen(context);
                          await dbReference
                              .set(result.toString())
                              .then((value) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogSuccess(
                              headertext: "Successfully changed!",
                              subtext:
                                  "You successfully changed your signature! Remember not to show this to anyone.",
                              textButton: "Close",
                              callback: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ).buildSuccessScreen(context);
                          }).catchError((err) {
                            Navigator.of(context, rootNavigator: true).pop();
                            DialogUnsuccessful(
                                headertext: "Error",
                                subtext: "Please try again later!",
                                textButton: "Close",
                                callback: () => Navigator.of(context,
                                        rootNavigator: true)
                                    .pop()).buildUnsuccessfulScreen(context);
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
                          await changePassword(newPassword: result).then(
                            (value) async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogSuccess(
                                headertext: "Successfully changed!",
                                subtext:
                                    "You successfully changed your password! Remember not to show this to anyone.",
                                textButton: "Close",
                                callback: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ).buildSuccessScreen(context);
                              await createHistory(
                                desc: "Changed password",
                                timeStamp: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                userType: userType,
                                id: userID,
                              );
                            },
                          ).catchError(
                            (err) {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogUnsuccessful(
                                headertext: "Error",
                                subtext: err,
                                textButton: "Close",
                                callback: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                              ).buildUnsuccessfulScreen(context);
                            },
                          );
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
              ),
            ],
          );
        },
      ),
    );
  }

  Future changePassword({required String newPassword}) async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw "Error, we recommend you to log in again.";
      }
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<List<Professor>> getProfessor() async {
    List<Professor> myUser = [];
    final DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child('Users/Professors/$userID');
    try {
      await userReference.get().then((snapshot) {
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
}
