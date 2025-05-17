import 'package:budget_wise/core/constants/Colors.dart';
import 'package:budget_wise/presentation/screens/goals/add_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:budget_wise/core/utils/utils.dart';
import 'package:budget_wise/data/models/budget.dart';
import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/presentation/screens/MainScreen.dart';
import 'package:budget_wise/presentation/sharedwidgets/action_button.dart';
import 'package:budget_wise/presentation/sharedwidgets/tip_widget.dart';
import 'package:budget_wise/services/app_services.dart';

class GoalsDetails extends StatefulWidget {
  final SavingsGoal goal;
  final Function? refresh;
  const GoalsDetails({super.key, required this.goal, this.refresh});

  @override
  _GoalsDetailsState createState() => _GoalsDetailsState();
}

class _GoalsDetailsState extends State<GoalsDetails> {
  late SavingsGoal _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  Future<void> addMoneyFromBudget() async {
    double? enteredAmount = await showAmountDialog();
    if (enteredAmount == null || enteredAmount <= 0) return;

    Budget? budget = AppServices.budgetService.getBudget();
    if (budget == null || budget.amount < enteredAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient budget!")),
      );
      return;
    }
    double requiredAmount = _goal.targetAmount - _goal.savedAmount;
    if (enteredAmount >= requiredAmount) {
      enteredAmount = requiredAmount;
    }

    setState(() {
      budget.lastAmount = budget.amount;
      budget.amount -= enteredAmount!;
      _goal.savedAmount += enteredAmount;
      if (_goal.savedAmount >= _goal.targetAmount) _goal.isAchieved = true;
    });

    await AppServices.budgetService.updateBudgetWithIds(budget, true, _goal.id);
    await AppServices.savingsGoalService.updateSavingsGoal(_goal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Amount added !")),
    );
  }

  Future<void> deleteGoal() async {
    bool? confirmDelete = await showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      bool? returnToBudget = await showReturnToBudgetDialog();
      if (returnToBudget == true) {
        Budget budget = AppServices.budgetService.getBudget()!;
        budget.update(budget.amount + _goal.savedAmount);
        await AppServices.budgetService
            .updateBudgetWithIds(budget, true, _goal.id);
      }
      await AppServices.savingsGoalService.deleteSavingsGoal(_goal.id);
      if (mounted) {
        if (widget.refresh != null) {
          widget.refresh!();
        }
        Navigator.pop(context);
      }
    }
  }

  Future<bool?> showReturnToBudgetDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Return to Budget'),
          content:
              Text('Do you want to return the saved amount to the budget ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showDeleteConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Goal"),
          content: Text(
              "Are you sure you want to delete this savings goal? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel deletion
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm deletion
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeMoneyToBudget() async {
    double? enteredAmount = await showAmountDialog();
    if (enteredAmount == null || enteredAmount <= 0) return;

    Budget budget = AppServices.budgetService.getBudget()!;
    setState(() {
      budget.lastAmount = budget.amount;
      budget.amount += enteredAmount;
      _goal.savedAmount -= enteredAmount;
    });

    await AppServices.budgetService.updateBudgetWithIds(budget, true, _goal.id);
    await AppServices.savingsGoalService.updateSavingsGoal(_goal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Amount back again to budget !")),
    );
  }

  Future<void> addMoneyManually() async {
    double? enteredAmount = await showAmountDialog();
    if (enteredAmount == null || enteredAmount <= 0) return;

    setState(() {
      _goal.savedAmount += enteredAmount;
    });

    await AppServices.savingsGoalService.updateSavingsGoal(_goal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External funds added !")),
    );
  }

  Future<void> deleteMoneyManually() async {
    double? enteredAmount = await showAmountDialog();
    if (enteredAmount == null || enteredAmount <= 0) return;

    setState(() {
      _goal.savedAmount -= enteredAmount;
    });

    await AppServices.savingsGoalService.updateSavingsGoal(_goal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You spent Money from this goal !")),
    );
  }

  Future<double?> showAmountDialog() async {
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String currency = AppServices.userService.getCurrentUser()!.currency;
    final f = DateFormat('dd-MM-yyyy');
    int? daysRest;
    String description = _goal.notes ?? "there is no description";
    int savingDaily = _goal.getDailySavingsTarget();
    if (_goal.deadline != null) {
      daysRest = _goal.deadline!.difference(DateTime.now()).inDays;
    }
    return MainContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 26)),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  _goal.name,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Created at: ${f.format(_goal.createdAt)}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: CircularPercentIndicator(
                  radius: 83.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: (_goal.getProgressPercentage()).toDouble() / 100,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Color(0xFF1F1F1F)
                      : Colors.blueGrey,
                  progressColor: theme.brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.darkBlueColor,
                  center: Text(
                    "${_goal.getProgressPercentage()}%",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 115,
                      child: _buildSummaryCard(
                        theme: theme,
                        amount: _goal.savedAmount,
                        title: "Saved Amount",
                        withDetails: false,
                        isPositive: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 115,
                      child: _buildSummaryCard(
                        theme: theme,
                        amount: _goal.targetAmount,
                        title: "Target Amount",
                        withDetails: false,
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Center(
            child: TipWidget(
              message: generatePriorityMessage(_goal.priority, daysRest),
              iconColor: Colors.green,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (daysRest != null)
            TipWidget(
              message: generateDayLeftMessage(daysRest),
              iconColor: Colors.green,
            ),
          SizedBox(
            height: 10,
          ),
          if (savingDaily != 0)
            TipWidget(
              message: "You can save $savingDaily " +
                  currency +
                  " each day and you will achieve your goal",
              iconColor: Colors.green,
            ),
          SizedBox(height: 20),

          Text(
            'Management:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppIconButton(
                  icon: Icons.download,
                  onTap: addMoneyFromBudget,
                  text: "Money from budget",
                ),
              ),
              Expanded(
                child: AppIconButton(
                    icon: Icons.upload,
                    onTap: removeMoneyToBudget,
                    text: "Money to budget"),
              ),
              Expanded(
                child: AppIconButton(
                    icon: Icons.add_circle,
                    onTap: () => addMoneyManually(),
                    text: "Add external Funds"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AppIconButton(
                  icon: Icons.remove_circle,
                  onTap: deleteMoneyManually,
                  text: "Spend from Goal",
                ),
              ),
              Expanded(
                child: AppIconButton(
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSavingsGoalScreen(
                            savingsGoal: _goal,
                          ),
                        ),
                      ).then((updatedGoal) {
                        if (updatedGoal != null && updatedGoal is SavingsGoal) {
                          setState(() {
                            _goal = updatedGoal;
                          });
                        }
                      });
                    },
                    text: "Edit Goal"),
              ),
              Expanded(
                child: AppIconButton(
                    icon: Icons.delete_forever,
                    onTap: deleteGoal,
                    text: "Delete Goal"),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Goal Description:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  description,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  'Deadline',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              if (_goal.deadline != null)
                Text(
                  f.format(_goal.deadline!),
                )
              else
                Text(
                  "Deadline not set",
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required ThemeData theme,
    required String title,
    required double amount,
    double? percentageChange,
    required bool isPositive,
    bool withDetails = true,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title & Percentage Change
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
              percentageChange != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.greenAccent.withOpacity(0.2)
                            : Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(1)}%",
                        style: TextStyle(
                            color: isPositive
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 12),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          const SizedBox(height: 8),

          // Amount
          Text(
            "\$${amount.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // View Details Button
          withDetails
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("View details",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
