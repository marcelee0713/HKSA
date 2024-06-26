import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      backgroundColor: ColorPalette.accentWhite,
      drawer: const NavDraw(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Builder(builder: (context) {
                return SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_rounded,
                        size: 40,
                        color: ColorPalette.primary,
                      ),
                    ),
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: getActiveInActive(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
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
                                SizedBox(height: 16),
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: [
                            const Text(
                              "Pie Chart",
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              "Status of active and inactive Faci Scholars.",
                              style: TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "A total of ${snapshot.data!.first.totalScholar} Faci Scholars.",
                              style: const TextStyle(
                                color: ColorPalette.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
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
                    FutureBuilder(
                      future: getFinishedUnfinished(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.hasError) {
                          return SizedBox(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 8),
                                  Container(
                                      height: 1, color: ColorPalette.primary),
                                  const SizedBox(height: 16),
                                  const Icon(
                                    Icons.warning_rounded,
                                    size: 200,
                                    color: ColorPalette.errorColor,
                                  ),
                                  const Text(
                                    'Something went wrong!',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: ColorPalette.accentBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Please try again later.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: ColorPalette.accentBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Container(height: 1, color: ColorPalette.primary),
                            const SizedBox(height: 16),
                            const Text(
                              "Finished and unfinished Faci Scholars",
                              style: TextStyle(
                                color: ColorPalette.primary,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<StatusData>> getActiveInActive() async {
    // Return two objects
    int scholarsLength = 0;
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
        if (myScholarObj.scholarType == "Faci") {
          myScholarObj.status == "active"
              ? activeStatusCount++
              : inActiveStatusCount++;
          scholarTotal++;
          scholarsLength++;
        }
      }

      if (scholarTotal == 0) {
        StatusData activeObj =
            StatusData("No Data", 0.1, ColorPalette.primary, "0", "0");
        StatusData inActiveObj =
            StatusData("No Data", 0.1, ColorPalette.errorColor, "0", "0");

        activeAndInactive.add(activeObj);
        activeAndInactive.add(inActiveObj);
        return activeAndInactive;
      }

      double percentageOfActive = (activeStatusCount / scholarTotal) * 100;
      double percentageOfInActive = (inActiveStatusCount / scholarTotal) * 100;

      String percentOfActiveStr = "${percentageOfActive.round()}%";
      String percentOfInActiveStr = "${percentageOfInActive.round()}%";

      StatusData activeObj = StatusData("Active", percentageOfActive,
          ColorPalette.primary, percentOfActiveStr, scholarsLength.toString());
      StatusData inActiveObj = StatusData(
          "Inactive",
          percentageOfInActive,
          ColorPalette.errorColor,
          percentOfInActiveStr,
          scholarsLength.toString());

      activeAndInactive.add(activeObj);
      activeAndInactive.add(inActiveObj);
    });

    debugPrint(activeAndInactive.toString());

    return activeAndInactive;
  }

  Future<List<StatusData>> getFinishedUnfinished() async {
    // Return two objects
    List<StatusData> finishedAndUnFinished = [];
    int scholarsLength = 0;
    final DatabaseReference _scholarReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/");

    await _scholarReference.get().then((snapshot) {
      double scholarTotal = 0;
      double finishedCount = 0;
      double unFinishedCount = 0;
      for (final data in snapshot.children) {
        Map<String, dynamic> myObj = jsonDecode(jsonEncode(data.value));
        Scholar myScholarObj = Scholar.fromJson(myObj);
        if (myScholarObj.scholarType == "Faci") {
          myScholarObj.isFinished == "true"
              ? finishedCount++
              : unFinishedCount++;
          scholarTotal++;
        }
      }

      if (scholarTotal == 0) {
        StatusData finishedObj =
            StatusData("No Data", 0.1, ColorPalette.primary, "0", "0");
        StatusData unFinishedObj =
            StatusData("No Data", 0.1, ColorPalette.errorColor, "0", "0");
        finishedAndUnFinished.add(finishedObj);
        finishedAndUnFinished.add(unFinishedObj);
        return finishedAndUnFinished;
      }

      double percentageOfFinished = (finishedCount / scholarTotal) * 100;
      double percentageOfUnFinished = (unFinishedCount / scholarTotal) * 100;

      if (percentageOfFinished.isNaN || percentageOfFinished.isInfinite) {
        percentageOfFinished = 1;
      }

      if (percentageOfUnFinished.isNaN || percentageOfUnFinished.isInfinite) {
        percentageOfUnFinished = 1;
      }

      String percentOfFinishedStr = "${percentageOfFinished.round()}%";
      String percentOfUnFinishedStr = "${percentageOfUnFinished.round()}%";

      StatusData finishedObj = StatusData(
          "Finished",
          percentageOfFinished,
          ColorPalette.primary,
          percentOfFinishedStr,
          scholarsLength.toString());
      StatusData unFinishedObj = StatusData(
          "Unfinished",
          percentageOfUnFinished,
          ColorPalette.errorColor,
          percentOfUnFinishedStr,
          scholarsLength.toString());

      finishedAndUnFinished.add(finishedObj);
      finishedAndUnFinished.add(unFinishedObj);
    });

    return finishedAndUnFinished;
  }
}
