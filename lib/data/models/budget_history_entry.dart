import 'package:budget_wise/data/models/savings_goal.dart';
import 'package:budget_wise/data/models/transaction.dart';
import 'package:budget_wise/services/app_services.dart';
import 'package:hive/hive.dart';
part 'budget_history_entry.g.dart';

@HiveType(typeId: 11) // Unique typeId for Hive
class BudgetHistoryEntry {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime updatedAt;

  @HiveField(2)
  String? transactionId; // Link to the transaction that caused the update

  @HiveField(3)
  bool? isForSavings;

  @HiveField(4)
  final double lastAmount;

  BudgetHistoryEntry(
      {required this.amount,
      required this.updatedAt,
      this.transactionId,
      required this.lastAmount,
      this.isForSavings});

  String getMessage() {
    if (isForSavings != null && isForSavings!) {
      SavingsGoal? goal =
          AppServices.savingsGoalService.getSavingsGoal(transactionId!);
      if (goal != null) {
        if (lastAmount > amount) {
          return "Save money for goal :" + goal.name;
        } else {
          return "Get money back from Goal :" + goal.name;
        }
      } else
        return "Savings Goal (deleted)";
    }

    if (isForSavings != null && !isForSavings!) {
      Transaction? transaction =
          AppServices.transactionService.getTransactionById(transactionId!);
      if (transaction != null) {
        String header = transaction.isRecurring ? "Recurring " : "";
        if (lastAmount > amount) {
          return header + "Expense transaction :" + transaction.description!;
        } else {
          return header + "Income transaction :" + transaction.description!;
        }
      } else
        return "Transaction (deleted)";
    }

    if (lastAmount > amount) {
      return "Draw money maually";
    } else {
      return "Deposit money maually";
    }
  }
}
