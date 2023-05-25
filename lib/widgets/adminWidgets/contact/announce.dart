// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/api/send_message.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:hksa/widgets/scholarWidgets/home/home_inputs.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class Announce extends StatefulWidget {
  const Announce({super.key});

  @override
  State<Announce> createState() => _AnnounceState();
}

class _AnnounceState extends State<Announce> {
  final _inputControllerHeader = TextEditingController();
  final _inputControllerBody = TextEditingController();

  // For Firebase
  final DatabaseReference _scholarReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  final DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");
  final DatabaseReference _headReference =
      FirebaseDatabase.instance.ref().child("Users/Head/");

  final logInBox = Hive.box("myLoginBox");

  String userTypeValue = "All";

  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  @override
  Widget build(BuildContext context) {
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
                color: ColorPalette.accentWhite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Announcement",
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "This is where you want to notify or announce on either a specific or all user.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: ColorPalette.primary),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Select a specific user",
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "You can select either you want to send this notification to all or a specific users!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette.accentDarkWhite,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text(
                            "Enter User Type",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          value: userTypeValue,
                          isExpanded: true,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorPalette.primary,
                          ),
                          items: HKSAStrings.announcementUserType
                              .map(buildMenuItemUserType)
                              .toList(),
                          onChanged: ((userTypeValue) => setState(() {
                                this.userTypeValue = userTypeValue ?? "";
                              })),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: ColorPalette.primary),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Send an annoucement!",
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Enter the required text input. We need a header and body in order to send a notification.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorPalette.primary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: _inputControllerHeader,
                      maxLength: 30,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Enter an input.";
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          counterText: "",
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
                          hintText: "Enter a header!",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10)),
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: _inputControllerBody,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Enter an input.";
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            counterText: "",
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
                            hintText: "Enter a body of your announcement!",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10)),
                        style: const TextStyle(
                          color: ColorPalette.primary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorPalette.primary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          // We make inbox for all the Scholars and Professors
                          // And also admin should have inboxes of all of the user
                          // That he sents
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          DialogConfirm(
                            headertext:
                                "Are you sure you want to post this announcement?",
                            callback: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              DialogLoading(subtext: "Sending...")
                                  .buildLoadingScreen(context);
                              String userValue = 'All';
                              if (userTypeValue == 'All') {
                                userValue = 'user_all';
                              } else if (userTypeValue == "Scholars") {
                                userValue = 'scholars';
                              } else if (userTypeValue == "Scholars (Faci)") {
                                userValue = 'scholars_faci';
                              } else if (userTypeValue ==
                                  "Scholars (Non-Faci)") {
                                userValue = 'scholars_non_faci';
                              } else if (userTypeValue == "Professors") {
                                userValue = 'professors';
                              } else if (userTypeValue == "Admins") {
                                userValue = 'admin';
                              }
                              await sendNotificationToTopic(
                                userValue,
                                _inputControllerHeader.text.trim(),
                                _inputControllerBody.text.trim(),
                              ).then((value) async {
                                String fullMessage =
                                    "${_inputControllerHeader.text.trim()} ${_inputControllerBody.text.trim()}";
                                if (userTypeValue == 'All') {
                                  await _scholarReference.get().then(
                                    (snapshot) async {
                                      for (final scholarsId
                                          in snapshot.children) {
                                        String scholarID =
                                            scholarsId.key.toString();
                                        String recieverUserType = "scholars";
                                        await checkInbox(
                                            recieverUserType, scholarID);
                                        await sendMessage(
                                            message: fullMessage,
                                            receiverID: scholarID,
                                            receiverUserType: recieverUserType);
                                      }
                                    },
                                  );

                                  await _headReference.get().then(
                                    (snapshot) async {
                                      for (final id in snapshot.children) {
                                        String headId = id.key.toString();
                                        String recieverUserType = "head";
                                        if (headId != userID) {
                                          await checkInbox(
                                              recieverUserType, headId);
                                          await sendMessage(
                                              message: fullMessage,
                                              receiverID: headId,
                                              receiverUserType:
                                                  recieverUserType);
                                        }
                                      }
                                    },
                                  );
                                  await _profReference.get().then(
                                    (snapshot) async {
                                      for (final professorsId
                                          in snapshot.children) {
                                        String professorID =
                                            professorsId.key.toString();
                                        String recieverUserType = "professors";
                                        await checkInbox(
                                            recieverUserType, professorID);
                                        await sendMessage(
                                            message: fullMessage,
                                            receiverID: professorID,
                                            receiverUserType: recieverUserType);
                                      }
                                    },
                                  );
                                } else if (userTypeValue == "Scholars") {
                                  await _scholarReference.get().then(
                                    (snapshot) async {
                                      for (final scholarsId
                                          in snapshot.children) {
                                        String scholarID =
                                            scholarsId.key.toString();
                                        String recieverUserType = "scholars";
                                        await checkInbox(
                                            recieverUserType, scholarID);
                                        await sendMessage(
                                            message: fullMessage,
                                            receiverID: scholarID,
                                            receiverUserType: recieverUserType);
                                      }
                                    },
                                  );
                                } else if (userTypeValue == "Scholars (Faci)") {
                                  await _scholarReference.get().then(
                                    (snapshot) async {
                                      for (final scholarsId
                                          in snapshot.children) {
                                        Map<String, dynamic> myObj = jsonDecode(
                                            jsonEncode(scholarsId.value));
                                        Scholar myScholar =
                                            Scholar.fromJson(myObj);

                                        if (myScholar.hkType == "Faci") {
                                          String scholarID =
                                              scholarsId.key.toString();
                                          String recieverUserType = "scholars";
                                          await checkInbox(
                                              recieverUserType, scholarID);
                                          await sendMessage(
                                              message: fullMessage,
                                              receiverID: scholarID,
                                              receiverUserType:
                                                  recieverUserType);
                                        }
                                      }
                                    },
                                  );
                                } else if (userTypeValue ==
                                    "Scholars (Non-Faci)") {
                                  await _scholarReference.get().then(
                                    (snapshot) async {
                                      for (final scholarsId
                                          in snapshot.children) {
                                        Map<String, dynamic> myObj = jsonDecode(
                                            jsonEncode(scholarsId.value));
                                        Scholar myScholar =
                                            Scholar.fromJson(myObj);

                                        if (myScholar.hkType == "Non-Faci") {
                                          String scholarID =
                                              scholarsId.key.toString();
                                          String recieverUserType = "scholars";
                                          await checkInbox(
                                              recieverUserType, scholarID);
                                          await sendMessage(
                                              message: fullMessage,
                                              receiverID: scholarID,
                                              receiverUserType:
                                                  recieverUserType);
                                        }
                                      }
                                    },
                                  );
                                } else if (userTypeValue == "Professors") {
                                  await _profReference.get().then(
                                    (snapshot) async {
                                      for (final professorsId
                                          in snapshot.children) {
                                        String professorID =
                                            professorsId.key.toString();
                                        String recieverUserType = "professors";
                                        await checkInbox(
                                            recieverUserType, professorID);
                                        await sendMessage(
                                            message: fullMessage,
                                            receiverID: professorID,
                                            receiverUserType: recieverUserType);
                                      }
                                    },
                                  );
                                } else if (userTypeValue == "Admins") {
                                  await _headReference.get().then(
                                    (snapshot) async {
                                      for (final id in snapshot.children) {
                                        String headId = id.key.toString();
                                        String recieverUserType = "head";
                                        if (headId != userID) {
                                          await checkInbox(
                                              recieverUserType, headId);
                                          await sendMessage(
                                              message: fullMessage,
                                              receiverID: headId,
                                              receiverUserType:
                                                  recieverUserType);
                                        }
                                      }
                                    },
                                  );
                                }

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogSuccess(
                                  headertext: "Successfully posted!",
                                  subtext:
                                      "You have succesfully sent to $userTypeValue, care to share another?",
                                  textButton: "YES",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ).buildSuccessScreen(context);
                                await createHistory(
                                  desc:
                                      "Posted an announcement to $userTypeValue. User sends this message: $fullMessage",
                                  timeStamp: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  userType: userType,
                                  id: userID,
                                );
                              }).catchError((e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                DialogUnsuccessful(
                                  headertext: "Error",
                                  subtext:
                                      "Something went wrong, please try again later.",
                                  textButton: "Clear",
                                  callback: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _inputControllerHeader.text = "";
                                    _inputControllerBody.text = "";
                                  },
                                ).buildUnsuccessfulScreen(context);
                              });
                            },
                          ).buildConfirmScreen(context);
                        },
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

  Future checkInbox(String receiverUserType, receiverID) async {
    var inboxOfReceiver = FirebaseFirestore.instance
        .collection("users")
        .doc(userType)
        .collection(userID);

    var querySnapshot = await inboxOfReceiver.get();
    if (querySnapshot.docs.isEmpty) {
      Map<String, Object> dummyMap = {};
      final dummyHashMap = FirebaseFirestore.instance
          .collection('users')
          .doc(userType)
          .collection(userID)
          .doc("inbox");

      // this will send to THE RECEIVER'S INBOX
      final createInboxToReceiever = FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUserType)
          .collection(receiverID)
          .doc("inbox");

      createInboxToReceiever.set(dummyMap);

      dummyHashMap.set(dummyMap);
    }
  }

  Future sendMessage(
      {required String message, receiverUserType, receiverID}) async {
    // ALSO MAKE AN INBOX OF THIS USER TO THE RECEIVER
    // For this user storage

    debugPrint(receiverUserType);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("hh:mm aaaaa yyyy-MM-dd").format(now);

    // This will send to THIS USER'S INBOX
    final sendMessage = FirebaseFirestore.instance
        .collection('users')
        .doc(userType)
        .collection(userID)
        .doc("inbox")
        .collection(receiverID)
        .doc(Timestamp.now().seconds.toString());

    final sendInboxToReceiver = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserType)
        .collection(receiverID)
        .doc("inbox")
        .collection(userID)
        .doc(Timestamp.now().seconds.toString());

    final json = {
      'message': message,
      'date': formattedDate,
      'sender': userID,
      'read': 'false'
    };

    // SET THIS USER
    await sendMessage.set(json);

    // SET THIS RECEIVER
    await sendInboxToReceiver.set(json);
  }

  DropdownMenuItem<String> buildMenuItemUserType(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: ColorPalette.primary,
          ),
        ),
      );

  @override
  void dispose() {
    _inputControllerHeader.dispose();
    _inputControllerBody.dispose();
    super.dispose();
  }
}
