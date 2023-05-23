import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_edit_professor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:hksa/widgets/universal/view_history_logs.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';

class ProfessorProfile extends StatefulWidget {
  final String userID;
  const ProfessorProfile({
    super.key,
    required this.userID,
  });

  @override
  State<ProfessorProfile> createState() => _ProfessorProfileState();
}

class _ProfessorProfileState extends State<ProfessorProfile> {
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  late var userID = logInBox.get("userID");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      color: ColorPalette.secondary,
                      size: 100,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status:',
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
                          height: 10,
                        ),
                        userType == "head"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Inbox(
                                                  receiverFullName:
                                                      snapshot.data!.first.name,
                                                  receiverID: snapshot
                                                      .data!.first.professorId,
                                                  receiverType: "professor",
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.primary,
                                          ),
                                          child: const Text(
                                            "Message",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfessor(
                                                  userID: snapshot
                                                      .data!.first.professorId,
                                                  currentRoom:
                                                      snapshot.data!.first.room,
                                                  currentSection: snapshot
                                                      .data!.first.section,
                                                  currentSubject: snapshot
                                                      .data!.first.subject,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.primary,
                                          ),
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryLogs(
                                                  userID: widget.userID,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.primary,
                                          ),
                                          child: const Text(
                                            "View History Logs",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            DialogConfirm(
                                              headertext:
                                                  "Are you sure you want the reset history logs of this user?",
                                              callback: () async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();

                                                DialogLoading(
                                                        subtext: "Resetting...")
                                                    .buildLoadingScreen(
                                                        context);

                                                final DatabaseReference
                                                    historyLogsReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child(
                                                            'historylogs/${widget.userID}');

                                                await historyLogsReference
                                                    .remove()
                                                    .then(
                                                  (value) async {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();

                                                    DialogSuccess(
                                                      headertext: "Success",
                                                      subtext:
                                                          "You have successfully reset the History Logs of this user! ",
                                                      textButton: "Close",
                                                      callback: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ).buildSuccessScreen(
                                                        context);

                                                    await createHistory(
                                                      desc:
                                                          "Reset the History Logs of the Professor: ${snapshot.data!.first.name}(${snapshot.data!.first.professorId})",
                                                      timeStamp: DateTime.now()
                                                          .microsecondsSinceEpoch
                                                          .toString(),
                                                      userType: userType,
                                                      id: userID,
                                                    );
                                                  },
                                                ).catchError((err) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();

                                                  DialogUnsuccessful(
                                                    headertext: "Error",
                                                    subtext:
                                                        "Please try again later!",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ).buildUnsuccessfulScreen(
                                                      context);
                                                });
                                              },
                                            ).buildConfirmScreen(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.errorColor,
                                          ),
                                          child: const Text(
                                            "Reset History Logs",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            DialogConfirm(
                                              headertext:
                                                  "User status will be active now, you sure?",
                                              callback: () async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogLoading(
                                                        subtext: "Loading...")
                                                    .buildLoadingScreen(
                                                        context);
                                                final DatabaseReference
                                                    statusReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child(
                                                            'Users/Professors/${widget.userID}/status');

                                                await statusReference
                                                    .set("active")
                                                    .then((value) async {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  DialogSuccess(
                                                    headertext: "Success",
                                                    subtext:
                                                        "They can now log in and make changes in the app",
                                                    textButton: "Close",
                                                    callback: () =>
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(),
                                                  ).buildSuccessScreen(context);
                                                  await createHistory(
                                                    desc:
                                                        "Made a Professor Active: ${snapshot.data!.first.name}(${snapshot.data!.first.professorId})",
                                                    timeStamp: DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString(),
                                                    userType: userType,
                                                    id: userID,
                                                  );
                                                }).catchError((e) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  DialogUnsuccessful(
                                                    headertext: "Error",
                                                    subtext:
                                                        "Please try again later!",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ).buildUnsuccessfulScreen(
                                                      context);
                                                });
                                              },
                                            ).buildConfirmScreen(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.errorColor,
                                          ),
                                          child: const Text(
                                            "Reactivate",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            DialogConfirm(
                                              headertext:
                                                  "User will log out and can't log in. You sure?",
                                              callback: () async {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogLoading(
                                                        subtext: "Loading...")
                                                    .buildLoadingScreen(
                                                        context);
                                                final DatabaseReference
                                                    statusReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child(
                                                            'Users/Professors/${widget.userID}/status');

                                                await statusReference
                                                    .set("inactive")
                                                    .then((value) async {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  DialogSuccess(
                                                    headertext: "Success",
                                                    subtext:
                                                        "Again, it will log them out. If you wanna know when they logged out, go to its history logs.",
                                                    textButton: "Close",
                                                    callback: () =>
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(),
                                                  ).buildSuccessScreen(context);
                                                  await createHistory(
                                                    desc:
                                                        "Made a Professor Inactive: ${snapshot.data!.first.name}(${snapshot.data!.first.professorId})",
                                                    timeStamp: DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString(),
                                                    userType: userType,
                                                    id: userID,
                                                  );
                                                }).catchError((e) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  DialogUnsuccessful(
                                                    headertext: "Error",
                                                    subtext:
                                                        "Please try again later!",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ).buildUnsuccessfulScreen(
                                                      context);
                                                });
                                              },
                                            ).buildConfirmScreen(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.errorColor,
                                          ),
                                          child: const Text(
                                            "Deactivate",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.accentWhite),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Inbox(
                                                receiverFullName:
                                                    snapshot.data!.first.name,
                                                receiverID: snapshot
                                                    .data!.first.professorId,
                                                receiverType: "professor",
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.primary,
                                ),
                                child: const Text(
                                  "Message",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: ColorPalette.accentWhite),
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
      ),
    );
  }

  Future<List<Professor>> getProfessor() async {
    List<Professor> myUser = [];
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/Professors/${widget.userID}');
    try {
      await _userReference.get().then((snapshot) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Professor myProfessor = Professor.fromJson(myObj);

        myUser.add(myProfessor);
      });
      return myUser;
    } catch (error) {
      rethrow;
    }
  }
}
