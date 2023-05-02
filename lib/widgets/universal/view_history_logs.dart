import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/history.dart';
import 'package:hksa/widgets/adminWidgets/history_logs/history_box.dart';
import 'package:intl/intl.dart';

class HistoryLogs extends StatefulWidget {
  const HistoryLogs({super.key, required this.userID});
  final String userID;

  @override
  State<HistoryLogs> createState() => _HistoryLogsState();
}

class _HistoryLogsState extends State<HistoryLogs> {
  String selected = "all";
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accentWhite,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "History Logs",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.primary),
              ),
              const Text(
                "This is where you can see all of the changes of this user. It includes, logging in or out, timing in or out, and etc...",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: ColorPalette.primary),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = "all";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected == "all"
                            ? ColorPalette.primary
                            : ColorPalette.accentWhite,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: selected == "all"
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selected == "all"
                              ? ColorPalette.accentWhite
                              : ColorPalette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = "recently";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected == "recently"
                            ? ColorPalette.primary
                            : ColorPalette.accentWhite,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Recently",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: selected == "recently"
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selected == "recently"
                              ? ColorPalette.accentWhite
                              : ColorPalette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = "lastWeek";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected == "lastWeek"
                            ? ColorPalette.primary
                            : ColorPalette.accentWhite,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Last week",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: selected == "lastWeek"
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selected == "lastWeek"
                              ? ColorPalette.accentWhite
                              : ColorPalette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = "lastMonth";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected == "lastMonth"
                            ? ColorPalette.primary
                            : ColorPalette.accentWhite,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Last month",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: selected == "lastMonth"
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selected == "lastMonth"
                              ? ColorPalette.accentWhite
                              : ColorPalette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = "longAgo";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected == "longAgo"
                            ? ColorPalette.primary
                            : ColorPalette.accentWhite,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorPalette.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Long time ago..",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: selected == "longAgo"
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selected == "longAgo"
                              ? ColorPalette.accentWhite
                              : ColorPalette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: pickerFunction(),
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
                    scrollUp();
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return HistoryBox(
                            desc: snapshot.data![index].desc,
                            date: snapshot.data![index].timeStamp,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // TODO: A delete button
            ],
          ),
        ),
      ),
    );
  }

  Future<List<History>> pickerFunction() {
    if (selected == "all") {
      return getAll();
    } else if (selected == "recently") {
      return getRecently();
    } else if (selected == "lastWeek") {
      return get7DaysAgo();
    } else if (selected == "lastMonth") {
      return get30DaysAgo();
    } else if (selected == "longAgo") {
      return getLongTimeAgo();
    }
    return getAll();
  }

  Future<List<History>> getAll() async {
    List<History> myList = [];
    final DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("historylogs/${widget.userID}");
    try {
      await dbReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          History myHistoryObj = History.fromJson(myObj);

          int unixCode = int.parse(myHistoryObj.timeStamp);
          String desc = myHistoryObj.desc;
          String id = myHistoryObj.id;
          String userType = myHistoryObj.userType;

          DateTime date = DateTime.fromMicrosecondsSinceEpoch(unixCode);
          String formattedDate =
              DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").format(date);

          History finalObj = History(
              desc: desc, timeStamp: formattedDate, userType: userType, id: id);

          myList.add(finalObj);
        }
      });
    } catch (error) {
      rethrow;
    }

    return myList;
  }

  Future<List<History>> getRecently() async {
    List<History> myList = [];
    final DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("historylogs/${widget.userID}");
    try {
      await dbReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          History myHistoryObj = History.fromJson(myObj);

          int unixCode = int.parse(myHistoryObj.timeStamp);
          String desc = myHistoryObj.desc;
          String id = myHistoryObj.id;
          String userType = myHistoryObj.userType;

          DateTime date = DateTime.fromMicrosecondsSinceEpoch(unixCode);
          String formattedDate =
              DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").format(date);

          DateTime referenceDateTime =
              DateTime.now().subtract(const Duration(days: 7));

          if (date.isAfter(referenceDateTime)) {
            History finalObj = History(
                desc: desc,
                timeStamp: formattedDate,
                userType: userType,
                id: id);

            myList.add(finalObj);
          }
        }
      });
    } catch (error) {
      rethrow;
    }

    return myList;
  }

  Future<List<History>> get7DaysAgo() async {
    List<History> myList = [];
    final DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("historylogs/${widget.userID}");
    try {
      await dbReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          History myHistoryObj = History.fromJson(myObj);

          int unixCode = int.parse(myHistoryObj.timeStamp);
          String desc = myHistoryObj.desc;
          String id = myHistoryObj.id;
          String userType = myHistoryObj.userType;

          DateTime date = DateTime.fromMicrosecondsSinceEpoch(unixCode);
          String formattedDate =
              DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").format(date);
          DateTime referenceDateTime =
              DateTime.now().subtract(const Duration(days: 7));
          DateTime referenceDateTime30 =
              DateTime.now().subtract(const Duration(days: 30));

          if (referenceDateTime.isAfter(date) &&
              !date.isBefore(referenceDateTime30)) {
            History finalObj = History(
                desc: desc,
                timeStamp: formattedDate,
                userType: userType,
                id: id);

            myList.add(finalObj);
          }
        }
      });
    } catch (error) {
      rethrow;
    }

    return myList;
  }

  Future<List<History>> get30DaysAgo() async {
    List<History> myList = [];
    final DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("historylogs/${widget.userID}");
    try {
      await dbReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          History myHistoryObj = History.fromJson(myObj);

          int unixCode = int.parse(myHistoryObj.timeStamp);
          String desc = myHistoryObj.desc;
          String id = myHistoryObj.id;
          String userType = myHistoryObj.userType;

          DateTime date = DateTime.fromMicrosecondsSinceEpoch(unixCode);
          String formattedDate =
              DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").format(date);
          DateTime referenceDateTime =
              DateTime.now().subtract(const Duration(days: 30));

          DateTime referenceDateTimeAYearAgo =
              DateTime.now().subtract(const Duration(days: 31));

          if (referenceDateTime.isAfter(date) &&
              !date.isBefore(referenceDateTimeAYearAgo)) {
            History finalObj = History(
                desc: desc,
                timeStamp: formattedDate,
                userType: userType,
                id: id);

            myList.add(finalObj);
          }
        }
      });
    } catch (error) {
      rethrow;
    }

    return myList;
  }

  Future<List<History>> getLongTimeAgo() async {
    List<History> myList = [];
    final DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("historylogs/${widget.userID}");
    try {
      await dbReference.get().then((snapshot) {
        for (final data in snapshot.children) {
          Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
          History myHistoryObj = History.fromJson(myObj);

          int unixCode = int.parse(myHistoryObj.timeStamp);
          String desc = myHistoryObj.desc;
          String id = myHistoryObj.id;
          String userType = myHistoryObj.userType;

          DateTime date = DateTime.fromMicrosecondsSinceEpoch(unixCode);
          String formattedDate =
              DateFormat("E hh:mm:ss aaaaa yyyy-MM-dd").format(date);
          DateTime referenceDateTimeAYearAgo =
              DateTime.now().subtract(const Duration(days: 31));

          if (date.isBefore(referenceDateTimeAYearAgo)) {
            History finalObj = History(
                desc: desc,
                timeStamp: formattedDate,
                userType: userType,
                id: id);

            myList.add(finalObj);
          }
        }
      });
    } catch (error) {
      rethrow;
    }

    return myList;
  }

  void scrollUp() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
