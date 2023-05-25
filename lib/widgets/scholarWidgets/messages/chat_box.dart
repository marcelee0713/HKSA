import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/widgets/universal/view_head.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';
import 'package:hksa/widgets/universal/view_professor.dart';
import 'package:hksa/widgets/universal/view_scholar.dart';

class ChatBox extends StatefulWidget {
  final String name;
  final String userId;
  final String pfpUrl;
  final String userType;
  final String isIncomplete;
  const ChatBox(
      {super.key,
      required this.name,
      required this.userId,
      required this.pfpUrl,
      required this.userType,
      required this.isIncomplete});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  late var userType = logInBox.get("userType");
  bool hasConflicts = false;
  bool profHasConflicts = false;

  String inc = "";
  String userPfpUrl = "";
  @override
  void initState() {
    inc = widget.isIncomplete;
    userPfpUrl = widget.pfpUrl;
    getStatus(); // For Scholars
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.userType == "professor") {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfessorProfile(userID: widget.userId)));

          if (result != null) {
            setState(() {
              userPfpUrl = result[0].toString();
            });
          }
        } else if (widget.userType == "head") {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HeadProfile(userID: widget.userId)));
          if (result != null) {
            setState(() {
              userPfpUrl = result[0].toString();
            });
          }
        } else if (widget.userType == "scholar") {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScholarProfile(userID: widget.userId)));
          if (result != null) {
            setState(() {
              userPfpUrl = result[0].toString();
              if (result[1] == "Faci") {
                inc = widget.isIncomplete;
              } else {
                inc = result[1];
              }
            });
          }
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.accentDarkWhite,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userPfpUrl,
                            placeholder: (context, url) => const SpinKitCircle(
                              color: ColorPalette.primary,
                              size: 30,
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            useOldImageOnUrlChange: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.name,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorPalette.accentBlack,
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        widget.userType == "head"
                            ? Container()
                            : Text(
                                widget.userId,
                                style: const TextStyle(
                                  color: ColorPalette.accentBlack,
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                        FutureBuilder(
                          future: checkSchedules(),
                          builder: (context, snapshot) {
                            return userType == "head"
                                ? buildProfIdentifier()
                                : const SizedBox();
                          },
                        ),
                        userType == "head"
                            ? buildScholarIdentifier()
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // Basically it will take the full name and user ID of the user
                    // he wants to chat.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Inbox(
                                  receiverFullName: widget.name,
                                  receiverID: widget.userId,
                                  receiverType: widget.userType,
                                )));
                  },
                  child: const Icon(
                    Icons.chat_bubble,
                    color: ColorPalette.primary,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userType == "head" ? userType : "${userType}s")
                .collection(userID)
                .doc("inbox")
                .collection(widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              int howMany = 0;

              if (snapshot.data!.docs.isNotEmpty) {
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> data = doc.data();
                  String sender = data['sender'] ?? '';
                  String hasRead = data['read'] ?? '';

                  if (sender == widget.userId) {
                    if (hasRead == "false") {
                      howMany++;
                    }
                  }
                }
              } else {
                howMany = 0;
              }

              return howMany == 0
                  ? const SizedBox()
                  : Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: ColorPalette.errorColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            howMany > 99 ? "+99" : howMany.toString(),
                            style: const TextStyle(
                                color: ColorPalette.accentWhite,
                                fontFamily: 'Inter',
                                fontSize: 8.5),
                          ),
                        ),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }

  Widget buildScholarIdentifier() {
    if (widget.userType == "scholar") {
      return Row(
        children: [
          inc == "true"
              ? const Text(
                  "INC",
                  style: TextStyle(
                    color: ColorPalette.errorColor,
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                )
              : const SizedBox(),
          hasConflicts && inc == "true"
              ? const Text(
                  " | ",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                )
              : const SizedBox(),
          hasConflicts
              ? const Text(
                  "CONFLICTS",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 94, 0),
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                )
              : const SizedBox()
        ],
      );
    }

    return const SizedBox();
  }

  Widget buildProfIdentifier() {
    if (widget.userType == "professor") {
      return profHasConflicts
          ? const Text(
              "CONFLICTS",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 94, 0),
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            )
          : const SizedBox();
    }
    return const SizedBox();
  }

  Future<void> checkSchedules() async {
    if (widget.userType == "professor") {
      List<String> conflicts = [];
      final DatabaseReference choicesReference =
          FirebaseDatabase.instance.ref().child("scheduleChoices/");
      final DatabaseReference profReference = FirebaseDatabase.instance
          .ref()
          .child("Users/Professors/${widget.userId}");
      await profReference.get().then((snapshot) async {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Professor myProf = Professor.fromJson(myObj);

        final currentRoom = myProf.room;
        final currentSection = myProf.section;
        final currentSubject = myProf.subject;

        await choicesReference.child("room").get().then((snapshot) {
          bool doesNotExist = true;
          for (final data in snapshot.children) {
            if (currentRoom == data.value) {
              doesNotExist = false;
            }
          }

          if (doesNotExist) {
            conflicts.add("Room doesn't exist!");
          }
        });

        await choicesReference.child("section").get().then((snapshot) {
          bool doesNotExist = true;
          for (final data in snapshot.children) {
            if (currentSection == data.value) {
              doesNotExist = false;
            }
          }

          if (doesNotExist) {
            conflicts.add("Section doesn't exist!");
          }
        });

        await choicesReference.child("subjectCode").get().then((snapshot) {
          bool doesNotExist = true;
          for (final data in snapshot.children) {
            if (currentSubject == data.value) {
              doesNotExist = false;
            }
          }

          if (doesNotExist) {
            conflicts.add("Subject code doesn't exist!");
          }
        }).whenComplete(() {
          if (conflicts.isNotEmpty) {
            if (mounted) {
              setState(() {
                profHasConflicts = true;
              });
            }
          }
        });
      });
    }
  }

  Future<void> getStatus() async {
    if (widget.userType == "scholar") {
      final DatabaseReference scholarRef = FirebaseDatabase.instance
          .ref()
          .child("Users/Scholars/${widget.userId}");
      final DatabaseReference profRef =
          FirebaseDatabase.instance.ref().child("Users/Professors/");
      await scholarRef.get().then((snapshot) async {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(snapshot.value));
        Scholar myScholar = Scholar.fromJson(myObj);

        String scholarType = myScholar.scholarType;

        if (scholarType == "Faci") {
          String day1ProfID = myScholar.assignedProfD1;

          String day2ProfID = myScholar.assignedProfD2;
          String wdProfID = myScholar.assignedProfWd;

          String studentDay1 = myScholar.onSiteDay1;
          String studentDay2 = myScholar.onSiteDay2;
          String studentWholeDay = myScholar.wholeDayVacantTime;
          String studentTime1 = myScholar.vacantTimeDay1;
          String studentTime2 = myScholar.vacantTimeDay2;

          if (day1ProfID != "") {
            await profRef.child(day1ProfID).get().then((snapshot) {
              Map<String, dynamic> myObj =
                  jsonDecode(jsonEncode(snapshot.value));
              Professor myProf = Professor.fromJson(myObj);

              if (myProf.day != studentDay1) {
                setState(() {
                  hasConflicts = true;
                });
              } else if (myProf.time != studentTime1) {
                setState(() {
                  hasConflicts = true;
                });
              }
            });
          }

          if (day2ProfID != "") {
            await profRef.child(day2ProfID).get().then((snapshot) {
              Map<String, dynamic> myObj =
                  jsonDecode(jsonEncode(snapshot.value));
              Professor myProf = Professor.fromJson(myObj);

              if (myProf.day != studentDay2) {
                setState(() {
                  hasConflicts = true;
                });
              } else if (myProf.time != studentTime2) {
                setState(() {
                  hasConflicts = true;
                });
              }
            });
          }

          if (wdProfID != "") {
            await profRef.child(wdProfID).get().then((snapshot) {
              Map<String, dynamic> myObj =
                  jsonDecode(jsonEncode(snapshot.value));
              Professor myProf = Professor.fromJson(myObj);

              if (myProf.day != studentWholeDay) {
                setState(() {
                  hasConflicts = true;
                });
              }
            });
          }
        }
      });
    }
  }
}
