import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hksa/models/logs.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateTable(
      {required List<Logs> dataListObj,
      required String fullName,
      required String totalHours}) async {
    final headers = ['Date', 'Time In', 'Time-Outs', 'Signature'];
    final pdf = Document();
    final data = dataListObj
        .map((logs) => [logs.date, logs.timeIn, logs.timeOut, logs.signature])
        .toList();

    pdf.addPage(
      MultiPage(
        build: (Context context) => <Widget>[
          Paragraph(
              text: fullName,
              style: TextStyle(
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          Table.fromTextArray(
            headers: headers,
            data: data,
          ),
          SizedBox(height: 8),
          Paragraph(
            text: "Total hours: $totalHours",
          )
        ],
      ),
    );
    return saveDocument(name: 'logs.pdf', pdf: pdf);
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
