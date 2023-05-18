import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/api/pdf_api.dart';
import 'package:hksa/api/storage_service.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/logs.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/models/scholar_prof_detail.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_edit_scholar.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';
import 'package:hksa/widgets/universal/view_history_logs.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class ScholarProfile extends StatefulWidget {
  final String userID;
  const ScholarProfile({
    super.key,
    required this.userID,
  });

  @override
  State<ScholarProfile> createState() => _ScholarProfileState();
}

class _ScholarProfileState extends State<ScholarProfile> {
  List<Logs> dataList = [];
  final Storage storage = Storage();
  final logInBox = Hive.box("myLoginBox");
  late var userType = logInBox.get("userType");
  String userProfileListener = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: Container(
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
              scrollDirection: Axis.vertical,
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
                        snapshot.data!.first.scholarType == "Faci"
                            ? const SizedBox(
                                height: 20,
                              )
                            : const SizedBox(),
                        snapshot.data!.first.scholarType == "Faci"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Scheduling:',
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                          ),
                                          child: const Text(
                                            "Schedule",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                          ),
                                          child: const Text(
                                            "Day",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                          ),
                                          child: const Text(
                                            "Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                          ),
                                          child: const Text(
                                            "Professor",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Day 1",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot.data!.first.onSiteDay1,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot.data!.first.vacantTimeDay1,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: snapshot.data!.first
                                                      .assignedProfD1 ==
                                                  ""
                                              ? const Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                  ),
                                                )
                                              : ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    FutureBuilder(
                                                      future: getProfNameSectionRoom(
                                                          day1ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD1,
                                                          day2ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD2,
                                                          wDProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfWd),
                                                      builder: (context,
                                                          snapshotProf1) {
                                                        if (!snapshotProf1
                                                            .hasData) {
                                                          return const SpinKitThreeBounce(
                                                            color: ColorPalette
                                                                .secondary,
                                                            size: 15,
                                                          );
                                                        }
                                                        if (snapshotProf1
                                                            .hasError) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .warning_rounded,
                                                                size: 20,
                                                                color: ColorPalette
                                                                    .errorColor,
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                "Error, try again later!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: ColorPalette
                                                                      .errorColor,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                        return Text(
                                                          snapshotProf1.data!
                                                              .first.d1ProfName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Inter',
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Day 2",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot.data!.first.onSiteDay2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot.data!.first.vacantTimeDay2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: snapshot.data!.first
                                                      .assignedProfD2 ==
                                                  ""
                                              ? const Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                  ),
                                                )
                                              : ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    FutureBuilder(
                                                      future: getProfNameSectionRoom(
                                                          day1ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD1,
                                                          day2ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD2,
                                                          wDProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfWd),
                                                      builder: (context,
                                                          snapshotProf2) {
                                                        if (!snapshotProf2
                                                            .hasData) {
                                                          return const SpinKitThreeBounce(
                                                            color: ColorPalette
                                                                .secondary,
                                                            size: 15,
                                                          );
                                                        }
                                                        if (snapshotProf2
                                                            .hasError) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .warning_rounded,
                                                                size: 20,
                                                                color: ColorPalette
                                                                    .errorColor,
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                "Error, try again later!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: ColorPalette
                                                                      .errorColor,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                        return Text(
                                                          snapshotProf2.data!
                                                              .first.d2ProfName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Inter',
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Whole Day",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot
                                                .data!.first.wholeDayVacantTime,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "07:30 - 6:30 PM",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: Center(
                                          child: snapshot.data!.first
                                                      .assignedProfWd ==
                                                  ""
                                              ? const Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                  ),
                                                )
                                              : ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                    FutureBuilder(
                                                      future: getProfNameSectionRoom(
                                                          day1ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD1,
                                                          day2ProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfD2,
                                                          wDProfID: snapshot
                                                              .data!
                                                              .first
                                                              .assignedProfWd),
                                                      builder: (context,
                                                          snapshotProfWd) {
                                                        if (!snapshotProfWd
                                                            .hasData) {
                                                          return const SpinKitThreeBounce(
                                                            color: ColorPalette
                                                                .secondary,
                                                            size: 15,
                                                          );
                                                        }
                                                        if (snapshotProfWd
                                                            .hasError) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .warning_rounded,
                                                                size: 20,
                                                                color: ColorPalette
                                                                    .errorColor,
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                "Error, try again later!",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: ColorPalette
                                                                      .errorColor,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                        return Text(
                                                          snapshotProfWd.data!
                                                              .first.wDProfName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Inter',
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    userType == "head"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Options",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    color: ColorPalette.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Inbox(
                                                      receiverFullName: snapshot
                                                          .data!.first.name,
                                                      receiverID: snapshot.data!
                                                          .first.studentNumber,
                                                      receiverType: "scholar",
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
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditScholar(
                                              userID: snapshot
                                                  .data!.first.studentNumber,
                                              day1ProfID: snapshot
                                                  .data!.first.assignedProfD1,
                                              day2ProfID: snapshot
                                                  .data!.first.assignedProfD2,
                                              wdProfID: snapshot
                                                  .data!.first.assignedProfWd,
                                              scholarType: snapshot
                                                  .data!.first.scholarType,
                                              studentDay1: snapshot
                                                  .data!.first.onSiteDay1,
                                              studentDay2: snapshot
                                                  .data!.first.onSiteDay2,
                                              studentTime1: snapshot
                                                  .data!.first.vacantTimeDay1,
                                              studentTime2: snapshot
                                                  .data!.first.vacantTimeDay2,
                                              studentWholeDay: snapshot.data!
                                                  .first.wholeDayVacantTime,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette.primary,
                                      ),
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalette.accentWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: FutureBuilder(
                                      future: createLogsCollection(),
                                      builder: (context, list) {
                                        if (!list.hasData) {
                                          return ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorPalette.primary,
                                            ),
                                            child: const Text(
                                              "Fetching...",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      ColorPalette.accentWhite),
                                            ),
                                          );
                                        }

                                        return ElevatedButton(
                                          onPressed: () async {
                                            final pdfFile =
                                                await PdfApi.generateTable(
                                                    dataListObj: list.data!,
                                                    fullName: snapshot
                                                        .data!.first.name,
                                                    totalHours: snapshot
                                                        .data!.first.hours,
                                                    hkType: snapshot
                                                        .data!.first.hkType);
                                            PdfApi.openFile(pdfFile);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorPalette.primary,
                                          ),
                                          child: const Text(
                                            "PDF",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: ColorPalette.accentWhite,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DialogConfirm(
                                          headertext:
                                              "Are you sure you want to change this user's profile picture?",
                                          callback: () async {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            PickedFile? results =
                                                await ImagePicker.platform
                                                    .pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 50,
                                              maxHeight: 800,
                                              maxWidth: 800,
                                            );

                                            if (results == null) {
                                              return;
                                            }

                                            // ignore: use_build_context_synchronously
                                            DialogLoading(
                                                    subtext: "Changing...")
                                                .buildLoadingScreen(context);

                                            final path = results.path;
                                            final fileName =
                                                results.path.split('/').last;

                                            debugPrint(path);
                                            debugPrint(fileName);

                                            await storage.changeScholarPfp(
                                                path,
                                                fileName,
                                                snapshot
                                                    .data!.first.studentNumber,
                                                snapshot.data!.first
                                                    .profilePicture, () {
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                setState(() {
                                                  userProfileListener = snapshot
                                                      .data!
                                                      .first
                                                      .profilePicture;
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogSuccess(
                                                    headertext:
                                                        "User's Profile Picture Changed!",
                                                    subtext:
                                                        "Didn't showed? Restart or go to a different page and comeback!",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }).buildSuccessScreen(context);
                                              });
                                            });
                                          },
                                        ).buildConfirmScreen(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette.primary,
                                      ),
                                      child: const Text(
                                        "Change Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalette.accentWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HistoryLogs(userID: widget.userID),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.primary,
                                ),
                                child: const Text(
                                  "View History Logs",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: ColorPalette.accentWhite),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Danger Zone",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    color: ColorPalette.errorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DialogConfirm(
                                            headertext:
                                                "Are you sure you want to reset the total hours of this user?",
                                            callback: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              DialogLoading(
                                                      subtext: "Resetting...")
                                                  .buildLoadingScreen(context);
                                              final DatabaseReference
                                                  userReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'Users/Scholars/${widget.userID}');

                                              await userReference
                                                  .child('hours')
                                                  .set("0");
                                              await userReference
                                                  .child('totalHoursInDisplay')
                                                  .set("0:00:00");
                                              await userReference
                                                  .child('totalHoursInDuration')
                                                  .set("0:00:00.000000")
                                                  .then((value) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogSuccess(
                                                    headertext: "Success",
                                                    subtext:
                                                        "You have successfully reset the total hours of this user! ",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }).buildSuccessScreen(context);
                                              });
                                            }).buildConfirmScreen(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorPalette.errorColor,
                                      ),
                                      child: const Text(
                                        "Reset Total Hours",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalette.accentWhite),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DialogConfirm(
                                            headertext:
                                                "Are you sure you want to reset the dtr logs of this user?",
                                            callback: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              DialogLoading(
                                                      subtext: "Resetting...")
                                                  .buildLoadingScreen(context);
                                              final DatabaseReference
                                                  dtrLogsReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'dtrlogs/${widget.userID}');
                                              await dtrLogsReference
                                                  .remove()
                                                  .then((value) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogSuccess(
                                                    headertext: "Success",
                                                    subtext:
                                                        "You have successfully reset the DTR Logs of this user! ",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }).buildSuccessScreen(context);
                                              });
                                            }).buildConfirmScreen(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorPalette.errorColor,
                                      ),
                                      child: const Text(
                                        "Reset DTR Logs",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalette.accentWhite),
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
                                                "Are you sure you want to reset total hours and DTR Logs of this user?",
                                            callback: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              DialogLoading(
                                                      subtext: "Resetting...")
                                                  .buildLoadingScreen(context);
                                              final DatabaseReference
                                                  dtrLogsReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'dtrlogs/${widget.userID}');
                                              final DatabaseReference
                                                  userReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'Users/Scholars/${widget.userID}');

                                              await userReference
                                                  .child('hours')
                                                  .set("0");
                                              await userReference
                                                  .child('totalHoursInDisplay')
                                                  .set("0:00:00");
                                              await userReference
                                                  .child('totalHoursInDuration')
                                                  .set("0:00:00.000000");
                                              await dtrLogsReference
                                                  .remove()
                                                  .then((value) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                DialogSuccess(
                                                    headertext: "Success",
                                                    subtext:
                                                        "You have successfully reset the Total Hours and DTR Logs of this user! ",
                                                    textButton: "Close",
                                                    callback: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }).buildSuccessScreen(context);
                                              });
                                            }).buildConfirmScreen(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorPalette.errorColor,
                                      ),
                                      child: const Text(
                                        "Reset All",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: ColorPalette.accentWhite),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DialogConfirm(
                                            headertext:
                                                "Are you sure you reset history logs of this user?",
                                            callback: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

                                              final DatabaseReference
                                                  historyLogsReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'historylogs/${widget.userID}');

                                              await historyLogsReference
                                                  .remove();

                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();

                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AdminContacts()));
                                            }).buildConfirmScreen(context);
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
                                            color: ColorPalette.accentWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  DialogConfirm(
                                      headertext:
                                          "Are you sure you want to delete this user?",
                                      callback: () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        final DatabaseReference userReference =
                                            FirebaseDatabase.instance.ref().child(
                                                'Users/Scholars/${widget.userID}');

                                        final DatabaseReference
                                            dtrLogsReference = FirebaseDatabase
                                                .instance
                                                .ref()
                                                .child(
                                                    'dtrlogs/${widget.userID}');

                                        final DatabaseReference
                                            historyLogsReference =
                                            FirebaseDatabase.instance.ref().child(
                                                'historylogs/${widget.userID}');

                                        await userReference.remove();
                                        await dtrLogsReference.remove();
                                        await historyLogsReference.remove();
                                        if (FirebaseStorage.instance.refFromURL(
                                                snapshot.data!.first
                                                    .profilePicture) !=
                                            FirebaseStorage.instance.refFromURL(
                                                HKSAStrings.pfpPlaceholder)) {
                                          await FirebaseStorage.instance
                                              .refFromURL(snapshot
                                                  .data!.first.profilePicture)
                                              .delete();
                                        }

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();

                                        // ignore: use_build_context_synchronously
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminContacts()));
                                      }).buildConfirmScreen(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.errorColor,
                                ),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: ColorPalette.accentWhite),
                                ),
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
                                                .data!.first.studentNumber,
                                            receiverType: "scholar",
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
            );
          },
        ),
      ),
    );
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

  Future<List<Scholar>> getScholar() async {
    List<Scholar> myUser = [];
    final DatabaseReference _userReference = FirebaseDatabase.instance
        .ref()
        .child('Users/Scholars/${widget.userID}');
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

  Future<List<Logs>> createLogsCollection() async {
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('dtrlogs/${widget.userID}');

    await dbReference.get().then((snapshot) {
      for (final data in snapshot.children) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
        Logs myLogs = Logs(
            timeIn: myObj["timein"],
            timeOut: myObj["timeout"],
            profName: myObj["profName"],
            date: myObj["date"],
            multiplier: myObj["multiplier"]);
        dataList.add(myLogs);
      }
    });

    return dataList;
  }
}
