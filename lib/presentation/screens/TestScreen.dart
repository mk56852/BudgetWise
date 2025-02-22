import 'package:budget_wise/data/models/budget.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Budget b = AppServices.budgetService.getBudget()!;
                    print("${b.amount}  ${b.lastUpdated}  ${b.history.length}");
                  },
                  child: Text("budget")),
              ElevatedButton(
                  onPressed: () {
                    List<Transaction> b =
                        AppServices.transactionService.getAllTransactions();
                    print(b.length);
                  },
                  child: Text("Transactions"))
            ],
          ),
        ),
      ),
    );
  }
}
