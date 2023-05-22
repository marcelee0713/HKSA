import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/models/scholar_prof_detail.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  @override
  void initState() {
    super.initState();
    // Basically what this does is.
    // It checks if this User still exist or inactive in the database
    // And if he does. Then log out this user.
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    DatabaseReference userRefStatus =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID/status');
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
            await _firebaseMessaging.unsubscribeFromTopic('scholars');
            await _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
            await _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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
            () async {
              logInBox.put("isLoggedIn", false);
              logInBox.put("hasTimedIn", false);
              logInBox.put("userType", "");
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
              logInBox.put("userID", "");
              await firebaseAuth.signOut();
              await _firebaseMessaging.unsubscribeFromTopic('user_all');
              await _firebaseMessaging.unsubscribeFromTopic('scholars');
              await _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
              await _firebaseMessaging
                  .unsubscribeFromTopic('scholars_non_faci');
              await createHistory(
                desc: "User logged out due to its status being inactive",
                timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
                userType: "scholar",
                id: userID,
              );
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/$userID/");
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                  Text("Fetching your data..."),
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
                              image: snapshot.data!.first.profilePicture,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.first.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.studentNumber,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              snapshot.data!.first.phonenumber,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Schedule",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 1,
                        color: ColorPalette.accentBlack,
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Day 1",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text(
                            "On Site: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            snapshot.data!.first.onSiteDay1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text(
                            "Vacant Time: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            snapshot.data!.first.vacantTimeDay1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // FutureBuilder
                      snapshot.data!.first.assignedProfD1 == ""
                          ? Row(
                              children: const [
                                Text(
                                  "Prof: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "None",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : FutureBuilder(
                              future: getProfNameSectionRoom(
                                  day1ProfID:
                                      snapshot.data!.first.assignedProfD1,
                                  day2ProfID:
                                      snapshot.data!.first.assignedProfD2,
                                  wDProfID:
                                      snapshot.data!.first.assignedProfWd),
                              builder: (context, snapshotProf1) {
                                if (!snapshotProf1.hasData) {
                                  return const SpinKitThreeBounce(
                                    color: ColorPalette.secondary,
                                    size: 15,
                                  );
                                }
                                if (snapshotProf1.hasError) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                        color: ColorPalette.errorColor,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Error, try again later!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300,
                                          color: ColorPalette.errorColor,
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Prof: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              snapshotProf1
                                                  .data!.first.d1ProfName,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Section: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProf1
                                                  .data!.first.d1ProfSection,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Room: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProf1
                                                  .data!.first.d1ProfRoom,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: ColorPalette.accentBlack,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Day 2",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text(
                            "On Site: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            snapshot.data!.first.onSiteDay2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text(
                            "Vacant Time: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            snapshot.data!.first.vacantTimeDay2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // FutureBuilder
                      snapshot.data!.first.assignedProfD2 == ""
                          ? Row(
                              children: const [
                                Text(
                                  "Prof: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "None",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : FutureBuilder(
                              future: getProfNameSectionRoom(
                                  day1ProfID:
                                      snapshot.data!.first.assignedProfD1,
                                  day2ProfID:
                                      snapshot.data!.first.assignedProfD2,
                                  wDProfID:
                                      snapshot.data!.first.assignedProfWd),
                              builder: (context, snapshotProf2) {
                                if (!snapshotProf2.hasData) {
                                  return const SpinKitThreeBounce(
                                    color: ColorPalette.secondary,
                                    size: 15,
                                  );
                                }
                                if (snapshotProf2.hasError) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                        color: ColorPalette.errorColor,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Error, try again later!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300,
                                          color: ColorPalette.errorColor,
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Prof: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              snapshotProf2
                                                  .data!.first.d2ProfName,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Section: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProf2
                                                  .data!.first.d2ProfSection,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Room: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProf2
                                                  .data!.first.d2ProfRoom,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: ColorPalette.accentBlack,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Whole Day Vacant: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            snapshot.data!.first.wholeDayVacantTime,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      snapshot.data!.first.assignedProfWd == ""
                          ? Row(
                              children: const [
                                Text(
                                  "Prof: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "None",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : FutureBuilder(
                              future: getProfNameSectionRoom(
                                  day1ProfID:
                                      snapshot.data!.first.assignedProfD1,
                                  day2ProfID:
                                      snapshot.data!.first.assignedProfD2,
                                  wDProfID:
                                      snapshot.data!.first.assignedProfWd),
                              builder: (context, snapshotProfWD) {
                                if (!snapshotProfWD.hasData) {
                                  return const SpinKitThreeBounce(
                                    color: ColorPalette.secondary,
                                    size: 15,
                                  );
                                }
                                if (snapshotProfWD.hasError) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                        color: ColorPalette.errorColor,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Error, try again later!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300,
                                          color: ColorPalette.errorColor,
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Prof: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.accentWhite,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              snapshotProfWD
                                                  .data!.first.wDProfName,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Section: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.accentWhite,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProfWD
                                                  .data!.first.wDProfSection,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: ColorPalette.accentWhite,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text(
                                            "Room: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.accentWhite,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              snapshotProfWD
                                                  .data!.first.wDProfRoom,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: ColorPalette.accentWhite,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 15),
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

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final _userReference =
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

  Future<List<ScholarProfDetail>> getProfNameSectionRoom(
      {required String day1ProfID,
      required String day2ProfID,
      required String wDProfID}) async {
    List<ScholarProfDetail> assignedData = [];
    String d1ProfSection = "";
    String d2ProfSection = "";
    String wDProfSection = "";
    String d1ProfRoom = "";
    String d2ProfRoom = "";
    String wDProfRoom = "";
    String d1ProfName = "";
    String d2ProfName = "";
    String wDProfName = "";

    final assignedProfD1Ref =
        FirebaseDatabase.instance.ref().child('Users/Professors/$day1ProfID');
    final assignedProfD2Ref =
        FirebaseDatabase.instance.ref().child('Users/Professors/$day2ProfID');
    final assignedProfWDRef =
        FirebaseDatabase.instance.ref().child('Users/Professors/$wDProfID');
    try {
      if (day1ProfID != "") {
        await assignedProfD1Ref.get().then((snapshot) {
          if (snapshot.value != null) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
            Professor myProf1 = Professor.fromJson(myObj);
            d1ProfName = myProf1.name;
            d1ProfRoom = myProf1.room == "" ? "None" : myProf1.room;
            d1ProfSection = myProf1.section == "" ? "None" : myProf1.section;
            return;
          } else {
            d1ProfName = "DOES NOT EXIST";
            d1ProfRoom = "DOES NOT EXIST";
            d1ProfSection = "DOES NOT EXIST";
          }
        });
      }
      if (day2ProfID != "") {
        await assignedProfD2Ref.get().then((snapshot) {
          if (snapshot.value != null) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
            Professor myProf2 = Professor.fromJson(myObj);
            d2ProfName = myProf2.name;
            d2ProfRoom = myProf2.room == "" ? "None" : myProf2.room;
            d2ProfSection = myProf2.section == "" ? "None" : myProf2.section;
          } else {
            d2ProfName = "DOES NOT EXIST";
            d2ProfRoom = "DOES NOT EXIST";
            d2ProfSection = "DOES NOT EXIST";
          }
        });
      }
      if (wDProfID != "") {
        await assignedProfWDRef.get().then((snapshot) {
          if (snapshot.value != null) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
            Professor myWDProf = Professor.fromJson(myObj);
            wDProfName = myWDProf.name;
            wDProfRoom = myWDProf.room == "" ? "None" : myWDProf.room;
            wDProfSection = myWDProf.section == "" ? "None" : myWDProf.room;
          } else {
            wDProfName = "DOES NOT EXIST";
            wDProfRoom = "DOES NOT EXIST";
            wDProfSection = "DOES NOT EXIST";
          }
        });
      }
      ScholarProfDetail myDetails = ScholarProfDetail(
          d1ProfSection: d1ProfSection,
          d1ProfRoom: d1ProfRoom,
          d1ProfName: d1ProfName,
          d2ProfSection: d2ProfSection,
          d2ProfRoom: d2ProfRoom,
          d2ProfName: d2ProfName,
          wDProfSection: wDProfSection,
          wDProfRoom: wDProfRoom,
          wDProfName: wDProfName);

      assignedData.add(myDetails);
      return assignedData;
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
