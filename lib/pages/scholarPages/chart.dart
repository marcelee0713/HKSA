import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/widgets/scholarWidgets/chart/chart_v00.dart';
import 'package:hksa/widgets/scholarWidgets/chart/logs.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final logInBox = Hive.box("myLoginBox");
  late var scholarType = logInBox.get("scholarType");

  @override
  Widget build(BuildContext context) {
    return scholarType == "Faci"
        ? ListView(
            children: [
              Container(
                color: ColorPalette.accentWhite,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ScholarHoursRadialChart(),
                    const SizedBox(height: 5),
                    const LogsListView(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              "This is where your DTR logs are recorded that can be also printed and your total hours.",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                color: ColorPalette.primary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            color: ColorPalette.accentWhite,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogsListView(),
                const SizedBox(height: 10),
                const ScholarHoursRadialChart(),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          "This is where your DTR logs are recorded that can be also printed and your total hours.",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            color: ColorPalette.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
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
