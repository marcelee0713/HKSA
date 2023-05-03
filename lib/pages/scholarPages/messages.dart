import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/main.dart';
import 'package:hksa/models/chat.dart';
import 'package:hksa/models/head.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/pages/login.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/scholarWidgets/messages/chat_box.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
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
            () async {
              _firebaseMessaging.unsubscribeFromTopic('user_all');
              _firebaseMessaging.unsubscribeFromTopic('scholars');
              _firebaseMessaging.unsubscribeFromTopic('scholars_faci');
              _firebaseMessaging.unsubscribeFromTopic('scholars_non_faci');
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

  // For Searching
  String searchname = "";
  String searchid = "";

  // For Firebase
  DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");
  DatabaseReference _headReference =
      FirebaseDatabase.instance.ref().child("Users/Head/");

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: ColorPalette.accentWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchname = value;
                        searchid = value;
                      });
                    },
                    controller: controller,
                    maxLength: 20,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: ColorPalette.accentDarkWhite,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                    style: const TextStyle(
                      color: ColorPalette.primary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contacts",
                style: TextStyle(
                  color: ColorPalette.primary,
                  fontFamily: 'Frank Ruhl Libre',
                  fontSize: 20,
                ),
              ),
              Container(height: 1, color: ColorPalette.primary)
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: getProfessorAndHead(),
              builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
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

                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data![index].name
                            .toLowerCase()
                            .contains(searchname.toLowerCase()) ||
                        snapshot.data![index].userId
                            .toLowerCase()
                            .contains(searchid.toLowerCase())) {
                      return ChatBox(
                        name: snapshot.data![index].name,
                        userId: snapshot.data![index].userId,
                        pfpUrl: snapshot.data![index].pfp,
                        userType: snapshot.data![index].userType,
                        isIncomplete: snapshot.data![index].isIncomplete,
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Chat>> getProfessorAndHead() async {
    List<Chat> myAppList = [];
    try {
      await _headReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Head myHeadObj = Head.fromJson(myObj);
            Chat myChatObj = Chat(
              name: myHeadObj.name,
              userId: myHeadObj.userId,
              pfp: myHeadObj.profilePicture,
              userType: "head",
              isIncomplete: "false",
            );
            myAppList.add(myChatObj);
          }
        },
      );
      await _profReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Professor myProfessorObj = Professor.fromJson(myObj);
            Chat myChatObj = Chat(
              name: myProfessorObj.name,
              userId: myProfessorObj.professorId,
              pfp: myProfessorObj.profilePicture,
              userType: "professor",
              isIncomplete: "false",
            );
            myAppList.add(myChatObj);
          }
        },
      );
      return myAppList;
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
