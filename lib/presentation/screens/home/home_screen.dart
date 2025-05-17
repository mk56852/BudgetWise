import 'package:budget_wise/core/constants/theme.dart';
import 'package:budget_wise/data/models/budget.dart';
import 'package:budget_wise/data/models/budget_history_entry.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/presentation/screens/goals/add_goal_screen.dart';
import 'package:budget_wise/presentation/screens/home/widgets/goal_progress.dart';
import 'package:budget_wise/presentation/screens/home/widgets/recent_transactions.dart';
import 'package:budget_wise/presentation/screens/home/widgets/theme_mode_icon.dart';
import 'package:budget_wise/presentation/screens/notification/notification_screen.dart';
import 'package:budget_wise/presentation/screens/transactions/add_transaction_screen.dart';
import 'package:budget_wise/presentation/sharedwidgets/SectionTitle.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/presentation/sharedwidgets/app_container.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Function navigate;
  Budget currentBudget = AppServices.budgetService.getBudget()!;
  HomeScreen({super.key, required this.navigate});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _visible = false;
  late int numberOfNewNotif = 0;

  @override
  void initState() {
    super.initState();
    numberOfNewNotif =
        AppServices.notificationService.getNewNotificationLength();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Theme.of(context).extension<AppTheme>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        generateBudgetInfo(appTheme, numberOfNewNotif),
        SizedBox(height: 10),
        Center(
            child: Text(
          "Last 6 Budget Updates",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        )),
        BudgetChart(),
        SizedBox(height: 20),
        SectionTitle(
          text: "Recent Transactions",
        ),
        TransactionsList(numberOfItems: 4, showAll: () => widget.navigate(1)),
        SizedBox(
          height: 20,
        ),
        SectionTitle(
          text: "Savings Goals",
        ),
        SizedBox(height: 12),
        SavingsGoalItems(
          numberOfItems: 4,
          showAll: () => widget.navigate(2),
        )
      ],
    );
  }

  Widget generateMenuIcons(AppTheme theme, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ThemeModeIcon(),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationScreen())),
          child: Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                child: Hero(
                  tag: "NotifBull",
                  child: Icon(
                    Icons.notifications_active,
                    color: theme.iconColorInsideContainer,
                    size: 30,
                  ),
                ),
              ),
              if (length != 0)
                Positioned(
                  top: 1,
                  right: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white60),
                    height: 17,
                    width: 17,
                    child: Center(child: Text(length.toString())),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget generateBudgetInfo(AppTheme theme, int newItems) {
    return ValueListenableBuilder(
        valueListenable: AppServices.budgetService.budgetBoxListenable,
        builder: (context, Box<Budget> box, _) {
          return AppContainer(
            color: theme.containerColor3,
            child: Column(
              children: [
                generateMenuIcons(theme, newItems),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.currentBudget.amount}",
                        style: TextStyle(
                          color: theme.textColorInsideContainer,
                          fontSize: 37,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        AppServices.userService.getCurrentUser()!.currency,
                        style: TextStyle(
                            color: theme.textColorInsideContainer,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      " You Current Available Budget ",
                      style: TextStyle(
                          color: theme.textColorInsideContainer, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: AppIconButton(
                          icon: Icons.download,
                          insideContainer: true,
                          onTap: () => addMoney(context),
                          text: "Deposit"),
                    ),
                    Expanded(
                      child: AppIconButton(
                          icon: Icons.upload,
                          insideContainer: true,
                          onTap: () => removeMoney(context),
                          text: "Withdraw"),
                    ),
                    Expanded(
                      child: AppIconButton(
                          icon: Icons.savings,
                          insideContainer: true,
                          onTap: () => widget.navigate(2),
                          text: "Save for goal"),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> removeMoney(BuildContext context) async {
    double? enteredAmount = await showAmountDialog(context);
    if (enteredAmount == null || enteredAmount <= 0) return;

    Budget budget = AppServices.budgetService.getBudget()!;
    budget.update(budget.amount - enteredAmount);

    await AppServices.budgetService.updateBudget(budget);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Amount deleted from budget !")),
    );
  }

  Future<void> addMoney(BuildContext context) async {
    double? enteredAmount = await showAmountDialog(context);
    if (enteredAmount == null || enteredAmount <= 0) return;

    Budget budget = AppServices.budgetService.getBudget()!;
    budget.update(budget.amount + enteredAmount);
    await AppServices.budgetService.updateBudget(budget);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Amount Added to budget !")),
    );
  }

  Future<double?> showAmountDialog(BuildContext context) async {
    TextEditingController amountController = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Amount"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter amount"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                double? amount = double.tryParse(amountController.text);
                Navigator.pop(context, amount);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class TransactionsList extends StatelessWidget {
  final int numberOfItems;
  final Function showAll;
  const TransactionsList(
      {super.key, required this.numberOfItems, required this.showAll});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppServices.transactionService.transactionsListenable,
      builder: (context, Box<Transaction> box, _) {
        List<Transaction> transactions =
            AppServices.transactionService.getLastTransactions(numberOfItems);

        if (transactions.isEmpty) {
          return Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "No Items",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppActionButton(
                      height: 50,
                      text: "add new",
                      icon: Icons.add,
                      onTab: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTransactionScreen())),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AppActionButton(
                        height: 50,
                        text: "Show All",
                        icon: Icons.add,
                        onTab: showAll),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...transactions.map((transaction) =>
                  RecentTransactions(transaction: transaction)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppActionButton(
                      height: 50,
                      text: "Add New",
                      icon: Icons.add,
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTransactionScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppActionButton(
                        height: 50,
                        text: "Show All",
                        icon: Icons.list,
                        onTab: showAll),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class SavingsGoalItems extends StatelessWidget {
  final int numberOfItems;
  final Function showAll;
  const SavingsGoalItems(
      {super.key, required this.numberOfItems, required this.showAll});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppServices.savingsGoalService.savingsGoalBoxListenable,
      builder: (context, savingsGoalsBox, _) {
        List<SavingsGoal> savingsGoals =
            AppServices.savingsGoalService.getLastSavingsGoals(numberOfItems);
        if (savingsGoals.isEmpty) {
          return Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "No Items",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppActionButton(
                      height: 50,
                      text: "Add New",
                      icon: Icons.add,
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSavingsGoalScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppActionButton(
                        height: 50,
                        text: "Show All",
                        icon: Icons.list,
                        onTab: showAll),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              ...savingsGoals.map((goal) => GoalProgress(goal: goal)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppActionButton(
                      height: 50,
                      text: "Add New",
                      icon: Icons.add,
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSavingsGoalScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppActionButton(
                        height: 50,
                        text: "Show All",
                        icon: Icons.list,
                        onTab: showAll),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class BudgetChart extends StatelessWidget {
  const BudgetChart({super.key});
  List<FlSpot> _mapBudgetHistoryToSpots(List<BudgetHistoryEntry> history) {
    return history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();
  }

  /// Formats date as "EEE - dd - MM" for the x-axis
  String _formatDate(int index, List<BudgetHistoryEntry> history) {
    if (index < 0 || index >= history.length) return "";
    return history[index].amount.toString();
    // return DateFormat('EEE - dd').format(history[index].updatedAt);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);
    AppTheme theme = appTheme.extension<AppTheme>()!;

    return ValueListenableBuilder(
        valueListenable: AppServices.budgetService.budgetBoxListenable,
        builder: (_, Box<Budget> box, w) {
          List<BudgetHistoryEntry> budgetHistory =
              List.from(AppServices.budgetService.getBudget()!.history);

          // Sort by date
          budgetHistory.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

          // Ensure we always have 5 items
          int requiredItems = 6;
          int missingItems = requiredItems - budgetHistory.length;

          if (missingItems > 0) {
            DateTime firstDate = budgetHistory.isNotEmpty
                ? budgetHistory.first.updatedAt
                : DateTime.now(); // Default to now if empty

            for (int i = 0; i < missingItems; i++) {
              budgetHistory.insert(
                0,
                BudgetHistoryEntry(
                  amount: 0,
                  lastAmount: 0,
                  updatedAt:
                      firstDate.subtract(Duration(days: missingItems - i)),
                ),
              );
            }
          } else {
            // Take only the last 5 items
            budgetHistory =
                budgetHistory.sublist(budgetHistory.length - requiredItems);
          }

          return Container(
            height: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: 1,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            _formatDate(value.toInt(), budgetHistory),
                            style:
                                TextStyle(color: theme.textColor, fontSize: 12),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _mapBudgetHistoryToSpots(budgetHistory),
                    isCurved: true,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    color: appTheme.brightness == Brightness.dark
                        ? Colors.white
                        : theme.containerColor3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: appTheme.brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : theme.containerColor3.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          );

          /// Maps BudgetHistoryEntry list into FlSpot points
        });
  }
}
