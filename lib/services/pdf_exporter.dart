import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfExporter {
  static Future<void> exportToPdf(
      String title, List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();

    // Load a custom font
    final ByteData fontData =
        await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Get current month name
    String monthName = DateTime.now().toLocal().toString().split('-')[1];

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("$title - $monthName",
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: data.isNotEmpty ? data.first.keys.toList() : [],
              data: data.map((item) => item.values.toList()).toList(),
              border: pw.TableBorder.all(),
              cellStyle: pw.TextStyle(fontSize: 12, font: ttf),
            ),
          ],
        ),
      ),
    );

    // Save the PDF

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
