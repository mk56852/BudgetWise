import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/core/constants/categories.dart'; // Importing categories
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/Incomes_chart.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/budget_chart.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/spending_chart.dart';
import 'package:budget_wise/presentation/screens/analytics/widgets/tranasction_chart.dart';
import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:budget_wise/presentation/sharedwidgets/info_card.dart';
import 'package:budget_wise/presentation/sharedwidgets/toggle_button.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:budget_wise/services/pdf_exporter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_wise/data/models/expense_limit.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importing ExpenseLimit

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String month = "current";

  void switchAnalytics() {
    setState(() {
      month = month == "current" ? "previous" : "current";
    });
  }

  void exportCurrentMonthData() async {
    List<Map<String, dynamic>> sampleData = [
      {"Category": "Food", "Amount": 200.0},
      {"Category": "Transport", "Amount": 150.0},
      {"Category": "Entertainment", "Amount": 100.0},
    ];

    await PdfExporter.exportToPdf("Monthly Report", sampleData);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    double budgetAmount = month == "current"
        ? AppServices.budgetService.getBudget()!.amount
        : AppServices.analyticsService.getCurrentMonthAnalytics()!.totalBudget;
    double totalSaves = month == "current"
        ? AppServices.savingsGoalService.getAllSavedAmount()
        : AppServices.analyticsService.getCurrentMonthAnalytics()!.savedForGoal;

    int goalsNumber =
        AppServices.savingsGoalService.getAllSavingsGoals().length;
    int achievedGoal = AppServices.savingsGoalService
        .getAllSavingsGoals()
        .where((goal) => goal.isAchieved)
        .length;
    double totalExpense = month == "current"
        ? AppServices.transactionService
            .calculateTotalExpensesByMonth(today.year, today.month)
        : AppServices.analyticsService.getCurrentMonthAnalytics()!.expenseTotal;
    double totalIncome = month == "current"
        ? AppServices.transactionService
            .calculateTotalIncomeByMonth(today.year, today.month)
        : AppServices.analyticsService.getCurrentMonthAnalytics()!.incomeTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Analytics",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        AppToggleButton(
            equalSize: true,
            items: ["Current Month", "Last Month"],
            onSelected: (item) => switchAnalytics()),
        SizedBox(height: 16),
        Animate(
          effects: [
            FadeEffect(duration: 400.ms),
            SlideEffect(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
              duration: 400.ms,
              curve: Curves.easeOut,
            ),
          ],
          onPlay: (controller) => controller.forward(),
          delay: (200).ms,
          child: Row(children: [
            Expanded(
                child: InfoCard(
              title: "Expenses",
              subTitle: "Total expense",
              body: "$totalExpense DT",
              graphColor: Colors.blue.withOpacity(0.5),
              isPositive: false,
            )),
            SizedBox(width: 6),
            Expanded(
                child: InfoCard(
              title: "Incomes",
              subTitle: "Total incomes",
              body: "$totalIncome DT",
              graphColor: Colors.blue.withOpacity(0.5),
              isPositive: true,
            )),
          ]),
        ),
        SizedBox(
          height: 5,
        ),
        Animate(
            effects: [
              FadeEffect(duration: 400.ms),
              SlideEffect(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
            ],
            onPlay: (controller) => controller.forward(),
            delay: (300).ms,
            child: Row(
              children: [
                Expanded(
                    child: InfoCard(
                        title: "Savings Goal",
                        subTitle: "Total Savings goal",
                        body: goalsNumber.toString() + " Goals",
                        graphColor: Colors.blue.withOpacity(0.5),
                        isPositive: true)),
                SizedBox(width: 6),
                Expanded(
                    child: InfoCard(
                        title: "Achieved Goals",
                        subTitle: "Total achieved goal",
                        body: achievedGoal.toString() + " Goals",
                        graphColor: Colors.blue.withOpacity(0.5),
                        isPositive: true))
              ],
            )),
        SizedBox(
          height: 5,
        ),

        Animate(
            effects: [
              FadeEffect(duration: 400.ms),
              SlideEffect(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
            ],
            onPlay: (controller) => controller.forward(),
            delay: (400).ms,
            child: AppContainer(
                child: Column(
              children: [
                _generateTitle("Budget progress per month"),
                BudgetChart(),
              ],
            ))),
        SizedBox(height: 5),
        BudgetWidget(availableBudget: budgetAmount, savedForGoals: totalSaves),
        SizedBox(height: 5),

        SavingsGoalsProgress(),
        SizedBox(height: 10),
        AppContainer(
          child: Column(
            children: [
              _generateTitle("Expenses by Category"),
              SizedBox(height: 16),
              SpendingBarChart(),
            ],
          ),
        ),

        SizedBox(height: 10),
        AppContainer(
          child: Column(
            children: [
              _generateTitle("Incomes by Category"),
              SizedBox(height: 16),
              IncomesBarChart(),
            ],
          ),
        ),

        SizedBox(height: 16),
        _generateTitle("Your Monthly Expense Limit"),
        SizedBox(height: 16),
        // Added Wrap widget containing appCategoriesWithIcons
        Center(
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            children: [
              ...appCategoriesWithIcons.map((category) {
                // Retrieve the expense limits
                final expenseLimits =
                    AppServices.expenseLimitService.getExpenseLimits();
                final limit = expenseLimits
                    .firstWhere(
                      (expenseLimit) =>
                          expenseLimit.categoryName == category.name,
                      orElse: () =>
                          ExpenseLimit(categoryName: category.name, limit: 0),
                    )
                    .limit;

                return GestureDetector(
                  onTap: () {
                    TextEditingController limitController =
                        TextEditingController(text: limit.toString());
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 400,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Update Limit for ${category.name}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: limitController,
                                decoration: InputDecoration(
                                  labelText: 'Limit',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  double newLimit =
                                      double.tryParse(limitController.text) ??
                                          limit;

                                  // Check if the limit already exists
                                  int index = expenseLimits.indexWhere(
                                      (e) => e.categoryName == category.name);

                                  if (index != -1) {
                                    // Update existing limit
                                    AppServices.expenseLimitService
                                        .updateExpenseLimit(
                                            index, category.name, newLimit);
                                  } else {
                                    // Add new limit if it doesn't exist
                                    AppServices.expenseLimitService
                                        .addExpenseLimit(
                                      category.name,
                                      newLimit,
                                    );
                                  }

                                  setState(() {
                                    // Refresh the screen to show updated limits
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: _CategoryLimitWidget(
                      name: category.name,
                      icon: category.icon,
                      limit: limit, // Set limit from expense limits
                      usedAmount: AppServices.transactionService
                              .getTotalExpensesForCategories()[category.name] ??
                          0 // Retrieve used amount
                      ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _generateTitle(String title) {
    return Center(
      child: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _CategoryLimitWidget({
    required String name,
    required IconData icon,
    required double limit,
    required double usedAmount,
    bool available = true,
  }) {
    double progress = (limit > 0) ? (usedAmount / limit).clamp(0.0, 1.0) : 0.0;
    bool warning = limit < usedAmount;
    return Opacity(
      opacity: available ? 1 : 0.2,
      child: Container(
        width: 110,
        height: 160,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.containerColor2,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 4,
              color: Colors.black.withOpacity(.25),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    warning ? Colors.redAccent : Colors.greenAccent,
              ),
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "\$${usedAmount.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blueAccent.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetWidget extends StatelessWidget {
  final double availableBudget;
  final double savedForGoals;

  const BudgetWidget({
    Key? key,
    required this.availableBudget,
    required this.savedForGoals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalBudget = availableBudget + savedForGoals;

    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Total Budget",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(220, 220, 220, 1)),
          ),
          const SizedBox(height: 4),
          Text(
            "\$${totalBudget.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Pie Chart with Animation
          SizedBox(
            height: 190,
            child: PieChart(
              PieChartData(
                sections: _buildChartSections(),
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                // Animation properties
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Budget Details
          _buildLegend("Available Budget", Colors.blue, availableBudget),
          _buildLegend("Saved for Goals", Colors.white, savedForGoals),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: availableBudget,
        title:
            "${(availableBudget / (availableBudget + savedForGoals) * 100).toStringAsFixed(1)}%",
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.white,
        value: savedForGoals,
        title:
            "${(savedForGoals / (availableBudget + savedForGoals) * 100).toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }

  Widget _buildLegend(String label, Color color, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            "$label: \$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class SavingsGoalsProgress extends StatelessWidget {
  const SavingsGoalsProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SavingsGoal> goals =
        AppServices.savingsGoalService.getAllSavingsGoals();
    double totalSaved = goals.fold(0, (sum, goal) => sum + goal.savedAmount);
    double totalTarget = goals.fold(0, (sum, goal) => sum + goal.targetAmount);
    double overallProgress =
        totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;

    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Savings Progress",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            "\$${totalSaved.toStringAsFixed(2)} saved of \$${totalTarget.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: overallProgress,
              backgroundColor: Colors.grey.withOpacity(0.2),
              color: Colors.white,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(overallProgress * 100).toStringAsFixed(1)}% completed",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
