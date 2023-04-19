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
import 'package:hksa/models/scholar.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_edit_scholar.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';
import 'package:hksa/widgets/universal/view_inbox.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Scheduling:',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // TODO take a look at the exalidraw
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    userType == "head"
                        ? Column(
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
                                                builder: (context) =>
                                                    EditScholar(
                                                        userID: snapshot
                                                            .data!
                                                            .first
                                                            .studentNumber)));
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
                                                    hkType: snapshot.data!.first
                                                                .scholarType ==
                                                            "Faci"
                                                        ? snapshot
                                                            .data!.first.hkType
                                                        : "Non-Faci");
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
                                            final results = await FilePicker
                                                .platform
                                                .pickFiles(
                                              allowMultiple: false,
                                              type: FileType.custom,
                                              allowedExtensions: ['png', 'jpg'],
                                              allowCompression: true,
                                            );

                                            if (results == null) {
                                              return;
                                            }
                                            // ignore: use_build_context_synchronously
                                            DialogLoading(
                                                    subtext: "Changing...")
                                                .buildLoadingScreen(context);

                                            final path =
                                                results.files.single.path!;
                                            final fileName =
                                                results.files.single.name;

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
                                                "Are you sure you want to delete this user?",
                                            callback: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              final DatabaseReference
                                                  userReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'Users/Scholars/${widget.userID}');

                                              final DatabaseReference
                                                  dtrLogsReference =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'dtrlogs/${widget.userID}');

                                              await userReference.remove();
                                              await dtrLogsReference.remove();
                                              if (FirebaseStorage.instance
                                                      .refFromURL(snapshot
                                                          .data!
                                                          .first
                                                          .profilePicture) !=
                                                  FirebaseStorage.instance
                                                      .refFromURL(HKSAStrings
                                                          .pfpPlaceholder)) {
                                                await FirebaseStorage.instance
                                                    .refFromURL(snapshot.data!
                                                        .first.profilePicture)
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
                                        backgroundColor:
                                            ColorPalette.errorColor,
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
                                  )
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
