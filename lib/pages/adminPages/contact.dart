import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/chat.dart';
import 'package:hksa/models/professor.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/widgets/adminWidgets/contact/announce.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:hksa/widgets/scholarWidgets/messages/chat_box.dart';

class AdminContacts extends StatefulWidget {
  const AdminContacts({super.key});

  @override
  State<AdminContacts> createState() => _AdminContactsState();
}

class _AdminContactsState extends State<AdminContacts> {
  // For Searching
  String searchname = "";
  String searchid = "";
  final controller = TextEditingController();

  // For Firebase
  final DatabaseReference _scholarReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  final DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");

  // For DropDown
  String? value = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDraw(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        color: ColorPalette.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search_rounded),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 0.5),
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
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Announce()));
                  },
                  child: const Icon(
                    Icons.campaign,
                    color: ColorPalette.primary,
                    size: 40.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0.5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: ColorPalette.accentDarkWhite,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  iconSize: 32,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: ColorPalette.primary,
                  ),
                  value: value,
                  items: HKSAStrings.contactsCategories
                      .map(buildMenuItem)
                      .toList(),
                  onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                ),
              ),
            ),
            Container(height: 1, color: ColorPalette.accentDarkWhite),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: dropDownFunction(),
                builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
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

                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.contact_support_rounded,
                            size: 200,
                            color: ColorPalette.primary,
                          ),
                          Text(
                            'Seems like there is no data regarding this section?',
                            textAlign: TextAlign.center,
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
      ),
    );
  }

  Future<List<Chat>> dropDownFunction() {
    if (value == 'All') {
      return getAll();
    } else if (value == 'Scholars') {
      return getScholars();
    } else if (value == 'Professors') {
      return getProfessors();
    } else if (value == 'Active') {
      return getActiveScholar();
    } else if (value == 'Inactive') {
      return getInactiveScholar();
    } else if (value == 'Finished') {
      return getFinishedScholar();
    } else if (value == 'Unfinished') {
      return getUnfinishedScholar();
    }
    return getAll();
  }

  Future<List<Chat>> getAll() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            Chat myChatObj = Chat(
              name: myScholarObj.name,
              userId: myScholarObj.studentNumber,
              pfp: myScholarObj.profilePicture,
              userType: "scholar",
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

  Future<List<Chat>> getScholars() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            Chat myChatObj = Chat(
              name: myScholarObj.name,
              userId: myScholarObj.studentNumber,
              pfp: myScholarObj.profilePicture,
              userType: "scholar",
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

  Future<List<Chat>> getProfessors() async {
    List<Chat> myAppList = [];
    try {
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

  Future<List<Chat>> getActiveScholar() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);

            if (myScholarObj.status == "active") {
              Chat myChatObj = Chat(
                name: myScholarObj.name,
                userId: myScholarObj.studentNumber,
                pfp: myScholarObj.profilePicture,
                userType: "scholar",
              );
              myAppList.add(myChatObj);
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Chat>> getInactiveScholar() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);

            if (myScholarObj.status == "inactive") {
              Chat myChatObj = Chat(
                name: myScholarObj.name,
                userId: myScholarObj.studentNumber,
                pfp: myScholarObj.profilePicture,
                userType: "scholar",
              );
              myAppList.add(myChatObj);
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Chat>> getFinishedScholar() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);

            if (myScholarObj.isFinished == "true") {
              Chat myChatObj = Chat(
                name: myScholarObj.name,
                userId: myScholarObj.studentNumber,
                pfp: myScholarObj.profilePicture,
                userType: "scholar",
              );
              myAppList.add(myChatObj);
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Chat>> getUnfinishedScholar() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);

            if (myScholarObj.isFinished == "false") {
              Chat myChatObj = Chat(
                name: myScholarObj.name,
                userId: myScholarObj.studentNumber,
                pfp: myScholarObj.profilePicture,
                userType: "scholar",
              );
              myAppList.add(myChatObj);
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: ColorPalette.primary,
          ),
        ),
      );
}