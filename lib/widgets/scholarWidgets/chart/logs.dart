import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/logs.dart';
import 'package:hksa/widgets/dialogs/dialog_loading.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';

final logInBox = Hive.box("myLoginBox");
var userID = logInBox.get("userID");

class LogsListView extends StatefulWidget {
  const LogsListView({super.key});

  @override
  State<LogsListView> createState() => _LogsListViewState();
}

class _LogsListViewState extends State<LogsListView> {
  List<Logs> dataList = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createLogsCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 165,
            height: 55,
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
                  fontSize: 24,
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
            child: isLoading
                ? Center(
                    child: Column(
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/loading.gif'),
                          ),
                        ),
                      ),
                      const Text(
                        "Fetching...",
                        style: TextStyle(
                          color: ColorPalette.accentWhite,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ))
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.all(10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Positioned(
                                    top: 6,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      dataList[index].timeIn.toString(),
                                    ),
                                  ),
                                  Container(
                                      height: 1,
                                      color: ColorPalette.accentBlack),
                                  Positioned(
                                    bottom: 6,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      dataList[index].timeOut.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ),
        ],
      ),
    );
  }

  Future createLogsCollection() async {
    var logs = FirebaseFirestore.instance
        .collection("users")
        .doc("scholars")
        .collection(userID)
        .doc("dtrlogs")
        .collection("logs");
    var querySnapshot = await logs.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = {};
        data = queryDocumentSnapshot.data();
        Logs myLogs = Logs(
          timeIn: data["timein"],
          timeOut: data["timeout"],
          date: data["date"],
          signature: data["signature"],
        );
        dataList.add(myLogs);
        isLoading = false;
      }
    });
  }
}
