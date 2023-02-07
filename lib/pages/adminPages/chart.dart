import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/active_inactive_data.dart';
import 'package:hksa/models/scholar.dart';
import 'package:hksa/widgets/adminWidgets/nav_drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminChart extends StatefulWidget {
  const AdminChart({super.key});

  @override
  State<AdminChart> createState() => _AdminChartState();
}

class _AdminChartState extends State<AdminChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDraw(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                color: ColorPalette.secondary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: getActiveInActive(),
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
                          children: [
                            Column(
                              children: const [
                                Text(
                                  "Pie Chart",
                                  style: TextStyle(
                                    color: ColorPalette.accentWhite,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Status of active and inactive scholars.",
                                  style: TextStyle(
                                    color: ColorPalette.accentWhite,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SfCircularChart(
                              legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom),
                              series: <CircularSeries>[
                                PieSeries<StatusData, String>(
                                  dataSource: snapshot.data,
                                  pointColorMapper: (StatusData data, _) =>
                                      data.color,
                                  xValueMapper: (StatusData data, _) =>
                                      data.status,
                                  yValueMapper: (StatusData data, _) =>
                                      data.percentage,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showZeroValue: false,
                                    textStyle: TextStyle(
                                      color: ColorPalette.accentWhite,
                                      fontFamily: 'Inter',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  dataLabelMapper: (StatusData data, _) =>
                                      data.percentStr,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: ColorPalette.accentWhite),
                    const SizedBox(height: 16),
                    FutureBuilder(
                      future: getFinishedUnfinished(),
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
                          children: [
                            const Text(
                              "Finished and unfinished scholars",
                              style: TextStyle(
                                color: ColorPalette.accentWhite,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            SfCircularChart(
                              legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom),
                              series: <CircularSeries>[
                                PieSeries<StatusData, String>(
                                  dataSource: snapshot.data,
                                  pointColorMapper: (StatusData data, _) =>
                                      data.color,
                                  xValueMapper: (StatusData data, _) =>
                                      data.status,
                                  yValueMapper: (StatusData data, _) =>
                                      data.percentage,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showZeroValue: false,
                                    textStyle: TextStyle(
                                      color: ColorPalette.accentWhite,
                                      fontFamily: 'Inter',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  dataLabelMapper: (StatusData data, _) =>
                                      data.percentStr,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<List<StatusData>> getActiveInActive() async {
    // Return two objects
    List<StatusData> activeAndInactive = [];
    final DatabaseReference _scholarReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/");

    await _scholarReference.get().then((snapshot) {
      double scholarTotal = 0;
      double activeStatusCount = 0;
      double inActiveStatusCount = 0;
      for (final data in snapshot.children) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
        Scholar myScholarObj = Scholar.fromJson(myObj);
        myScholarObj.status == "active"
            ? activeStatusCount++
            : inActiveStatusCount++;
        scholarTotal++;
      }

      double percentageOfActive = (activeStatusCount / scholarTotal) * 100;
      double percentageOfInActive = (inActiveStatusCount / scholarTotal) * 100;

      String percentOfActiveStr = "${percentageOfActive.round()}%";
      String percentOfInActiveStr = "${percentageOfInActive.round()}%";

      StatusData activeObj = StatusData("Active", percentageOfActive,
          ColorPalette.primary, percentOfActiveStr);
      StatusData InActiveObj = StatusData("Inactive", percentageOfInActive,
          ColorPalette.errorColor, percentOfInActiveStr);

      activeAndInactive.add(activeObj);
      activeAndInactive.add(InActiveObj);
    });

    debugPrint(activeAndInactive.toString());

    return activeAndInactive;
  }

  Future<List<StatusData>> getFinishedUnfinished() async {
    // Return two objects
    List<StatusData> finishedAndUnFinished = [];
    final DatabaseReference _scholarReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/");

    await _scholarReference.get().then((snapshot) {
      double scholarTotal = 0;
      double finishedCount = 0;
      double unFinishedCount = 0;
      for (final data in snapshot.children) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
        Scholar myScholarObj = Scholar.fromJson(myObj);
        myScholarObj.isFinished == "true" ? finishedCount++ : unFinishedCount++;
        scholarTotal++;
      }

      double percentageOfFinished = (finishedCount / scholarTotal) * 100;
      double percentageOfUnFinished = (unFinishedCount / scholarTotal) * 100;

      String percentOfFinishedStr = "${percentageOfFinished.round()}%";
      String percentOfUnFinishedStr = "${percentageOfUnFinished.round()}%";

      StatusData finishedObj = StatusData("Finished", percentageOfFinished,
          ColorPalette.primary, percentOfFinishedStr);
      StatusData unFinishedObj = StatusData(
          "Unfinished",
          percentageOfUnFinished,
          ColorPalette.errorColor,
          percentOfUnFinishedStr);

      finishedAndUnFinished.add(finishedObj);
      finishedAndUnFinished.add(unFinishedObj);
    });

    return finishedAndUnFinished;
  }
}
