import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:hksa/models/logs.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateTable(
      {required List<Logs> dataListObj,
      required String fullName,
      required String totalHours,
      required String hkType}) async {
    final logInBox = Hive.box("myLoginBox");
    late var userID = logInBox.get("userID");
    String totalHoursRequired = "";
    if (hkType == "HK25") {
      totalHoursRequired = "60";
    } else if (hkType == "HK50" || hkType == "HK75") {
      totalHoursRequired = "90";
    } else {
      totalHoursRequired = "Non-Faci";
    }
    final headers = [
      'Date',
      'Time In',
      'Time Out',
      'Multiplier',
      'Professor Name'
    ];
    final pdf = Document();
    final data = dataListObj
        .map((logs) => [
              logs.date,
              logs.timeIn,
              logs.timeOut,
              logs.multiplier,
              logs.profName
            ])
        .toList();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => Header(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: TextStyle(
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Text("Student ID: "),
                  Text(
                    userID,
                    style: TextStyle(
                      color: PdfColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("HK Category: "),
                  Text(
                    hkType.replaceAll("HK", ""),
                    style: TextStyle(
                      color: PdfColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        build: (Context context) => <Widget>[
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            cellStyle: const pw.TextStyle(
              fontSize: 8.5,
            ),
            cellAlignment: (Alignment.center),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Total Hours to be rendered: "),
                      Text(
                        totalHoursRequired,
                        style: TextStyle(
                          color: PdfColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Total Hours rendered: "),
                      Text(
                        totalHours,
                        style: TextStyle(
                          color: PdfColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Verified by: "),
                      Text("________________________"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Approved by: "),
                      SizedBox(height: 1.5),
                      Text(
                        "JOLINA GAMBOA, LPT",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: PdfColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Student Facilitator Coordinator"),
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
    String fileName =
        "${fullName.replaceAll(" ", "_").toUpperCase()}_${hkType}_DTR";
    return saveDocument(name: fileName, pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
