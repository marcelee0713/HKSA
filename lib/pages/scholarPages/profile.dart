import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';

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
  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Scholars/$userID/profilePicture");

    dbReference.onValue.listen((event) {
      if (mounted) {
        setState(() {
          userProfileListener = event.snapshot.value.toString();
        });
      }
    });
    return Container(
      padding: const EdgeInsets.all(20),
      color: ColorPalette.secondary,
      child: FutureBuilder(
        future: getScholar(),
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
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                color: ColorPalette.accentBlack,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    child: InkWell(
                      onTap: (() {
                        setState(
                          () {
                            // Might be more soon
                            // This includes the time in
                            DialogLoading(subtext: "Logging out..")
                                .buildLoadingScreen(context);

                            Future.delayed(const Duration(seconds: 2), (() {
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
                            }));
                          },
                        );
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
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );

                      if (results == null) {
                        // ignore: use_build_context_synchronously
                        Flushbar(
                          backgroundColor: ColorPalette.primary,
                          messageText: const Text(
                            "Enter an image!",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: ColorPalette.accentWhite,
                            ),
                          ),
                          duration: const Duration(seconds: 3),
                        ).show(context);
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final DatabaseReference _userReference =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Scholar myScholar = Scholar.fromJson(myObj);

        myUser.add(myScholar);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
