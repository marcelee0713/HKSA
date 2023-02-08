import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/logs.dart';
import 'package:hksa/widgets/scholarWidgets/chart/log_box.dart';

final logInBox = Hive.box("myLoginBox");
var userID = logInBox.get("userID");

class LogsListView extends StatefulWidget {
  const LogsListView({super.key});

  @override
  State<LogsListView> createState() => _LogsListViewState();
}

class _LogsListViewState extends State<LogsListView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 30,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: ColorPalette.primary),
            child: const Center(
              child: Text(
                "Time Logs",
                style: TextStyle(
                  color: ColorPalette.accentWhite,
                  fontFamily: 'Frank Ruhl Libre',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorPalette.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder(
                future: createLogsCollection(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: ColorPalette.secondary,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("Loading...",
                              style: TextStyle(color: ColorPalette.secondary)),
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
                            size: 150,
                            color: ColorPalette.secondary,
                          ),
                          Text(
                            'Something went wrong!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: ColorPalette.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Please try again later.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: ColorPalette.secondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.format_list_numbered_rounded,
                            size: 150,
                            color: ColorPalette.secondary,
                          ),
                          Text(
                            "Seems like you don't have any records yet.",
                            style: TextStyle(
                              color: ColorPalette.secondary,
                              fontFamily: 'Inter',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return LogBox(
                            timeIn: snapshot.data![index].timeIn,
                            timeOut: snapshot.data![index].timeOut,
                            index: index);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<List<Logs>> createLogsCollection() async {
    List<Logs> dataList = [];
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child('dtrlogs/$userID');

    await dbReference.get().then((snapshot) {
      for (final data in snapshot.children) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));

        Logs myLogs = Logs(
            timeIn: myObj["timein"],
            timeOut: myObj["timeout"],
            signature: myObj["signature"],
            date: myObj["date"],
            multiplier: myObj["multiplier"]);
        dataList.add(myLogs);
      }
    });

    return dataList;
  }
}
