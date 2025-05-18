import 'dart:io';
import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PdfExporter {
  static Future<void> exportToPdf(
    BuildContext context,
    String title,
    List<Map<String, String>> generalInfo,
    List<Map<String, dynamic>> transactionData,
    List<BudgetHistoryEntry> budgetHistory,
  ) async {
    bool status = await requestStoragePermission();
    final pdf = pw.Document();

    // Load a custom font.
    final ByteData fontData =
        await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Get current month name (as a string).
    DateTime now = DateTime.now();
    String date = now.month.toString() + "-" + now.year.toString();

    // Define maximum rows per page for each table.
    const int maxTransactionRowsPerPage = 20;
    const int maxBudgetRowsPerPage = 20;

    // Build header widget (common for the first page).
    final header = pw.Center(
      child: pw.Text(
        title,
        style: pw.TextStyle(
            fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf),
      ),
    );

    // Build general information widget.
    final generalInfoWidget = pw.Row(
      children: generalInfo.map((info) {
        return pw.Expanded(
            child: pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal: 10),
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(info["title"] ?? "",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 12),
              pw.Text(info["value"] ?? "",
                  style: pw.TextStyle(fontSize: 11, font: ttf)),
              pw.SizedBox(height: 12),
              pw.Text(info["amount"] ?? "",
                  style: pw.TextStyle(fontSize: 11, font: ttf)),
            ],
          ),
        ));
      }).toList(),
    );

    // -----------------------
    // Paginate Transactions Table
    // -----------------------

    // Prepare transactions table data (each row is a list of strings).
    List<List<String>> transactionRows = [];
    if (transactionData.isNotEmpty) {
      transactionRows = transactionData
          .map((item) => item.values.map((v) => "$v").toList())
          .toList();
    }

    // Calculate number of chunks (pages) needed for transactions.
    int tChunks = (transactionRows.length / maxTransactionRowsPerPage).ceil();

    for (int i = 0; i < tChunks; i++) {
      final start = i * maxTransactionRowsPerPage;
      final end = (start + maxTransactionRowsPerPage > transactionRows.length)
          ? transactionRows.length
          : start + maxTransactionRowsPerPage;
      final chunk = transactionRows.sublist(start, end);

      // For the first chunk, include header and general info.
      if (i == 0) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  pw.SizedBox(height: 20),
                  generalInfoWidget,
                  pw.SizedBox(height: 20),
                  pw.Text("List of Transactions:",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf)),
                  pw.SizedBox(height: 10),
                  (transactionRows.isNotEmpty)
                      ? pw.Table.fromTextArray(
                          headers: transactionData.first.keys.toList(),
                          data: chunk,
                          border: pw.TableBorder.all(),
                          cellStyle: pw.TextStyle(fontSize: 12, font: ttf),
                        )
                      : pw.Text("No transactions available.",
                          style: pw.TextStyle(fontSize: 12, font: ttf)),
                ],
              );
            },
          ),
        );
      } else {
        // For subsequent transaction pages, include a continuation header.
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("List of Transactions (cont.):",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf)),
                  pw.SizedBox(height: 10),
                  pw.Table.fromTextArray(
                    headers: transactionData.first.keys.toList(),
                    data: chunk,
                    border: pw.TableBorder.all(),
                    cellStyle: pw.TextStyle(fontSize: 12, font: ttf),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    // -----------------------
    // Paginate Budget History Table
    // -----------------------

    // Prepare budget history table data.
    List<List<String>> budgetRows = budgetHistory.map((entry) {
      return [
        "${entry.updatedAt.day}-${entry.updatedAt.month}-${entry.updatedAt.year}",
        entry.amount.toStringAsFixed(2),
        entry.transactionId != null
            ? entry.transactionId.toString()
            : "manually update"
      ];
    }).toList();

    int bChunks = (budgetRows.length / maxBudgetRowsPerPage).ceil();
    for (int i = 0; i < bChunks; i++) {
      final start = i * maxBudgetRowsPerPage;
      final end = (start + maxBudgetRowsPerPage > budgetRows.length)
          ? budgetRows.length
          : start + maxBudgetRowsPerPage;
      final chunk = budgetRows.sublist(start, end);

      // For the first chunk of budget history, include a header.
      if (i == 0) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Your Budget:",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf)),
                  pw.SizedBox(height: 10),
                  pw.Table.fromTextArray(
                    headers: ["Date", "Remaining Budget", "transactionId"],
                    data: chunk,
                    border: pw.TableBorder.all(),
                    cellStyle: pw.TextStyle(fontSize: 12, font: ttf),
                  ),
                ],
              );
            },
          ),
        );
      } else {
        // For subsequent budget pages, indicate continuation.
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Your Budget (cont.):",
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf)),
                  pw.SizedBox(height: 10),
                  pw.Table.fromTextArray(
                    headers: ["Date", "Remaining Budget", "transactionId"],
                    data: chunk,
                    border: pw.TableBorder.all(),
                    cellStyle: pw.TextStyle(fontSize: 12, font: ttf),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    // -----------------------
    // Save the PDF.

    if (status) {
      String? selectedFolder = await FilePicker.platform.getDirectoryPath();
      if (selectedFolder != null) {
        final file = File("$selectedFolder/$title.pdf");
        await file.writeAsBytes(await pdf.save());
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Lottie.asset('assets/images/Animation.json'),
          ),
        );

        // Wait for 3 seconds before navigating
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final manageStorage = Permission.manageExternalStorage;

      // Check if permanently denied
      if (await manageStorage.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      // Request permission if not granted
      if (await manageStorage.isDenied || await manageStorage.isRestricted) {
        final status = await manageStorage.request();
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }
        return false;
      }

      // Already granted
      return true;
    } else {
      // iOS or other platforms
      final status = await Permission.storage.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }
  }

  static void exportCurrentMonthData(BuildContext context) async {
    DateTime now = DateTime.now();
    int expensesNumber = AppServices.transactionService
        .getExpensesFromMonthYear(now.year, now.month)
        .length;
    int incomesNumber = AppServices.transactionService
        .getIncomesFromMonthYear(now.year, now.month)
        .length;

    String currency = AppServices.userService.getCurrentUser()!.currency;
    double expenseTotal = AppServices.transactionService
        .calculateTotalExpensesByMonth(now.year, now.month);

    double incomeTotal = AppServices.transactionService
        .calculateTotalIncomeByMonth(now.year, now.month);
    double netTotal = incomeTotal - expenseTotal;

    List<Transaction> transactions = await AppServices.transactionService
        .getAllTranasactionsForMonth(now.year, now.month);

    List<Map<String, dynamic>> sampleData =
        transactions.map((item) => item.toJson()).toList();
    List<Map<String, String>> generalInfo = [
      {
        "title": "Total Incomes",
        "value": "$incomesNumber transactions",
        "amount": "$incomeTotal $currency"
      },
      {
        "title": "Total Expenses",
        "value": "$expensesNumber transactions",
        "amount": "$expenseTotal $currency"
      },
      {
        "title": "Net Balance",
        "value": "current month balance",
        "amount": "$netTotal $currency"
      },
    ];
    String month = now.month.toString() + " - " + now.year.toString();
    await exportToPdf(context, "Monthly Report  $month", generalInfo,
        sampleData, await AppServices.budgetService.getAllHistory());
  }

  static void exportCustomData(
      BuildContext context, DateTime start, DateTime end) async {
    int expensesNumber = AppServices.transactionService
        .getExpensesForCustomDate(start, end)
        .length;
    int incomesNumber = AppServices.transactionService
        .getIncomesForCustomDate(start, end)
        .length;

    String currency = AppServices.userService.getCurrentUser()!.currency;
    double expenseTotal = AppServices.transactionService
        .calculateTotalExpenseForCustomDate(start, end);

    double incomeTotal = AppServices.transactionService
        .calculateTotalIncomeForCustomDate(start, end);
    double netTotal = incomeTotal - expenseTotal;

    List<Transaction> transactions = await AppServices.transactionService
        .getTransactionForCustomDate(start, end);
    List<Map<String, dynamic>> sampleData =
        transactions.map((item) => item.toJson()).toList();
    List<Map<String, String>> generalInfo = [
      {
        "title": "Total Incomes",
        "value": "$incomesNumber transactions",
        "amount": "$incomeTotal $currency"
      },
      {
        "title": "Total Expenses",
        "value": "$expensesNumber transactions",
        "amount": "$expenseTotal $currency"
      },
      {
        "title": "Net Balance",
        "value": "current month balance",
        "amount": "$netTotal $currency"
      },
    ];
    String startD = DateFormat.yMMMd().format(start);
    String endD = DateFormat.yMMMd().format(end);
    await exportToPdf(context, "Custom Report $startD - $endD", generalInfo,
        sampleData, await AppServices.budgetService.getAllHistory());
  }
}
