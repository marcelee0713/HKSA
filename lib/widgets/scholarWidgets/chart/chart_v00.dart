import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hksa/api/pdf_api.dart';
import 'package:hksa/models/logs.dart';
import 'package:hksa/widgets/dialogs/dialog_unsuccessful.dart';
import 'package:pdf/pdf.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/models/scholar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ScholarHoursRadialChart extends StatefulWidget {
  const ScholarHoursRadialChart({Key? key}) : super(key: key);

  @override
  State<ScholarHoursRadialChart> createState() =>
      _ScholarHoursRadialChartState();
}

class _ScholarHoursRadialChartState extends State<ScholarHoursRadialChart> {
  // This are the default data, ignore them.
  double renderedHours = 0;
  double requiredHours = 10;

  final logInBox = Hive.box("myLoginBox");
  late var userName = logInBox.get("userName");
  late var userID = logInBox.get("userID");
  List<Logs> dataList = [];
  String totalHours = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getHoursAndRequiredHours();
    createLogsCollection();
  }

  DatabaseReference dbReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.secondary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            child: Center(
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.1,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Color(0xffa38b00),
                  ),
                  minimum: 0,
                  maximum: requiredHours,
                  interval: 10,
                  radiusFactor: 0.85,
                  startAngle: 114,
                  endAngle: 67,
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      positionFactor: 1,
                      angle: 90,
                      widget: requiredHours == 10
                          ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Color(0xffffd700),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(color: Color(0xffffd700)),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                Text(
                                  renderedHours == 0
                                      ? "0"
                                      : renderedHours.toString(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  requiredHours == 10
                                      ? "0"
                                      : requiredHours.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 65),
                              ],
                            ),
                    )
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      enableAnimation: true,
                      value: renderedHours,
                      width: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      gradient: const SweepGradient(
                          colors: <Color>[Color(0xffffd700), Color(0xffffe23d)],
                          stops: <double>[0.3, 0.9]),
                    )
                  ],
                ),
              ]),
            ),
          ),
          Positioned(
            bottom: 4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                elevation: 5,
              ),
              onPressed: () async {
                final pdfFile = await PdfApi.generateTable(
                    dataListObj: dataList,
                    fullName: userName,
                    totalHours: renderedHours.toString());
                PdfApi.openFile(pdfFile);
              },
              child: const Text(
                'PDF',
                style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Frank Ruhl Libre',
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getHoursAndRequiredHours() async {
    Map<String, dynamic> myObj = {};
    Scholar myScholarObj;
    await dbReference.child('Users/Scholars/$userID').get().then((snapshot) => {
          myObj = jsonDecode(jsonEncode(snapshot.value)),
          myScholarObj = Scholar.fromJson(myObj),
          if (mounted)
            {
              setState(() {
                renderedHours =
                    double.parse(myScholarObj.hours.replaceAll(":", ""));
                requiredHours = double.parse(myScholarObj.totalHoursRequired);
              }),
            }
        });
    if (renderedHours >= requiredHours) {
      await dbReference.child('Users/Scholars/$userID/isFinished').set("true");
    } else {
      await dbReference.child('Users/Scholars/$userID/isFinished').set("false");
    }
  }

  Future createLogsCollection() async {
    var logs = FirebaseFirestore.instance
        .collection("users")
        .doc("scholars")
        .collection(userID)
        .doc("dtrlogs")
        .collection("logs");
    var querySnapshot = await logs.get();
    if (mounted) {
      setState(() {
        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = {};
          data = queryDocumentSnapshot.data();
          Logs myLogs = Logs(
            timeIn: data["timein"],
            timeOut: data["timeout"],
            date: data["date"],
            signature: data["signature"],
            multiplier: data["multiplier"],
          );
          dataList.add(myLogs);
        }
      });
    }
  }
}
