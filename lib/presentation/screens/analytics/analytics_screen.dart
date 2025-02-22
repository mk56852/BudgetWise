import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/Incomes_chart.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/spending_chart.dart';
import 'package:budget_wise/presentation/sharedwidgets/info_card.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    double budgetAmount = AppServices.budgetService.getBudget()!.amount;
    double totalSaves = AppServices.savingsGoalService.getAllSavedAmount();
    int budgetPercent = calculatePercentage(budgetAmount, totalSaves);
    int savesPercent = calculatePercentage(totalSaves, budgetAmount);
    int goalsNumber =
        AppServices.savingsGoalService.getAllSavingsGoals().length;
    int achievedGoal = AppServices.savingsGoalService
        .getAllSavingsGoals()
        .where((goal) => goal.isAchieved)
        .length;
    double totalExpense = AppServices.transactionService
        .calculateTotalExpensesByMonth(today.year, today.month);
    double totalIncome = AppServices.transactionService
        .calculateTotalIncomeByMonth(today.year, today.month);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Analytics",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        _generateTitle("General Informations"),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                child: InfoCard(
                    title: "Expenses",
                    subTitle: "Total expense",
                    body: "$totalExpense DT",
                    graphColor: Colors.redAccent,
                    isPositive: false)),
            SizedBox(
              width: 6,
            ),
            Expanded(
                child: InfoCard(
                    title: "Incomes",
                    subTitle: "Total incomes",
                    body: "$totalIncome DT",
                    graphColor: Colors.greenAccent,
                    isPositive: true))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: InfoCard(
                    title: "Savings Goal",
                    subTitle: "Total Savings goal",
                    body: goalsNumber.toString() + " Goals",
                    graphColor: Colors.greenAccent,
                    isPositive: true)),
            SizedBox(
              width: 6,
            ),
            Expanded(
                child: InfoCard(
                    title: "Achieved Goals",
                    subTitle: "Total achieved goal",
                    body: achievedGoal.toString() + " Goals",
                    graphColor: Colors.redAccent,
                    isPositive: true))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        _generateTitle("Your Budget"),
        SizedBox(
          height: 16,
        ),
        _buildBudgetInfo(budgetPercent, budgetAmount, savesPercent, totalSaves),
        SizedBox(
          height: 16,
        ),
        _generateTitle("Expenses by Category"),
        SizedBox(
          height: 16,
        ),
        SpendingBarChart(),
        SizedBox(
          height: 16,
        ),
        _generateTitle("Incomes by Category"),
        SizedBox(
          height: 16,
        ),
        IncomesBarChart()
      ],
    );
  }

  Widget _generateTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _buildBudgetInfo(int bPer, double bVal, int sPer, double sVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      color: Colors.white70,
                      value: bPer.toDouble(),
                      title: "$bPer %",
                      radius: 40,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.blueAccent.withOpacity(0.1),
                      value: sPer.toDouble(),
                      title: "$sPer %",
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _generateInfoItem(
                  "Available Budget",
                  "$bVal DT",
                  Colors.blueAccent.withOpacity(0.1),
                ),
                _generateInfoItem(
                    "Saved For Goals", "${sVal}DT", Colors.white70),
                _generateInfoItem(
                    "Total Budget", "${sVal + bVal} DT", Colors.transparent),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _generateInfoItem(String text, String body, Color cColor) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(color: cColor, shape: BoxShape.circle),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(color: Colors.white70),
              ),
            )
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          body,
          style: TextStyle(color: Colors.white, fontSize: 14),
        )
      ],
    );
  }
}
