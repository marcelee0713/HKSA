import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/models/scholar_prof_detail.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");

  @override
  Widget build(BuildContext context) {
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
    final userReference =
        FirebaseDatabase.instance.ref().child('Users/Scholars/$userID');
    try {
      await userReference.get().then((snapshot) {
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
