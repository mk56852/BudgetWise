import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/budget_history_widget.dart';
import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:flutter/material.dart';

class BudgetHistoryScreen extends StatelessWidget {
  final List<BudgetHistoryEntry> history;
  const BudgetHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 10,
      ),
      InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
          )),
      SizedBox(
        height: 10,
      ),
      Center(
        child: Container(
          height: 80,
          width: 80,
          child: Icon(
            Icons.history,
            size: 48,
          ),
        ),
      ),
      Center(
        child: Text(
          "Budget History",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      SizedBox(
        height: 35,
      ),
      Column(
        children: history
            .map((item) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.5,
                  ),
                  child: AppContainer(child: BudgetHistoryItem(history: item)),
                ))
            .toList(),
      )
    ]));
  }
}
