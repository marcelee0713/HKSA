import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/adminPages/contact.dart';
import 'package:hksa/widgets/dialogs/dialog_confirm.dart';
import 'package:hksa/widgets/dialogs/dialog_edit_professor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
      body: Container(
        padding: const EdgeInsets.all(20),
        color: ColorPalette.secondary,
        child: FutureBuilder(
          future: getProfessor(),
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inbox(
                                          receiverFullName:
                                              snapshot.data!.first.name,
                                          receiverID:
                                              snapshot.data!.first.professorId,
                                          receiverType: "professor",
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.accentDarkWhite,
                          ),
                          child: const Text(
                            "Message",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorPalette.primary),
                          ),
                        ),
                        const SizedBox(width: 2),
                        userType == "head"
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfessor(
                                              userID: snapshot
                                                  .data!.first.professorId)));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.accentDarkWhite,
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: ColorPalette.primary),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 2),
                        userType == "head"
                            ? ElevatedButton(
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
                                                'Users/Professors/${widget.userID}');

                                        await userReference.remove();
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
                              )
                            : const SizedBox(),
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
