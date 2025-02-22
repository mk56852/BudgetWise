import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;
  final Function? refresh;
  const TransactionDetailsScreen(
      {super.key, required this.transaction, this.refresh});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  const Center(
                    child: Text(
                      "Transaction Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              _detailItem("ID", transaction.id),
              _detailItem("Type", transaction.type),
              _detailItem(
                  "Amount", "\$${transaction.amount.toStringAsFixed(2)}"),
              _detailItem(
                  "Category", transaction.categoryId ?? "Not specified"),
              _detailItem(
                  "Date", transaction.date.toLocal().toString().split(' ')[0]),
              _detailItem(
                  "Is Recurring", transaction.isRecurring ? "YES" : "NO"),
              _detailItem(
                  "Description", transaction.description ?? "No description"),
              SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: AppActionButton(
                    text: "Delete Transaction",
                    icon: Icons.delete,
                    onTab: () =>
                        _showDeleteConfirmation(context, transaction.id),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this transaction?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AppServices.transactionService.deleteTransaction(transactionId);
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                    context); // Return to previous screen after deletion
                if (refresh != null) refresh!();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white)),
          SizedBox(
            width: 30,
          ),
          Flexible(
              child: Text(value,
                  overflow: TextOverflow.visible, // Prevent overflow

                  style: TextStyle(fontSize: 15, color: Colors.white))),
        ],
      ),
    );
  }
}
