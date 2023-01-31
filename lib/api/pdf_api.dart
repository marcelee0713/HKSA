import 'dart:io';

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
      required String totalHours}) async {
    final headers = ['Date', 'Time In', 'Time Out', 'Multiplier', 'Signature'];
    final pdf = Document();
    final data = dataListObj
        .map((logs) => [
              logs.date,
              logs.timeIn,
              logs.timeOut,
              logs.multiplier,
              logs.signature
            ])
        .toList();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => Header(
          text: fullName,
          textStyle: TextStyle(
            color: PdfColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        build: (Context context) => <Widget>[
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            cellStyle: const pw.TextStyle(
              fontSize: 10,
            ),
            cellAlignment: (Alignment.center),
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
