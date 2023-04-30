import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/dialogs/dialog_upload_dtr.dart';
import 'package:hksa/widgets/universal/change_password.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Storage storage = Storage();
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  String userProfileListener = "";
  String oldDTRURl = "";

  @override
  void initState() {
    super.initState();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference oldDTRRef =
        FirebaseDatabase.instance.ref().child('olddtrlink');
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    DatabaseReference userRefStatus =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID/status');
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    oldDTRRef.get().then((link) => {
          if (link.exists) {oldDTRURl = link.value.toString()}
        });

    userRef.get().then((user) {
      if (!user.exists) {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(const Duration(seconds: 3), () {
            _firebaseMessaging.unsubscribeFromTopic('user_all');
            _firebaseMessaging.unsubscribeFromTopic('scholars');
            _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
            _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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

    userRefStatus.get().then((snapshot) {
      if (snapshot.value.toString() == "inactive") {
        Future.delayed(const Duration(), (() {
          DialogLoading(subtext: "Logging out...").buildLoadingScreen(context);
        })).whenComplete(() {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              _firebaseMessaging.unsubscribeFromTopic('user_all');
              _firebaseMessaging.unsubscribeFromTopic('scholars');
              _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
              _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: ColorPalette.accentDarkWhite,
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
                                "Account Inactive",
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
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Scholars/$userID/password");

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      color: ColorPalette.accentWhite,
      child: FutureBuilder(
        future: getScholar(),
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
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
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
                                  image: userProfileListener),
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
                            "Student Number:",
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
                            snapshot.data!.first.studentNumber,
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
                            'Course/Section:',
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
                            snapshot.data!.first.course,
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
                            'Scholar Type:',
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
                            snapshot.data!.first.scholarType,
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
                            'HK Type:',
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
                            snapshot.data!.first.hkType,
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
                            'HK Status:',
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
                            snapshot.data!.first.status.replaceAll(
                                snapshot.data!.first.status.substring(0, 1),
                                snapshot.data!.first.status
                                    .substring(0, 1)
                                    .toUpperCase()),
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
                            'Town:',
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
                            snapshot.data!.first.town,
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
                                        () {
                                      logInBox.put("isLoggedIn", false);
                                      logInBox.put("hasTimedIn", false);
                                      logInBox.put("userType", "");
                                      logInBox.put("userID", "");
                                      logInBox.put("userName", "");
                                      logInBox.put("getTimeInLS", "");
                                      logInBox.put("dateTimedIn", "");
                                      _firebaseMessaging
                                          .unsubscribeFromTopic('user_all');
                                      _firebaseMessaging
                                          .unsubscribeFromTopic('scholars');
                                      _firebaseMessaging.unsubscribeFromTopic(
                                          'scholars_faci');
                                      _firebaseMessaging.unsubscribeFromTopic(
                                          'scholars_non_faci');
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
                    ],
                  ),
                  /* Have to do it, because they suggested it.
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

                      await storage.changeScholarPfp(path, fileName, userID,
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
                                    */
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      if (oldDTRURl == "") {
                        Flushbar(
                          backgroundColor: ColorPalette.secondary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          messageText: const Text(
                            "Please wait, while it is fetching the link...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: ColorPalette.primary,
                            ),
                          ),
                          duration: const Duration(seconds: 3),
                        ).show(context);
                        return;
                      }

                      DialogUploadDTR(() async {
                        Navigator.of(context, rootNavigator: true).pop();
                        String res = await uploadURL();
                        if (res == "error") {
                          // ignore: use_build_context_synchronously
                          DialogUnsuccessful(
                            headertext: "Error",
                            subtext:
                                "Seems like the link for google drive doesn't exist",
                            textButton: "Close",
                            callback: () => {
                              Navigator.of(context, rootNavigator: true).pop()
                            },
                          ).buildUnsuccessfulScreen(context);
                        }
                      }).buildUploadDTr(context);
                    },
                    child: const Text(
                      "Upload OLD DTR",
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
                              userID: userID, userType: "Scholars"),
                        ),
                      );
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

  Future<String> uploadURL() async {
    String res = "error";
    try {
      if (await canLaunchUrl(Uri.parse(oldDTRURl))) {
        launchUrl(
          Uri.parse(oldDTRURl),
          mode: LaunchMode.externalApplication,
        );
        res = "success";
      } else {
        res = "error";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final DatabaseReference _userReference =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Scholar myScholar = Scholar.fromJson(myObj);
        userProfileListener = myScholar.profilePicture;
        myUser.add(myScholar);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
