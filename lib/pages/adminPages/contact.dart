import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/chat.dart';
import 'package:hksa/models/head.dart';
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
  final logInBox = Hive.box("myLoginBox");
  late var userID = logInBox.get("userID");
  // For Searching
  String searchname = "";
  String searchid = "";
  final controller = TextEditingController();

  // For Firebase
  final DatabaseReference _scholarReference =
      FirebaseDatabase.instance.ref().child("Users/Scholars/");
  final DatabaseReference _profReference =
      FirebaseDatabase.instance.ref().child("Users/Professors/");
  final DatabaseReference _headReference =
      FirebaseDatabase.instance.ref().child("Users/Head/");

  // For DropDown
  String? value = "All";
  String? timeValue;
  String? dayValue;
  String? townValue;

  final filteringOptions = ["All", "Professors", "Admins"];
  final adminFilteringOptions = ["All", "Admins"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      drawer: const NavDraw(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        color: ColorPalette.accentWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Builder(builder: (context) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_rounded,
                        size: 40,
                        color: ColorPalette.primary,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 10),
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
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Announce()));
                  },
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.campaign,
                    color: ColorPalette.primary,
                    size: 40.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: !filteringOptions.contains(value)
                              ? const Radius.circular(0)
                              : const Radius.circular(10)),
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
                              if (value == "All" || value == "Admins") {
                                timeValue = null;
                                dayValue = null;
                              }
                              if (filteringOptions.contains(value)) {
                                townValue = null;
                              }
                            })),
                      ),
                    ),
                  ),
                ),
                !filteringOptions.contains(value)
                    ? const SizedBox(width: 5)
                    : const SizedBox(),
                !filteringOptions.contains(value)
                    ? Expanded(
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0.5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10)),
                            color: ColorPalette.accentDarkWhite,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text(
                                "Enter Town",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 32,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorPalette.primary,
                              ),
                              value: townValue,
                              items:
                                  HKSAStrings.towns.map(buildMenuItem).toList(),
                              onChanged: ((townValue) => setState(() {
                                    this.townValue = townValue;
                                  })),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 5),
            !adminFilteringOptions.contains(value)
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0.5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            color: ColorPalette.accentDarkWhite,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text(
                                "Enter Vacant Time",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 32,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorPalette.primary,
                              ),
                              value: timeValue,
                              items: HKSAStrings.vacanttime
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: ((timeValue) => setState(() {
                                    this.timeValue = timeValue ?? "";
                                  })),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0.5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10)),
                            color: ColorPalette.accentDarkWhite,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: const Text(
                                "Enter Vacant Day",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 32,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorPalette.primary,
                              ),
                              value: dayValue,
                              items: HKSAStrings.vacantday
                                  .map(buildMenuItem)
                                  .toList(),
                              onChanged: ((dayValue) => setState(() {
                                    this.dayValue = dayValue ?? "";
                                  })),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 5),
            Container(height: 1, color: ColorPalette.primary),
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

                  snapshot.data!.sort(
                    (a, b) => a.name.compareTo(b.name),
                  );

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
      ),
    );
  }

  Future<List<Chat>> dropDownFunction() {
    if (value == 'All') {
      return getAll();
    } else if (value == 'Scholars') {
      return getScholars();
    } else if (value == "Scholars (Faci)") {
      return getFaciScholars();
    } else if (value == "Scholars (Non-Faci)") {
      return getNonFaciScholars();
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
    } else if (value == "Admins") {
      return getAdmins();
    }
    return getAll();
  }

  Future<List<Chat>> getAll() async {
    List<Chat> myAppList = [];
    try {
      _headReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          Head myHeadObj = Head.fromJson(myObj);
          if (myHeadObj.userId != userID) {
            Chat myChatObj = Chat(
              name: myHeadObj.name,
              userId: myHeadObj.userId,
              pfp: myHeadObj.profilePicture,
              userType: "head",
              isIncomplete: "false",
            );
            myAppList.add(myChatObj);
          }
        }
      });
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            final essentialInfos = [
              myScholarObj.assignedProfD1,
              myScholarObj.assignedProfD2,
              myScholarObj.assignedProfWd,
              myScholarObj.onSiteDay1,
              myScholarObj.onSiteDay2,
              myScholarObj.vacantTimeDay1,
              myScholarObj.vacantTimeDay2,
              myScholarObj.wholeDayVacantTime
            ];

            var isIncomplete =
                essentialInfos.contains("") || essentialInfos.contains("NONE");

            if (myScholarObj.scholarType == "Non-Faci") {
              isIncomplete = false;
            }

            if (timeValue != null && dayValue != null) {
              final timeArray = <String, String>{
                'time1': myScholarObj.vacantTimeDay1,
                'time2': myScholarObj.vacantTimeDay2
              };
              final dayArray = <String, String>{
                'day1': myScholarObj.onSiteDay1,
                'day2': myScholarObj.onSiteDay2,
                'wd': myScholarObj.wholeDayVacantTime
              };

              if (timeArray.containsValue(timeValue) &&
                  dayArray.containsValue(dayValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else if (timeValue != null) {
              final array = <String, String>{
                'time1': myScholarObj.vacantTimeDay1,
                'time2': myScholarObj.vacantTimeDay2
              };

              if (array.containsValue(timeValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else if (dayValue != null) {
              final array = <String, String>{
                'day1': myScholarObj.onSiteDay1,
                'day2': myScholarObj.onSiteDay2,
                'wd': myScholarObj.wholeDayVacantTime
              };

              if (array.containsValue(dayValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else {
              if (townValue != null) {
                String scholarTown = myScholarObj.town;
                if (townValue == scholarTown) {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              } else {
                Chat myChatObj = Chat(
                  name: myScholarObj.name,
                  userId: myScholarObj.studentNumber,
                  pfp: myScholarObj.profilePicture,
                  userType: "scholar",
                  isIncomplete: isIncomplete.toString(),
                );
                myAppList.add(myChatObj);
              }
            }
          }
        },
      );
      await _profReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Professor myProfessorObj = Professor.fromJson(myObj);
            if (timeValue != null && dayValue != null) {
              if (timeValue == myProfessorObj.time &&
                  dayValue == myProfessorObj.day) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else if (timeValue != null) {
              if (timeValue == myProfessorObj.time) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else if (dayValue != null) {
              if (dayValue == myProfessorObj.day) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else {
              Chat myChatObj = Chat(
                name: myProfessorObj.name,
                userId: myProfessorObj.professorId,
                pfp: myProfessorObj.profilePicture,
                userType: "professor",
                isIncomplete: "false",
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

  Future<List<Chat>> getScholars() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            final essentialInfos = [
              myScholarObj.assignedProfD1,
              myScholarObj.assignedProfD2,
              myScholarObj.assignedProfWd,
              myScholarObj.onSiteDay1,
              myScholarObj.onSiteDay2,
              myScholarObj.vacantTimeDay1,
              myScholarObj.vacantTimeDay2,
              myScholarObj.wholeDayVacantTime
            ];

            var isIncomplete =
                essentialInfos.contains("") || essentialInfos.contains("NONE");

            if (myScholarObj.scholarType == "Non-Faci") {
              isIncomplete = false;
            }
            if (timeValue != null && dayValue != null) {
              final timeArray = <String, String>{
                'time1': myScholarObj.vacantTimeDay1,
                'time2': myScholarObj.vacantTimeDay2
              };
              final dayArray = <String, String>{
                'day1': myScholarObj.onSiteDay1,
                'day2': myScholarObj.onSiteDay2,
                'wd': myScholarObj.wholeDayVacantTime
              };

              if (timeArray.containsValue(timeValue) &&
                  dayArray.containsValue(dayValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else if (timeValue != null) {
              final array = <String, String>{
                'time1': myScholarObj.vacantTimeDay1,
                'time2': myScholarObj.vacantTimeDay2
              };

              if (array.containsValue(timeValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else if (dayValue != null) {
              final array = <String, String>{
                'day1': myScholarObj.onSiteDay1,
                'day2': myScholarObj.onSiteDay2,
                'wd': myScholarObj.wholeDayVacantTime
              };

              if (array.containsValue(dayValue)) {
                String scholarTown = myScholarObj.town;

                if (townValue != null) {
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            } else {
              if (townValue != null) {
                String scholarTown = myScholarObj.town;
                if (townValue == scholarTown) {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              } else {
                Chat myChatObj = Chat(
                  name: myScholarObj.name,
                  userId: myScholarObj.studentNumber,
                  pfp: myScholarObj.profilePicture,
                  userType: "scholar",
                  isIncomplete: isIncomplete.toString(),
                );
                myAppList.add(myChatObj);
              }
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Chat>> getFaciScholars() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            final essentialInfos = [
              myScholarObj.assignedProfD1,
              myScholarObj.assignedProfD2,
              myScholarObj.assignedProfWd,
              myScholarObj.onSiteDay1,
              myScholarObj.onSiteDay2,
              myScholarObj.vacantTimeDay1,
              myScholarObj.vacantTimeDay2,
              myScholarObj.wholeDayVacantTime
            ];

            var isIncomplete =
                essentialInfos.contains("") || essentialInfos.contains("NONE");

            if (myScholarObj.scholarType == "Non-Faci") {
              isIncomplete = false;
            }
            if (myScholarObj.scholarType == "Faci") {
              if (timeValue != null && dayValue != null) {
                final timeArray = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };
                final dayArray = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (timeArray.containsValue(timeValue) &&
                    dayArray.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (timeValue != null) {
                final array = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };

                if (array.containsValue(timeValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (dayValue != null) {
                final array = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (array.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else {
                if (townValue != null) {
                  String scholarTown = myScholarObj.town;
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            }
          }
        },
      );
      return myAppList;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Chat>> getNonFaciScholars() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);

            const isIncomplete = false;
            if (myScholarObj.scholarType == "Non-Faci") {
              if (timeValue != null && dayValue != null) {
                final timeArray = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };
                final dayArray = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (timeArray.containsValue(timeValue) &&
                    dayArray.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (timeValue != null) {
                final array = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };

                if (array.containsValue(timeValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (dayValue != null) {
                final array = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (array.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else {
                if (townValue != null) {
                  String scholarTown = myScholarObj.town;
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
            }
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
            if (timeValue != null && dayValue != null) {
              if (timeValue == myProfessorObj.time &&
                  dayValue == myProfessorObj.day) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else if (timeValue != null) {
              if (timeValue == myProfessorObj.time) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else if (dayValue != null) {
              if (dayValue == myProfessorObj.day) {
                Chat myChatObj = Chat(
                  name: myProfessorObj.name,
                  userId: myProfessorObj.professorId,
                  pfp: myProfessorObj.profilePicture,
                  userType: "professor",
                  isIncomplete: "false",
                );
                myAppList.add(myChatObj);
              }
            } else {
              Chat myChatObj = Chat(
                name: myProfessorObj.name,
                userId: myProfessorObj.professorId,
                pfp: myProfessorObj.profilePicture,
                userType: "professor",
                isIncomplete: "false",
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

  Future<List<Chat>> getAdmins() async {
    List<Chat> myAppList = [];
    try {
      await _headReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Head myHeadObj = Head.fromJson(myObj);
            if (myHeadObj.userId != userID) {
              Chat myChatObj = Chat(
                name: myHeadObj.name,
                userId: myHeadObj.userId,
                pfp: myHeadObj.profilePicture,
                userType: "head",
                isIncomplete: "false",
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

  Future<List<Chat>> getActiveScholar() async {
    List<Chat> myAppList = [];
    try {
      await _scholarReference.get().then(
        (snapshot) {
          for (final data in snapshot.children) {
            Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
            Scholar myScholarObj = Scholar.fromJson(myObj);
            final essentialInfos = [
              myScholarObj.assignedProfD1,
              myScholarObj.assignedProfD2,
              myScholarObj.assignedProfWd,
              myScholarObj.onSiteDay1,
              myScholarObj.onSiteDay2,
              myScholarObj.vacantTimeDay1,
              myScholarObj.vacantTimeDay2,
              myScholarObj.wholeDayVacantTime
            ];
            var isIncomplete =
                essentialInfos.contains("") || essentialInfos.contains("NONE");

            if (myScholarObj.scholarType == "Non-Faci") {
              isIncomplete = false;
            }
            if (myScholarObj.status == "active") {
              if (timeValue != null && dayValue != null) {
                final timeArray = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };
                final dayArray = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (timeArray.containsValue(timeValue) &&
                    dayArray.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (timeValue != null) {
                final array = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };

                if (array.containsValue(timeValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (dayValue != null) {
                final array = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (array.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else {
                if (townValue != null) {
                  String scholarTown = myScholarObj.town;
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
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
            final essentialInfos = [
              myScholarObj.assignedProfD1,
              myScholarObj.assignedProfD2,
              myScholarObj.assignedProfWd,
              myScholarObj.onSiteDay1,
              myScholarObj.onSiteDay2,
              myScholarObj.vacantTimeDay1,
              myScholarObj.vacantTimeDay2,
              myScholarObj.wholeDayVacantTime
            ];

            var isIncomplete =
                essentialInfos.contains("") || essentialInfos.contains("NONE");

            if (myScholarObj.scholarType == "Non-Faci") {
              isIncomplete = false;
            }

            if (myScholarObj.status == "inactive") {
              if (timeValue != null && dayValue != null) {
                final timeArray = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };
                final dayArray = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (timeArray.containsValue(timeValue) &&
                    dayArray.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (timeValue != null) {
                final array = <String, String>{
                  'time1': myScholarObj.vacantTimeDay1,
                  'time2': myScholarObj.vacantTimeDay2
                };

                if (array.containsValue(timeValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else if (dayValue != null) {
                final array = <String, String>{
                  'day1': myScholarObj.onSiteDay1,
                  'day2': myScholarObj.onSiteDay2,
                  'wd': myScholarObj.wholeDayVacantTime
                };

                if (array.containsValue(dayValue)) {
                  String scholarTown = myScholarObj.town;

                  if (townValue != null) {
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              } else {
                if (townValue != null) {
                  String scholarTown = myScholarObj.town;
                  if (townValue == scholarTown) {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                } else {
                  Chat myChatObj = Chat(
                    name: myScholarObj.name,
                    userId: myScholarObj.studentNumber,
                    pfp: myScholarObj.profilePicture,
                    userType: "scholar",
                    isIncomplete: isIncomplete.toString(),
                  );
                  myAppList.add(myChatObj);
                }
              }
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
            if (myScholarObj.scholarType == "Faci") {
              final essentialInfos = [
                myScholarObj.assignedProfD1,
                myScholarObj.assignedProfD2,
                myScholarObj.assignedProfWd,
                myScholarObj.onSiteDay1,
                myScholarObj.onSiteDay2,
                myScholarObj.vacantTimeDay1,
                myScholarObj.vacantTimeDay2,
                myScholarObj.wholeDayVacantTime
              ];

              var isIncomplete = essentialInfos.contains("") ||
                  essentialInfos.contains("NONE");

              if (myScholarObj.scholarType == "Non-Faci") {
                isIncomplete = false;
              }
              if (myScholarObj.isFinished == "true") {
                if (timeValue != null && dayValue != null) {
                  final timeArray = <String, String>{
                    'time1': myScholarObj.vacantTimeDay1,
                    'time2': myScholarObj.vacantTimeDay2
                  };
                  final dayArray = <String, String>{
                    'day1': myScholarObj.onSiteDay1,
                    'day2': myScholarObj.onSiteDay2,
                    'wd': myScholarObj.wholeDayVacantTime
                  };

                  if (timeArray.containsValue(timeValue) &&
                      dayArray.containsValue(dayValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else if (timeValue != null) {
                  final array = <String, String>{
                    'time1': myScholarObj.vacantTimeDay1,
                    'time2': myScholarObj.vacantTimeDay2
                  };

                  if (array.containsValue(timeValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else if (dayValue != null) {
                  final array = <String, String>{
                    'day1': myScholarObj.onSiteDay1,
                    'day2': myScholarObj.onSiteDay2,
                    'wd': myScholarObj.wholeDayVacantTime
                  };

                  if (array.containsValue(dayValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else {
                  if (townValue != null) {
                    String scholarTown = myScholarObj.town;
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              }
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
            if (myScholarObj.scholarType == "Faci") {
              final essentialInfos = [
                myScholarObj.assignedProfD1,
                myScholarObj.assignedProfD2,
                myScholarObj.assignedProfWd,
                myScholarObj.onSiteDay1,
                myScholarObj.onSiteDay2,
                myScholarObj.vacantTimeDay1,
                myScholarObj.vacantTimeDay2,
                myScholarObj.wholeDayVacantTime
              ];
              var isIncomplete = essentialInfos.contains("") ||
                  essentialInfos.contains("NONE");

              if (myScholarObj.scholarType == "Non-Faci") {
                isIncomplete = false;
              }
              if (myScholarObj.isFinished == "false") {
                if (timeValue != null && dayValue != null) {
                  final timeArray = <String, String>{
                    'time1': myScholarObj.vacantTimeDay1,
                    'time2': myScholarObj.vacantTimeDay2
                  };
                  final dayArray = <String, String>{
                    'day1': myScholarObj.onSiteDay1,
                    'day2': myScholarObj.onSiteDay2,
                    'wd': myScholarObj.wholeDayVacantTime
                  };

                  if (timeArray.containsValue(timeValue) &&
                      dayArray.containsValue(dayValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else if (timeValue != null) {
                  final array = <String, String>{
                    'time1': myScholarObj.vacantTimeDay1,
                    'time2': myScholarObj.vacantTimeDay2
                  };

                  if (array.containsValue(timeValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else if (dayValue != null) {
                  final array = <String, String>{
                    'day1': myScholarObj.onSiteDay1,
                    'day2': myScholarObj.onSiteDay2,
                    'wd': myScholarObj.wholeDayVacantTime
                  };

                  if (array.containsValue(dayValue)) {
                    String scholarTown = myScholarObj.town;

                    if (townValue != null) {
                      if (townValue == scholarTown) {
                        Chat myChatObj = Chat(
                          name: myScholarObj.name,
                          userId: myScholarObj.studentNumber,
                          pfp: myScholarObj.profilePicture,
                          userType: "scholar",
                          isIncomplete: isIncomplete.toString(),
                        );
                        myAppList.add(myChatObj);
                      }
                    } else {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  }
                } else {
                  if (townValue != null) {
                    String scholarTown = myScholarObj.town;
                    if (townValue == scholarTown) {
                      Chat myChatObj = Chat(
                        name: myScholarObj.name,
                        userId: myScholarObj.studentNumber,
                        pfp: myScholarObj.profilePicture,
                        userType: "scholar",
                        isIncomplete: isIncomplete.toString(),
                      );
                      myAppList.add(myChatObj);
                    }
                  } else {
                    Chat myChatObj = Chat(
                      name: myScholarObj.name,
                      userId: myScholarObj.studentNumber,
                      pfp: myScholarObj.profilePicture,
                      userType: "scholar",
                      isIncomplete: isIncomplete.toString(),
                    );
                    myAppList.add(myChatObj);
                  }
                }
              }
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
